LOG_FILE=/tmp/redis

source common.sh

echo "Setup yum Repo for Redis"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
StatusCheck $?

echo "Installing Redis"
yum install redis-6.2.11 -y &>>$LOG_FILE
StatusCheck $?

echo "Update Redis IP in Config from 127.0.0.1 to 0.0.0.0"

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
StatusCheck $?


systemctl enable redis &>>$LOG_FILE

echo "Start Redis"
systemctl start redis &>>$LOG_FILE
StatusCheck $?
