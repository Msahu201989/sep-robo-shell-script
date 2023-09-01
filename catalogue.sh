LOG_FILE=/tmp/catalogue

ID=$(id-u)
if [ $ID -ne 0 ]; then
  echo You should run this Script as root user or with sudo Privileges.
  exit 1
  fi

echo "Setup NodeJS REPO"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
  fi


echo "INSTALL NODEJS"
yum install nodejs -y &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
  fi

echo "Creating Roboshop USER"
useradd roboshop &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
  fi

echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
  fi

cd /home/roboshop

echo "Extracting Catalogue Application code"
unzip /tmp/catalogue.zip &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
  fi
mv catalogue-main catalogue
cd /home/roboshop/catalogue
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
  fi

echo "Installing Nodejs Dependencies"
npm install &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
  fi

#MONGO_DNSNAME

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
  fi

systemctl daemon-reload &>>$LOG_FILE
 systemctl start catalogue &>>$LOG_FILE
 systemctl enable catalogue &>>$LOG_FILE
