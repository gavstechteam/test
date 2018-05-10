#!/bin/bash
sudo yum install tomcat
sudo systemctl start tomcat
 sudo systemctl enable tomcat
 sudo systemctl status tomcat
 sudo rm -f /var/run/yum.pid
