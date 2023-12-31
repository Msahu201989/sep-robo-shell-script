LOG_FILE=/tmp/mogodb

source common.sh

echo "Setting up MogoDB Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
StatusCheck $?

echo "Installing MongoDB Server"
yum install -y mongodb-org &>>LOG_FILE
StatusCheck $?

echo "Update MongoDB Listen Address"
sed -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>LOG_FILE
StatusCheck $?


echo "Starting Mongodb Service"
 systemctl enable mongod &>>LOG_FILE
 systemctl restart mongod &>>LOG_FILE
 StatusCheck $?

echo "Downloading Mongo Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
StatusCheck $?

cd /tmp
echo "Extratcing Schema File"
unzip -o mongodb.zip &>>LOG_FILE
StatusCheck $?

cd mongodb-main

echo "Load CataLogues Service Schema"
mongo < catalogue.js &>>LOG_FILE
StatusCheck $?

echo "Load Users Service Schema"
mongo < users.js &>>LOG_FILE
StatusCheck $?

