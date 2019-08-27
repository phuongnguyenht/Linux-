# ------------------ Install php 7.2 and install lib for php connect to oracle -----------------


yum --enablerepo=remi-php72 install php-oci8
cat /etc/ld.so.conf.d/oracle-instantclient.conf
sudo sh -c "echo /usr/lib/oracle/12.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf"
vi /etc/php.ini  (them vào extension=oci8.so cuoi file)


--------------------------------------------------------------------------------
yum --enablerepo=remi-php72 install php-pear php-devel 

lib cho gói pecl

---- Cai lib oracle client -----------
wget https://download.oracle.com/otn/linux/instantclient/11204/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm?AuthParam=1565841654_91e9bba296991dd99f3dbf69c49a6c58
oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
wget https://download.oracle.com/otn/linux/instantclient/11204/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm?AuthParam=1565841924_49e1482ae6b7c8a63ce513bf99386fac
oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm

vi /etc/profile.d/oracle.sh
	```
		export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib
	```
source /etc/profile.d/oracle.sh
  
cd /usr/include/oracle/11.2/client64
cd /usr/include/oracle/11.2/client
ln -s /usr/include/oracle/11.2/client64 /usr/include/oracle/11.2/client
ln -s /usr/lib/oracle/11.2/client64 /usr/lib/oracle/11.2/client
  
------------------- Setup PDO_OCI -----------------------------------------------
wget http://be.php.net/distributions/php-7.2.21.tar.gz --no-check-certificate
tar xfvz php-7.2.21.tar.gz
cd php-7.2.21/ext/pdo_oci/
phpize
[root@cms01 pdo_oci]# phpize
Configuring for:
PHP Api Version:         20170718
Zend Module Api No:      20170718
Zend Extension Api No:   320170718
[root@cms01 pdo_oci]# ./configure --with-pdo-oci=instantclient,/usr/lib/oracle/11.2/client64/lib,11.2
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E

[root@cms01 pdo_oci]# make install

echo "extension=pdo_oci.so" >> /etc/php.d/pdo_oci.ini
php -i | grep oci
service php-fpm restart

-----------------------Check install php-oci-----------------------
[root@cms01 ~]# rpm -qa | grep oci
php-oci8-7.2.21-1.el6.remi.x86_64

Tham khao: https://koscek.wordpress.com/2018/11/01/setup-pdo_oci-oci8-in-centos-6-10-with-php-7-2/
https://shiki.me/blog/installing-pdo_oci-and-oci8-php-extensions-on-centos-6-4-64bit