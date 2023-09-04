LOG_FILE=/tmp/user

source common.sh

echo "Downlod NodeJs Component"
 curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOG_FILE
 StatusCheck $?

 echo " Installing Nodejs"
 yum install nodejs -y &>>$LOG_FILE
 StatusCheck $?

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
 echo "Adding Roboshop User"
useradd roboshop &>>$LOG_FILE
StatusCheck $?
 fi


 echo "Download User Application Code"
 curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$LOG_FILE
 StatusCheck $?

 cd /home/roboshop
 echo "clean old App content"
 rm -rf catalogue &>>$LOG_FILE
 StatusCheck $?

 echo "Extracting Catalogue Application code"
 unzip -o /tmp/user.zip &>>$LOG_FILE
 StatusCheck $?

 echo "Moving App data"
 mv user-main user &>>$LOG_FILE
 cd /home/roboshop/user
 StatusCheck $?

 echo "Installing Nodejs Dependencies"
 npm install &>>$LOG_FILE
 StatusCheck $?

echo "Updating SystemD service File"
sed -i -e 's/Redis_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' /home/roboshop/user/systemd.service &>>$LOG_FILE
StatusCheck $?

 echo "Setup User Service"
 mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>$LOG_FILE
 StatusCheck $?

 echo "Start Catalogue service"
  systemctl daemon-reload &>>$LOG_FILE
  systemctl start user &>>$LOG_FILE
  systemctl enable user &>>$LOG_FILE
  StatusCheck $?



#Update `REDIS_ENDPOINT` with Redis Server IP
#
#Update `MONGO_ENDPOINT` with MongoDB Server IP
