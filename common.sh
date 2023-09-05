ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this Script as root user or with sudo Privileges.
  exit 1
  fi

StatusCheck() {
if [ $1 -eq 0 ]; then
  echo -e status = "\e[32mSUCCESS\e[0m"
else
  echo -e status = "\e[31mFAILURE\e[0m"
  exit 1
  fi
}

NODEJS() {

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


   echo "Download ${COMPONENT} Application Code"
   curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG_FILE
   StatusCheck $?

   cd /home/roboshop
   echo "clean old App content"
   rm -rf ${COMPONENT} &>>$LOG_FILE
   StatusCheck $?

   echo "Extracting ${COMPONENT} Application code"
   unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
   StatusCheck $?

   echo "Moving App data"
   mv ${COMPONENT}-main ${COMPONENT} &>>$LOG_FILE
   cd /home/roboshop/${COMPONENT}
   StatusCheck $?

   echo "Installing Nodejs Dependencies"
   npm install &>>$LOG_FILE
   StatusCheck $?

   echo "Updating SystemD service File"
   sed -i -e 's/Redis_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE}
   StatusCheck $?

    echo "Setup ${COMPONENT} Service"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
    StatusCheck $?

    echo "Start ${COMPONENT} service"
     systemctl daemon-reload &>>${LOG_FILE}
     systemctl start ${COMPONENT} &>>${LOG_FILE}
     systemctl enable ${COMPONENT} &>>${LOG_FILE}
     StatusCheck $?

}