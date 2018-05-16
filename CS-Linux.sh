tomcat="true"
java="true"

if [ $tomcat == "true" ]
then
 sudo yum install tomcat
 sudo systemctl start tomcat
 sudo systemctl enable tomcat
 sudo systemctl status tomcat
 sudo rm -f /var/run/yum.pid
fi

if [ $java == "true" ]
then
 sudo yum install java-1.8.0-openjdk
 java -version
 sudo rm -f /var/run/yum.pid
fi