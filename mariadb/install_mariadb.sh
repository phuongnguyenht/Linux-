#!/bin/sh
# Description: Automatic install Mariadb
# Author: Phuongnguyen

file="/etc/yum.repos.d/MariaDB.repo"
if [ -f "$file" ]
then
	echo "$file found."
	
else
	echo "$file not found."
	touch "$file"
	echo "[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" > "$file"
	yum install MariaDB-server MariaDB-client -y
	systemctl start mariadb
	systemctl enable mariadb
	systemctl status mariadb
	mysql_secure_installation
fi

galera_new_cluster