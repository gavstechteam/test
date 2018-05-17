java="true"

if [ $java == "true" ]
then
 sudo yum install java-1.8.0-openjdk
 java -version
 sudo rm -f /var/run/yum.pid
fi


