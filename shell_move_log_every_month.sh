! /bin/sh
#### Move log into forlder , at localhost ###
# list forlder in file /opt/scripts/listforlder .

lastm1=`/bin/date -d '-1 month' +%Y-%m`
lastm2=`/bin/date -d '-1 month' +%Y_%m`
lastm=`/bin/date -d '-1 month' +%Y%m`
echo $lastm1 $lastm2 $lastm

while read a
do
	cd $a
	echo $a
	/bin/date

	mkdir f$lastm
	mv *$lastm* f$lastm
	mv *$lastm1* f$lastm

done < /opt/scripts/listforlder

