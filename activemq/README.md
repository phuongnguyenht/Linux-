# Highly available and load balanced ActiveMQ cluster

** Requirement: **
* jdk1.8.0_131
* ActiveMQ (apache-activemq-5.14.3-bin.tar.gz)
* Zookeeper (zookeeper-3.4.8.tar.gz)
* Centos 7

```
show version
activemq --version
ActiveMQ 5.14.3
```
1. Install OpenJDK JRE 8
```
wget --no-cookies --no-check-certificate --header "Cookie:oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
yum -y localinstall jdk-8u131-linux-x64.rpm
java –version
```

2. Install ActiveMQ
```
wget https://archive.apache.org/dist/activemq/5.14.3/apache-activemq-5.14.3-bin.tar.gz
tar -zxvf apache-activemq-5.14.3-bin.tar.gz -C /opt
mv apache-activemq-5.14.3/ activemq
vi /usr/lib/systemd/system/activemq.service
[Unit]
Description=activemq message queue
After=network.target
[Service]
PIDFile=/opt/activemq/data/activemq.pid
ExecStart=/opt/activemq/bin/activemq start
ExecStop=/opt/activemq/bin/activemq stop
User=root
Group=root
[Install]
WantedBy=multi-user.target

http://X.Y.Z.T:8161/admin/
Account: admin/admin 
```

3. Install and configuration zookeeper
```
wget https://archive.apache.org/dist/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz
mkdir –p /var/lib/zookeeper/
tar -zxvf zookeeper-3.4.8.tar.gz -C /opt/
cd /opt/ && mv zookeeper-3.4.8 zookeeper
cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg
vi /opt/zookeeper/conf/zoo.cfg
tickTime=2000
initLimit=5
syncLimit=2
dataDir=/var/lib/zookeeper
clientPort=2182
maxClientCnxns=60
server.1=IP01:2888:3888
server.2=IP02:2888:3888
server.3=IP03:2888:3888

On each server
Server 01:
echo 1 > /var/lib/zookeeper/myid
Server 02:
echo 2 > /var/lib/zookeeper/myid
Server 03:
echo 3 > /var/lib/zookeeper/myid

vi /usr/lib/systemd/system/zookeeper.service
[Unit]
Description=Apache Zookeeper
After=network.target
[Service]
PIDFile=/var/lib/zookeeper/zookeeper_server.pid 
ExecStart=./opt/zookeeper/bin/zkServer.sh start
ExecStop=./opt/zookeeper/bin/zkServer.sh stop
User=root
Group=root
[Install]
WantedBy=multi-user.target

- Start/ Stop service: cd /opt/zookeeper/bin && ./zkServer.sh start
```
4. Configuration activemq

* Server 01: vi /opt/activemq/conf/activemq.xml
```
- Comment kahaDB
	<!--	
		<kahaDB directory="${activemq.data}/kahadb"/>
	-->
- Add more LevelDB section:
<persistenceAdapter>
		<!--	
		<kahaDB directory="${activemq.data}/kahadb"/>
		-->
		
		<replicatedLevelDB
            	directory="${activemq.data}/leveldb"
        	replicas="3"
                bind="tcp://0.0.0.0:0"
                zkAddress="IP01:2182,IP01:2182,IP01:2182"
                zkPassword="4Campaign"
                hostname="IP01"
                sync="local_disk"

		/>
		
        </persistenceAdapter>
```
* Server 02: vi /opt/activemq/conf/activemq.xml
```
- Comment kahaDB
	<!--	
		<kahaDB directory="${activemq.data}/kahadb"/>
	-->
- Add more LevelDB section:
<persistenceAdapter>
		<!--	
		<kahaDB directory="${activemq.data}/kahadb"/>
		-->
		
		<replicatedLevelDB
            	directory="${activemq.data}/leveldb"
        	replicas="3"
                bind="tcp://0.0.0.0:0"
                zkAddress="IP01:2182,IP01:2182,IP01:2182"
                zkPassword="4Campaign"
                hostname="IP02"
                sync="local_disk"

		/>
		
        </persistenceAdapter>
```
* Server 03: vi /opt/activemq/conf/activemq.xml
```
- Comment kahaDB
	<!--	
		<kahaDB directory="${activemq.data}/kahadb"/>
	-->
- Add more LevelDB section:
<persistenceAdapter>
		<!--	
		<kahaDB directory="${activemq.data}/kahadb"/>
		-->
		
		<replicatedLevelDB
            	directory="${activemq.data}/leveldb"
        	replicas="3"
                bind="tcp://0.0.0.0:0"
                zkAddress="IP01:2182,IP01:2182,IP01:2182"
                zkPassword="4Campaign"
                hostname="IP03"
                sync="local_disk"

		/>
		
        </persistenceAdapter>
```
5. Configuration mirrow to another queue name
```
	<!--
        Modify ActiveMQ mirrow by Phuongnt
   	 -->
	<destinationInterceptors>
        <virtualDestinationInterceptor>
            <virtualDestinations>
                <compositeQueue name="CALLEVENT" forwardOnly="false">
					<forwardTo>
						<queue physicalName="Queue name01"/>
						<queue physicalName="Queue name02"/>
					 </forwardTo>
                  </compositeQueue>
            </virtualDestinations>
        </virtualDestinationInterceptor>
    </destinationInterceptors>
	<!--
        End Modify ActiveMQ mirrow by Phuongnt
   	 -->

```
6. Add config to Haproxy
```
listen activemq_cluster *:61620
  #balance  source
  #option  tcpka
  #option  httpchk
  #option  tcplog
  mode tcp
  option forceclose
  option tcp-check
  server activemq-app01 10.144.40.66:61616 backup check inter 1s rise 2 fall 5
  server activemq-app02 10.144.40.67:61616 check inter 1s rise 2 fall 5
  server activemq-app03 10.144.40.68:61616 backup check inter 1s rise 2 fall 5
```
7. Example 
* Server 01: 10.144.40.66
* Server 02: 10.144.40.67
* Server 03: 10.144.40.68