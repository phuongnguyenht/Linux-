#!/bin/bash
#echo "Installing Elasticsearch on Centos 7"
# Turn off selinux 
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
#$NUM =`cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+'`

#yum update -y
cd /opt  && mkdir -p setup  && cd setup
if [ -e elasticsearch-5.2.2.rpm ]
then
	echo  elasticsearch-5.2.2.rpm exists! 
	#rm -rf elasticsearch-5.2.2
	#tar -zxvf elasticsearch-5.2.2.tar.gz
else
	#wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.2.tar.gz
	wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.2.rpm
	yum install elasticsearch-5.2.2.rpm -y
fi 

systemctl daemon-reload
#systemctl enable elasticsearch.service
#systemctl start elasticsearch.service
echo -e "alias estop=systemctl stop elasticsearch" >> ~/.bashrc 
echo -e "alias estart=systemctl start elasticsearch" >> ~/.bashrc 
echo -e "alias erestart=systemctl restart elasticsearch" >> ~/.bashrc 

#check elasticsearch installed
#curl -XGET 'localhost:9200/?pretty'

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
	wget https://artifacts.elastic.co/downloads/kibana/kibana-5.2.2-x86_64.rpm
	yum install kibana-5.2.2-x86_64.rpm -y
else
	wget https://artifacts.elastic.co/downloads/kibana/kibana-5.2.2-i686.rpm
	yum install kibana-5.2.2-i686.rpm -y
fi

systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service
echo -e "alias kstop=systemctl stop kibana" >> ~/.bashrc 
echo -e "alias kstart=systemctl start kibana" >> ~/.bashrc 
echo -e "alias krestart=systemctl restart kibana" >> ~/.bashrc

if [ -e logstash-5.2.2.rpm ]
then
	echo  logstash-5.2.2.rpm exists! 
else
	wget https://artifacts.elastic.co/downloads/logstash/logstash-5.2.2.rpm
	yum install logstash-5.2.2.rpm -y
fi

systemctl daemon-reload
systemctl enable logstash.service
systemctl start logstash.service
echo -e "alias lstop=systemctl stop logstash" >> ~/.bashrc 
echo -e "alias lstart=systemctl start logstash" >> ~/.bashrc 
echo -e "alias lrestart=systemctl restart logstash" >> ~/.bashrc

###Install Nginx
#install repo
yum -y install epel-release
#echo -e "[nginx] \nname=nginx repo \nbaseurl=http://nginx.org/packages/centos/$releasever/$basearch/ \ngpgcheck=0 \nenabled=1" >> /etc/yum.repos.d/nginx.repo
yum install nginx httpd-tools -y

systemctl daemon-reload
systemctl enable nginx.service
systemctl start nginx.service
echo -e "alias nstop=systemctl stop nginx" >> ~/.bashrc 
echo -e "alias nstart=systemctl start nginx" >> ~/.bashrc 
echo -e "alias nrestart=systemctl restart nginxcd" >> ~/.bashrc

# check nginx
nginx -v
#nginx version: nginx/1.10.2

#create password for nginx login on brower
expect <<END
	spawn htpasswd -c /etc/nginx/.htpasswd admin
	expect "New password:"
	send "admin\r"
	expect "Re-type new password:"
	send "admin\r"
	expect eof
END

#auth_basic "Restricted"; 
#auth_basic_user_file /etc/nginx/.htpasswd; 







 
