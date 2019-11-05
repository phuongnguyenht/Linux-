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

3. Install zookeeper
```
wget https://archive.apache.org/dist/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz
mkdir –p /var/lib/zookeeper/
tar -zxvf zookeeper-3.4.8.tar.gz -C /opt/
cd /opt/ && mv zookeeper-3.4.8 zookeeper
cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg
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


```
