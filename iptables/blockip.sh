#/bin/sh
# Description check ip scan and want to login server
# Author: PhuongNT

threshold=4
#listip=`cat /var/log/secure | grep "Failed password for invalid user"|awk '{print $13}' | sort -n | uniq -c | awk '{$1=$1};1' | sed 's/ /,/g'`
file="/opt/Scripts/ipblock"
whitelist="/opt/Scripts/whitelist"
today=`/bin/date +"%d"`
mon=`/bin/date +"%b"`
count=`cat $file | wc -l`
echo $count
if [ $today -lt "10" ]; then
	ngay=$(echo $today | sed 's/^0*/ /')
	dt="$mon $ngay"
	listip=$(cat /var/log/secure | grep "`echo "$dt" | sed 's/ / /'`" | grep "Failed password for invalid user" | awk '{print $13}' | sort -n | uniq -c | awk '{$1=$1};1' | sed 's/ /,/g')
	listiproot=$(cat /var/log/secure | grep "`echo "$dt" | sed 's/ / /'`" | grep "Failed password for root from" | awk '{print $11}' | sort -n | uniq -c | awk '{$1=$1};1' | sed 's/ /,/g')
else
	dt=`/bin/date +"%b  %d"`
	echo $dt
	listip=$(cat /var/log/secure | grep "`echo "$dt"`" | grep "Failed password for invalid user"|awk '{print $13}' | sort -n | uniq -c | awk '{$1=$1};1' | sed 's/ /,/g')
	listiproot=$(cat /var/log/secure | grep "`echo "$dt"`" | grep "Failed password for root from" | awk '{print $11}' | sort -n | uniq -c | awk '{$1=$1};1' | sed 's/ /,/g')
fi

# Case user normal not root
for line in $listip; do
	echo $line
	stt=`echo $line | cut -d ',' -f1`
	ip=`echo $line | cut -d ',' -f2`
	if [ $stt -gt $threshold ]
	then
		cat $file | grep $ip
		if [[ "$?" == "0" ]];then
		        echo "co $ip trong file ipblock roi"
		else
			echo "them $ip trong file ipblock"
			#Check ip co trong file whitelist hay khong
			cat $whitelist | grep $ip
			if [[ "$?" == "0" ]];then
		        echo "Co trong whitelist"
			else
				echo "Khong co trong whitelist them $ip nay vao ipblock"
				echo "$ip" >> $file
			fi
		fi 
		
	else
		echo "$ip chua den nguong cho vao ipblock"
	fi 
	
#	exit 0
done

# Case user root
for line in $listiproot; do
	echo $line
	stt=`echo $line | cut -d ',' -f1`
	ip=`echo $line | cut -d ',' -f2`
	if [ $stt -gt $threshold ]
	then
		cat $file | grep $ip
		if [[ "$?" == "0" ]];then
		    echo "co $ip trong file ipblock roi "
		else
			echo "them $ip trong file ipblock"
			#Check ip co trong file whitelist hay khong
			cat $whitelist | grep $ip
			if [[ "$?" == "0" ]];then
		        echo "Co trong whitelist"
			else
				echo "Khong co trong whitelist them $ip nay vao ipblock"
				echo "$ip" >> $file
			fi
		fi 
		
	else
		echo "$ip chua den nguong cho vao ipblock"
	fi 
	
#	exit 0
done
#
count_after=`cat $file | wc -l`
echo "count first: $count After: $count_after"
if [ $count -eq $count_after ]; then
	echo "Khong co Ip moi nao duoc them vao file block"
else
	countIp=$(($count_after - $count))	
	echo "Da them $countIp vao block list"
	/etc/init.d/iptables
fi

echo "Finished"
