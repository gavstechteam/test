#!/bin/bash

# This Script is to install the following application JAVA, Tomcat, MySQL & Httpd by passing the application name as arguments.
# To install all applications (JAVA, Tomcat, MySQL, Httpd), use command “bash apps_install.sh all”
# If only specific applications need to be installed, pass specific application name as argument. use command “bash apps_install.sh JavaRE Tomcat Httpd MySQL”.

OS=`uname`

## Perform basic checks
if [ "$OS" != "Linux" ]; then
    echo "====================================> This is not a Linux server. Exiting..."
    exit 1
else
    echo "Linux OS has been confirmed"
fi

## Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "====================================> You must be root to run this script." 1>&2
    exit 1
fi

install_tomcat(){

 yum install -y tomcat

}

install_httpd(){

yum install -y httpd
yum list installed httpd

}

install_Java(){

yum install -y java

}

install_MySQL(){

wget https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm
rpm -ivh mysql80-community-release-el7-1.noarch.rpm
yum install -y mysql-server

}


# YUM Update and Upgrade
echo "========================================> Updating and Upgrading"
yum update -y && yum upgrade -y
yum install -y epel-release wget

for apps in $@
do
if [[ $apps == "all" ]]; then
  echo "====================================> Installing JavaRE"
  install_Java
  echo "====================================> Installing Tomcat"
  install_tomcat
  echo "====================================> Installing Httpd"
  install_httpd
  echo "====================================> Installing MySQL"
  install_MySQL
elif [[ $apps == "Tomcat" ]]; then
  echo "====================================> Installing Tomcat"
  install_tomcat
elif [[ $apps == "Httpd" ]]; then
  echo "====================================> Installing Httpd"
  install_httpd
elif [[ $apps == "JavaRE" ]]; then
  echo "====================================> Installing JavaRE"
  install_Java
elif [[ $apps == "MySQL" ]]; then
  echo "====================================> Installing MySQL"
  install_MySQL
fi
done
