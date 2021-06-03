####Instruction to Setup the Environment and run the scripts####

#public ip:18.220.98.155
#Public DNS:ec2-18-220-98-155.us-east-2.compute.amazonaws.com

#Download and save the private key file Web-Test5.pem in Desktop of the server machine

#Copy the ssh.sh file to the home directory
#Change ssh.sh file permission and make it executable (chmod +x ssh.sh)
#Execute ssh.sh to connect to EC2 server (./ssh.sh)

#Once connected to the EC2 server(Amazon Linux 2),

#Current directory should be /home/ec2-user

#Check Webserver Status
#execute status.sh (./status.sh)

#To verify the the results has been save to db
#DB username = admin1
#DB password = awsdb123#$
#DB name = ApplicationDB
#Table name = WEB_STATUS
#Execute the command (mysql -h web-database-1.ccswmhkmtl8y.us-east-2.rds.amazonaws.com -P 3306 -u admin1 -p)
#In MySQL terminal execute (use ApplicationDB)
#In MySQL terminal execute (select * from WEB_STATUS)

#Collect logfiles
#execute logcollect.sh (./logcollect.sh)

#To verfy the log has been uploaded to the S3 bucket
#S3 bucket Webserver_Logfile url:s3://webservers3/WebServer_LogFiles/

#script Log file available in /home/ec2-user/scriptlog


