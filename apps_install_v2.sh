#!/bin/bash

# This Script is to install the following application JAVA, Tomcat, MySQL & Httpd by passing the application name as arguments.
# To install all applications (JAVA, Tomcat, MySQL, Httpd), use command “bash apps_install.sh all”
# If only specific applications need to be installed, pass specific application name as argument. use command “bash apps_install.sh JavaRE Tomcat Httpd MySQL”.

Os=`uname -s`

## Perform basic checks
if [ "$Os" != "Linux" ]; then
    echo "========================================================================> This is not a Linux server. Exiting..."
    exit 1
else
    echo "This is a Linux Server"
fi

## Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "========================================================================> You must be root to run this script." 1>&2
    exit 1
fi

## Check for Linux Distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    Dist=$PRETTY_NAME
    Ver=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    Dist=$(lsb_release -si)
    Ver=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    Dist=$DISTRIB_ID
    Ver=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    Dist=Debian
    Ver=$(cat /etc/debian_version)
else
    Dist=$(uname -s)
    Ver=$(uname -r)
fi
echo "Linux Distribution ==> $Dist"
echo "Version ==> $Ver"

## Function for installing Tomcat on specific Linux Distribution
install_tomcat(){
  case $1 in
    *Ubuntu*)
      apt-get install -y tomcat7 tomcat7-docs tomcat7-examples tomcat7-admin
      ;;
    *SUSE*)
      zypper install -y tomcat
      ;;
    *Red*)
      yum install -y tomcat
      ;;
    *CentOS*)
      yum install -y tomcat
      ;;
    *Oracle*)
      yum install -y tomcat
      ;;
  esac
}

## Function for installing Httpd on specific Linux Distribution
install_httpd(){
  case $1 in
    *Ubuntu*)
      apt-get install -y apache2
      ;;
    *SUSE*)
      zypper in -y apache2 apache2-mod_jk
      ;;
    *Red*)
      yum install -y httpd
      ;;
    *CentOS*)
      yum install -y httpd
      ;;
    *Oracle*)
      yum install -y httpd
      ;;
  esac
}

## Function for installing JavaRE on specific Linux Distribution
install_Java(){
  case $1 in
    *Ubuntu*)
      apt-get install -y default-jdk
      ;;
    *SUSE*)
      zypper install -y java-1_8_0-openjdk
      ;;
    *Red*)
      yum install -y java-1.8.0-openjdk
      ;;
    *CentOS*)
      yum install -y java-1.8.0-openjdk
      ;;
    *Oracle*)
      yum install -y java-1.8.0-openjdk
      ;;
  esac
}

## Function for installing MySQL on specific Linux Distribution
install_MySQL(){
  case $1 in
    *Ubuntu*)
      echo "mysql-server mysql-server/root_password password your_password" | debconf-set-selections
      echo "mysql-server mysql-server/root_password_again password your_password" | debconf-set-selections
      apt-get install -y mysql-server
      ;;
    *SUSE*)
      wget https://repo.mysql.com/mysql80-community-release-sles12-1.noarch.rpm
      rpm -Uvh mysql80-community-release-sles12-1.noarch.rpm
      rpm --import /etc/RPM-GPG-KEY-mysql
      zypper install -y mysql-community-server
      rm -rf mysql80-community-release-sles12-1.noarch.rpm
      ;;
    *Red*)
      wget https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
      rpm -ivh mysql80-community-release-el7-1.noarch.rpm
      yum install -y mysql-server
      rm -rf mysql80-community-release-el7-1.noarch.rpm
      ;;
    *CentOS*)
      wget https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
      rpm -ivh mysql80-community-release-el7-1.noarch.rpm
      yum install -y mysql-server
      rm -rf mysql80-community-release-el7-1.noarch.rpm
      ;;
    *Oracle*)
      wget https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
      rpm -ivh mysql80-community-release-el7-1.noarch.rpm
      yum install -y mysql-server
      rm -rf mysql80-community-release-el7-1.noarch.rpm
      ;;
  esac
}
## Updating the package repos
echo "========================================================================> Updating Repo packages"
case $Dist in
  *Ubuntu*)
    apt-get update -y
    ;;
  *SUSE*)
    zypper update -y
    ;;
  *Red*)
    yum update -y
    ;;
  *CentOS*)
    yum update -y
    ;;
  *Oracle*)
    yum update -y
    ;;
esac

## Installing Application by calling specific functions
for apps in $@
do
  case $apps in
    all)
      echo "========================================================================> Installing JavaRE"
      install_Java "$Dist"
      echo "========================================================================> Installing Tomcat"
      install_tomcat "$Dist"
      echo "========================================================================> Installing Httpd"
      install_httpd "$Dist"
      echo "========================================================================> Installing MySQL"
      install_MySQL "$Dist"
      ;;
    Tomcat)
      echo "========================================================================> Installing Tomcat"
      install_tomcat "$Dist"
      ;;
    Httpd)
      echo "========================================================================> Installing Httpd"
      install_httpd "$Dist"
      ;;
    JavaRE)
      echo "========================================================================> Installing JavaRE"
      install_Java "$Dist"
      ;;
    MySQL)
      echo "========================================================================> Installing MySQL"
      install_MySQL "$Dist"
      ;;
  esac
done
