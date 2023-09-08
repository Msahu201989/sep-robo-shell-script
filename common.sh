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

APP_PREREQ() {
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

}

SYSTEMD_SETUP() {
     echo "Updating SystemD service File"
     sed -i -e 's/Redis_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/'  -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE}
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

NODEJS() {

  echo "Downlod NodeJs Component"
   curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOG_FILE
   StatusCheck $?

   echo " Installing Nodejs"
   yum install nodejs -y &>>$LOG_FILE
   StatusCheck $?


 APP_PREREQ                  # Calling funtion inside funtion We have Same requirement for nodejs & java like create user and all

   echo "Installing Nodejs Dependencies"
   npm install &>>$LOG_FILE
   StatusCheck $?

 SYSTEMD_SETUP                 # calling function inside funtion cause systemd is common in both Java & Nodejs

}

JAVA () {

  echo "Install Maven"
  yum install maven -y &>>${LOG_FILE}
  StatusCheck $?

  APP_PREREQ

 echo "Download Dependencies & Make Package"
 mvn clean package &>>${LOG_FILE}
 mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG_FILE}
 StatusCheck $?

 SYSTEMD_SETUP                # calling function inside funtion cause systemd is common in both Java & Nodejs

}

PYTHON () {

  echo "Install Python 3"
  yum install python36 gcc python3-devel -y &>>${LOG_FILE}
  StatusCheck $?

  APP_PREREQ

  cd /home/roboshop/${COMPONENT}
  echo "Install Python dependency for APP"
  pip3 install -r requirements.txt &>>${LOG_FILE}
  StatusCheck $?

     APP_UID=$(id -u roboshop)
     APP_GID=$(id -g roboshop)

    echo "Update Payment configuration file"
    sed -i -e "/uid/ c uid = ${APP_UID}" -e "/gid/ c gid = ${APP_GID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini &>>${LOG_FILE}
    StatusCheck $?

    SYSTEMD_SETUP

}