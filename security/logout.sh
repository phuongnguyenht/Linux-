#!/bin/sh
# Description: Thiet lap tu dong dang xuat account OS sau 5 Phut khong su dung 
# Author: Phuongnguyen

file="/etc/profile.d/tmount.sh"
if [ -f "$file" ]
then
	echo "$file found."
else
	echo "$file not found."
	cd /etc/profile.d/
	touch tmount.sh
	echo "TMOUT=300" > tmount.sh
	echo "readonly TMOUT" >> tmount.sh
	echo "export TMOUT" >> tmount.sh
	chmod u+x tmount.sh
	chmod g+x tmount.sh
	./tmount.sh
fi