java="true"
tomcat="true"
apacheserver="true"
mysql="true"
dotnet="true"
python="true"
php="true"

if [ $java == "true" ]
then
 sudo yum -y install java-1.8.0-openjdk
 java -version
 sudo rm -f /var/run/yum.pid
fi

if [ $tomcat == "true" ]
then
 sudo yum -y install tomcat
 sudo systemctl start tomcat
 sudo systemctl enable tomcat
 sudo systemctl status tomcat
 sudo rm -f /var/run/yum.pid
fi

if [ $apacheserver == "true" ]
then
 sudo yum -y install httpd;
 sudo systemctl enable httpd.service
 sudo systemctl start httpd.service
 sudo systemctl status httpd.service
 sudo rm -f /var/run/yum.pid
fi

if [ $mysql == "true" ]
then
 sudo yum -y install mariadb-server
 sudo systemctl start mariadb
 sudo systemctl enable mariab
 sudo systemctl status mariadb
 sudo systemctl stop mariadb
 sudo rm -f /var/run/yum.pid
fi

if [ $dotnet == "true" ]
then
 sudo yum -y install centos-release-dotnet
 sudo yum -y install rh-dotnet20
 scl enable rh-dotnet20 bash
 dotnet --version
 sudo rm -f /var/run/yum.pid
fi

if [ $python == "true" ]
then
 yum -y install https://centos7.iuscommunity.org/ius-release.rpm
 yum -y install python36u
 python3.6 -v
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

