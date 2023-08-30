LOG_FILE=/tmp/frontend
echo installing Nginx
yum install nginx -y &>>$LOG_FILE
 echo status = $?

echo downloading nginx web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
 echo status = $?

 cd /usr/share/nginx/html

 echo removing old web content
 rm -rf * &>>$LOG_FILE
 echo status = $?

 echo Extracting web content
 unzip /tmp/frontend.zip &>>$LOG_FILE
 echo status = $?

 mv frontend-main/static/* . &>>$LOG_FILE
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE


 echo starting Nginx Service
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
 echo status = $?