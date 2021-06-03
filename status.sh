#!/bin/bash
  
PUB_DNS=ec2-18-220-98-155.us-east-2.compute.amazonaws.com
OK="$(curl -Is $PUB_DNS | head -1 )"

VALIDATE=( $OK )
DEFAULT_CONTENT=$(cat content.txt)
SCRIPT="status.sh"
CUR_TIME=$(date "+%Y.%m.%d-%H.%M.%S")
#Web Server status check
if [ ${VALIDATE[-2]} == "200" ]
then 
        echo "Server is Up And Running"
	echo "$CUR_TIME: $SCRIPT: Server is Up And Running" >> scriptlog        
	#Content Validate
	CONTENT=$(curl -L $PUB_DNS)

	if [[ "$CONTENT" == "$DEFAULT_CONTENT" ]] 
 	then
        	SERVER_STATUS="Up and Running"
		CONTENT_VALIDATE="Successful"
		echo "$CUR_TIME: $SCRIPT: Content validation successful" >> scriptlog


	else
		SERVER_STATUS="Up and Running"
		CONTENT_VALIDATE="Not Successful"
		echo "$CUR_TIME: $SCRIPT: Error:Content validation failed" >> scriptlog

		echo "Expected Content not available" | mail -v -s "Content Validate Failed" mtkaveesha@gmail.com	
	fi

else      
        echo "Server is Down"
      	SERVER_STATUS="Down"
	CONTENT_VALIDATE="Unable to Validate"
	echo "$CUR_TIME: $SCRIPT: Error:Server is Down:Content validation Failed" >> scriptlog

		#Enable and Start the Apache service	
                echo "Server is starting..."
                sudo systemctl enable httpd.service
                sudo systemctl start httpd.service 
    	
	echo "Web Server is Down. Service Start comand executed" | mail -v -s "Web Server Unavailable" mtkaveesha@gmail.com
	
	echo "$CUR_TIME: $SCRIPT: Error:Server is Starting:Content validation Failed:Notifying email sent" >> scriptlog	
fi


#Save Status to the DB

RDS_MYSQL_ENDPOINT="web-database-1.ccswmhkmtl8y.us-east-2.rds.amazonaws.com"
RDS_MYSQL_PORT=3306
RDS_MYSQL_USER="admin1"
RDS_MYSQL_PASS="awsdb123#$"
RDS_MYSQL_BASE="ApplicationDB"
TABLE="WEB_STATUS"

mysql -h $RDS_MYSQL_ENDPOINT -P $RDS_MYSQL_PORT -u $RDS_MYSQL_USER -p$RDS_MYSQL_PASS -D $RDS_MYSQL_BASE -e "INSERT INTO $TABLE (\`STATUS\`, \`DATE_TIME\`, \`CONTENT_VALIDATE\`) VALUES ('$SERVER_STATUS', NOW(), '$CONTENT_VALIDATE')";

DB_STATUS=$?

if [[ $DB_STATUS -eq 0 ]]
then
    echo "Status Successfully Saved to the DB"
    echo "$CUR_TIME: $SCRIPT: Status Successfully Saved to the DB" >> scriptlog
else 
    echo "DB Operation: Fail"
    echo "Cannot write to the Database. Status is not saved." | mail -v -s "Database Operation Fail" mtkaveesha@gmail.com
    echo "$CUR_TIME: $SCRIPT: Error:DB Operation Failed:Notifying email sent" >> scriptlog	    

fi

