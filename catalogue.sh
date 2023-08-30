LOG_FILE=/tmp/catalogue
echo "Setup NodeJS REPO"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOG_FILE
echo status = $?

echo "INSTALL NODEJS"
yum install nodejs -y &>>$LOG_FILE

echo "Creating Roboshop USER"
useradd roboshop
echo status = $?

echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
echo status = $?

cd /home/roboshop

echo "Extracting Catalogue Application code"
unzip /tmp/catalogue.zip &>>$LOG_FILE
echo status = $?


mv catalogue-main catalogue
cd /home/roboshop/catalogue
echo status = $?

echo "Installing Nodejs Dependencies"
npm install &>>$LOG_FILE
echo status = $?

#MONGO_DNSNAME

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
echo status = $?

systemctl daemon-reload &>>$LOG_FILE
 systemctl start catalogue &>>$LOG_FILE
 systemctl enable catalogue &>>$LOG_FILE
