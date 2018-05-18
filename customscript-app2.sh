apacheserver="true"
php="true"

if [ $apacheserver == "true" ]
then
 sudo yum -y install httpd;
 sudo systemctl enable httpd.service
 sudo systemctl start httpd.service
 sudo systemctl status httpd.service
 sudo rm -f /var/run/yum.pid
fi

if [ $php == "true" ]
then
 sudo yum -y install php php-mysql
 sudo systemctl restart httpd.service
 sudo yum -search php-
 sudo yum -y install name of the module
 sudo vim /var/www/html/info.php
 sudo firewall-cmd --permanent --zone=public --add-service=http
 sudo firewall-cmd --permanent --zone=public --add-service=https
 sudo firewall-cmd --reload
 sudo rm -f /var/run/yum.pid
fi

