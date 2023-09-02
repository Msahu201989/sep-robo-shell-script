LOG_FILE=/tmp/catalogue

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


echo "Setup NodeJS REPO"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOG_FILE
StatusCheck $?

echo "INSTALL NODEJS"
yum install nodejs -y &>>$LOG_FILE
StatusCheck $?

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
  echo "Adding Roboshop User"
useradd roboshop &>>$LOG_FILE
StatusCheck $?
 fi

echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /home/roboshop
echo "clean old App content"
rm -rf catalogue &>>$LOG_FILE
StatusCheck $?

echo "Extracting Catalogue Application code"
unzip /tmp/catalogue.zip &>>$LOG_FILE
StatusCheck $?

echo "Moving App data"
mv catalogue-main catalogue
cd /home/roboshop/catalogue
StatusCheck $?

echo "Installing Nodejs Dependencies"
npm install &>>$LOG_FILE
StatusCheck $?

#MONGO_DNSNAME

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
StatusCheck $?

systemctl daemon-reload &>>$LOG_FILE
 systemctl start catalogue &>>$LOG_FILE
 systemctl enable catalogue &>>$LOG_FILE
