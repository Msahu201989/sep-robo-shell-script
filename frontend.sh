echo installing Nginx
yum install nginx -y

echo downloading nginx web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

 cd /usr/share/nginx/html

 echo removing old web content
 rm -rf *

 echo Extracting web content
 unzip /tmp/frontend.zip

 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

 echo starting Nginx Service
systemctl enable nginx
systemctl restart nginx
