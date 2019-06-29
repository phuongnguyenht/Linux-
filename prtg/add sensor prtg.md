# Prtg add sensor check 

1. Create new sensor (snmp custom) --> get value of database
- create script check
```
cat checktransaction.sh 
#!/bin/bash

#############################
#Author
#Description
#
#############################

mysql -uroot -ppassword -s -N <<QUERY_INPUT
select count(id) cnt from smartgate.transaction_log where created_at < from_unixtime(UNIX_TIMESTAMP(current_date)) and status = 1;
QUERY_INPUT
```

2. Configure snmp service and get oid
```
vi /etc/snmp/snmpd.conf
	rwcommunity	 abcdstring
	extend     checktransactions     /bin/sh    /opt/scripts/checktransaction.sh
```
save and restart servie snmpd 
```
- get oid
	snmptranslate -On NET-SNMP-EXTEND-MIB::nsExtendOutput1Line.\"checktransactions\"
--> oid = 1.3.6.1.4.1.8072.1.3.2.3.1.1.13.99.104.101.99.107.103.105.97.111.100.105.xxx.xxx
```
Documents  http://www.net-snmp.org/wiki/index.php/Tut:Extending_snmpd_using_shell_scripts

https://nsrc.org/workshops/ws-files/2011/sanog17/exercises/exercises-snmp-v1-v2c.html

