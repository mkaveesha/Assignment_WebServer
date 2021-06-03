#!/bin/bash

LOCATION="$(pwd)"
CUR_TIME=$(date "+%Y.%m.%d-%H.%M.%S")
SCRIPT="logcollect.sh"
#S3=s3://webservers3/WebServer_LogFiles/

#copy apache access log to a new file locate in script running location
sudo cp /var/log/httpd/access_log $LOCATION/$CUR_TIME.accessLog.txt
ACCESS_LOG=$?

#copy apache error log to a new file locate in script running location
sudo cp /var/log/httpd/error_log $LOCATION/$CUR_TIME.errorLog.txt
ERROR_LOG=$?

#Get the content of web and to a new file locate in script running location
curl -L ec2-18-220-98-155.us-east-2.compute.amazonaws.com >  $LOCATION/$CUR_TIME.contentLog.txt
CONTENT=$?

if (( $ACCESS_LOG == 0 && $ERROR_LOG == 0 && $CONTENT == 0 ))
then
	#compress into a single file
	tar -czvf $CUR_TIME.Log_Files.tar.gz $CUR_TIME.accessLog.txt $CUR_TIME.errorLog.txt $CUR_TIME.contentLog.txt

	if [ $? == 0 ]
	then
		echo "$CUR_TIME: $SCRIPT: Log files successfully compressed" >> scriptlog
		rm -f $CUR_TIME.accessLog.txt $CUR_TIME.errorLog.txt $CUR_TIME.contentLog.txt
		
		#Upload compress file to S3 bucket
		aws s3 cp $LOCATION/$CUR_TIME.Log_Files.tar.gz s3://webservers3/WebServer_LogFiles/
	
		if [ $? == 0 ]
		then
			echo "Log Files Successfully uploaded."
			rm -f $LOCATION/$CUR_TIME.Log_Files.tar.gz
			echo "$CUR_TIME: $SCRIPT: Log Files Successfully uploaded:Compressed file removed" >> scriptlog

		else
			#send notify email 
			echo "Unable to upload Log Files." | mail -v -s "Log File Upload Fail" mtkaveesha@gmail.com
			echo "$CUR_TIME: $SCRIPT: Unable to upload Log Files:Notifying email sent" >> scriptlog

		fi

	else
		echo "File Compress process failed"
		echo "$CUR_TIME: $SCRIPT: File Compress Failed" >> scriptlog

	fi


else 
	echo "Log files or content cannot be found"
	echo "$CUR_TIME: $SCRIPT: Log files or content cannot be found" >> scriptlog

fi

