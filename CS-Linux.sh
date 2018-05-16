java="true"
python="true"
tomcat="true"
dotnetcore="true"

if [ $java == "true" ]
then
 sudo yum install java-1.8.0-openjdk
 java -version
 sudo rm -f /var/run/yum.pid
fi

if [ $python == "true" ]
then
 sudo yum -y groupinstall development
 sudo yum -y install zlib-level
 wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz
 tar xJf Python-3.6.3.tar.xz
 cd Python-3.6.3
 ./configure
 make install
 sudo rm -f /var/run/yum.pid
fi

if [ $tomcat == "true" ]
then
 sudo yum install tomcat
 sudo systemctl start tomcat
 sudo systemctl enable tomcat
 sudo systemctl status tomcat
 sudo rm -f /var/run/yum.pid
fi

if [ $dotnetcore == "true" ]
then
 sudo yum install centos-release-dotnet
 sudo yum install rh-dotnet20
 scl enable rh-dotnet20 bash
 dotnet --version
 sudo rm -f /var/run/yum.pid
fi
