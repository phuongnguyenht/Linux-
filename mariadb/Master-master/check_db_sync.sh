#!/bin/sh
# Description: Monitor mat dong bo database master master

#MariaDB [(none)]> create user 'report'@'10.84.73.52' identified by 'Rep0rt123a@';
#MariaDB [(none)]> grant SUPER on *.* to 'report'@'10.84.73.52';
#MariaDB [(none)]> flush privileges;

dbhost=10.84.73.52
dbuser=report
dbpass=Rep0rt123a@
dbschema=smartgate
port=3306
Slave_IO_Running=`mysql -u$dbuser -h$dbhost -P$port -p$dbpass -Bse "show slave status\G" | grep Slave_IO_Running | awk '{ print $2 }'`
Slave_SQL_Running=`mysql -u$dbuser  -h$dbhost -P$port -p$dbpass -Bse "show slave status\G" | grep Slave_SQL_Running | awk '{ print $2 }'`

if [ $Slave_SQL_Running == 'No' ] ; then
	echo "loi dong bo"
elif [ $Slave_IO_Running == 'No' ] ; then
	echo "loi dong bo"
else
	echo 0
fi