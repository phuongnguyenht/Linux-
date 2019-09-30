#!/bin/bash
#
#############################
# Author: Phuong Nguyen
# Description: Backup database smartgate and put file to ftp server and delete file on remote ftp server 
# Project: Smartgate
#############################
#
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export PATH

MYSQLDUMP=/usr/bin/mysqldump
BACKUPDIR=/opt/backup/db-smartgate
DB_USER=backup
DB_PASS=passworddb
DAY=7
DATE=`date -d now +%Y%m%d`

FTPUSER=phuongnt
FTPPASS=passwordftp
FTPSERVER=10.84.73.63
RFTP=/usr/bin/ftp
ipvip="10.84.73.85"
ipaddr=`ip a | grep ens160 | grep inet | awk '{print $2}'| grep "/32" |  awk -F '/' '{print $1}'`
#check ipaddr exist or not
#echo $ipaddr
if [ "$ipaddr" == "$ipvip" ]; then
	mkdir -p $BACKUPDIR/mysql_$DATE
	echo 'GIO BAT DAU BACKUP: ' > $BACKUPDIR/mysql_$DATE.log
	date >> $BACKUPDIR/mysql_$DATE.log
	
	$MYSQLDUMP --single-transaction -u$DB_USER -p$DB_PASS --databases smartgate > $BACKUPDIR/mysql_$DATE/smartgate_prod_$DATE.sql

	echo 'GIO KET THUC BACKUP: ' >> $BACKUPDIR/mysql_$DATE.log
	date >> $BACKUPDIR/mysql_$DATE.log
	
	cd $BACKUPDIR
	tar -zcvf mysql_$DATE.tar.gz mysql_$DATE
	rm -rf mysql_$DATE
	find $BACKUPDIR -type f -mtime +$DAY | xargs rm -f 
	
	echo 'GIO NEN XONG, XOA FILE BACKUP CU XONG : ' >> $BACKUPDIR/mysql_$DATE.log
	date >> $BACKUPDIR/mysql_$DATE.log
	
	# FTP push file to server
	echo mysql_$DATE.tar.gz
	DEL_FILE=mysql_`/bin/date -d '-7 day' +%Y%m%d`.tar.gz
	$RFTP -n -v $FTPSERVER << END | tee $BACKUPDIR/temp_$DATE.txt
user $FTPUSER $FTPPASS
put mysql_$DATE.tar.gz
delete $DEL_FILE
END

else
        echo 0
		echo "NOT Exist IP VIP"
        echo "Exit"
fi
