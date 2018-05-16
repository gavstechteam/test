java="true"
tomcat="true"

if [ $java == "true" ]
then
 sudo yum install java-1.8.0-openjdk
 java -version
 sudo rm -f /var/run/yum.pid
fi

if [ $tomcat == "true" ]
then
 sudo yum install tomcat
 sudo systemctl start tomcat.service
 sudo systemctl enable tomcat.service
 sudo systemctl status tomcat.service
 sudo rm -f /var/run/yum.pid
fi

