java="true"
tomcat="true"
mysql="true"
dotnet="true"
python="true"

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

if [ $mysql == "true" ]
then
 sudo yum -y install mariadb-server
 sudo systemctl enable mariadb.service 
 sudo systemctl start mariadb.service
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