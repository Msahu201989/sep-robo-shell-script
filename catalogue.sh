LOG_FILE=/tmp/catalogue
echo "Setup NodeJS REPO"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCESS
else
  echo status = FAILURE
  fi


echo "INSTALL NODEJS"
yum install nodejs -y &>>$LOG_FILE

echo "Creating Roboshop USER"
useradd roboshop
if [ $? -eq 0 ]; then
  echo status = SUCESS
else
  echo status = FAILURE
  fi

echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCESS
else
  echo status = FAILURE
  fi

cd /home/roboshop

echo "Extracting Catalogue Application code"
unzip /tmp/catalogue.zip &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCESS
else
  echo status = FAILURE
  fi
mv catalogue-main catalogue
cd /home/roboshop/catalogue
if [ $? -eq 0 ]; then
  echo status = SUCESS
else
  echo status = FAILURE
  fi

echo "Installing Nodejs Dependencies"
npm install &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCESS
else
  echo status = FAILURE
  fi

#MONGO_DNSNAME

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCESS
else
  echo status = FAILURE
  fi

systemctl daemon-reload &>>$LOG_FILE
 systemctl start catalogue &>>$LOG_FILE
 systemctl enable catalogue &>>$LOG_FILE
