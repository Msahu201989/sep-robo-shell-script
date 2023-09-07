COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/${COMPONENT}



echo "Install Erland & Rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOG_FILE
yum install erlang -y &>>$LOG_FILE
 StatusCheck $?

 echo "setup rabbitmq repo"
 curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
 yum install rabbitmq-server -y &>>$LOG_FILE
  StatusCheck $?

echo "start rabbitmq server"
systemctl enable rabbitmq-server &>>LOG_FILE
systemctl start rabbitmq-server &>>LOG_FILE
 StatusCheck $?

rabbitmqctl list_users | grep roboshop &>>LOG_FILE
if [ $? -ne 0 ]; then
echo "Add app user in rabbitmq"
rabbitmqctl add_user roboshop roboshop123 &>>LOG_FILE
 StatusCheck $?
fi

echo "add app user tag in rabbitmq"
rabbitmqctl set_user_tags roboshop administrator &>>LOG_FILE
 StatusCheck $?

echo "add permission for app user in rabbitmq"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>LOG_FILE
 StatusCheck $?