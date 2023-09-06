LOG_FILE=/tmp/mysql
source common.sh

echo "Setting up MYSQL REPO"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
StatusCheck $?

echo "Install MYSQL"
 yum install mysql-community-server -y &>>$LOG_FILE
 StatusCheck $?

 echo "Start MYSQL Service"
 systemctl enable mysqld &>>$LOG_FILE
 systemctl restart mysqld &>>$LOG_FILE
 StatusCheck $?

echo "seting up password"
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
 StatusCheck $?

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD
('${ROBOSHOP_MYSQL_PASSWORD}');
FLUSH PRIVILEGES;" >/tmp/root-pass.sql

# grep temp /var/log/mysqld.log
#
##Next, We need to change the default root password in order to start using the database service. Use password RoboShop@1 or any other as per your choice. Rest of the options you can choose No
#
# mysql_secure_installation
# mysql -uroot -pRoboShop@1
##> uninstall plugin validate_password;
# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql