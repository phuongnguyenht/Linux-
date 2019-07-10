#!/bin/bash
# Description: Auto install php-fpm and php 7
# Author: PhuongNT

rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install yum-utils -y
yum-config-manager --enable remi-php72
yum -y install epel-release
yum install -y php-fpm
yum install php -y
systemctl enable php-fpm && systemctl start php-fpm
