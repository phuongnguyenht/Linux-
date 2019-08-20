MySQL Cluster with Galera

####################
* Link tham khảo: http://blog.secaserver.com/2012/02/high-availability-mysql-cluster-galera-haproxy/
* Đã thực hiện
* Emai: hocnv2010@gmail.com
###################

Các bước thực hiện:


1. Following steps are similar with my previous post. But in this tutorial, I am going to rewrite it as refer to this case with latest version of Galera and MySQL. I have no MySQL server installed in this server at the moment. Download the latest Galera library, MySQL with wsrep, MySQL client and MySQL shared from MySQL download page:

mkdir -p /usr/local/src/galera
cd /usr/local/src/galera

wget  https://yum.mariadb.org/5.5-galera/centos/7/x86_64/rpms/galera-25.3.26-1.rhel7.el7.centos.x86_64.rpm


wget https://launchpad.net/codership-mysql/5.5/5.5.20-23.4/+download/MySQL-server-5.5.20_wsrep_23.4-1.rhel5.x86_64.rpm

wget http://mirror.centos.org/centos/7/os/x86_64/Packages/boost-program-options-1.53.0-27.el7.x86_64.rpm

wget http://dev.mysql.com/get/Downloads/MySQL-5.5/MySQL-client-5.5.20-1.el6.x86_64.rpm/from/http://ftp.jaist.ac.jp/pub/mysql/

mv index.html MySQL-client-5.5.20-1.el6.x86_64.rpm

wget http://dev.mysql.com/get/Downloads/MySQL-5.5/MySQL-shared-5.5.20-1.el6.x86_64.rpm/from/http://ftp.jaist.ac.jp/pub/mysql/

mv index.html MySQL-shared-5.5.20-1.el6.x86_64.rpm


2. Remove unwanted library and install all the packages in following sequence:

rpm -e --nodeps mariadb-libs
rpm -Uvh boost-program-options-1.53.0-27.el7.x86_64.rpm
rpm -Uhv galera-25.3.26-1.rhel7.el7.centos.x86_64.rpm

rpm -Uhv MySQL-client-5.5.20-1.el6.x86_64.rpm
rpm -Uhv MySQL-shared-5.5.20-1.el6.x86_64.rpm
rpm -Uhv MySQL-server-5.5.20_wsrep_23.4-1.rhel5.x86_64.rpm


3. Start the MySQL service and make sure it start on boot:

chkconfig mysql on
service mysql start

4. Setup the MySQL root password:

/usr/bin/mysqladmin -u root password 'ViV@s2010'

5. Setup the MySQL client for root. Create new text file /root/.my.cnf using text editor and add following line:

[client]
user=root
password='ViV@s2010'

6. Change the permission to make sure it is not viewable by others:

chmod 600 /root/.my.cnf

7. Login to the MySQL server by executing command "mysql" and execute following line. 
We will also need to create another root user called clusteroot with password and haproxy 
without password (for HAProxy monitoring) as stated on variables above:

mysql> DELETE FROM mysql.user WHERE user='';
mysql> GRANT USAGE ON *.* TO root@'%' IDENTIFIED BY 'ViV@s2010';
mysql> UPDATE mysql.user SET Password=PASSWORD('ViV@s2010') WHERE User='root';
mysql> GRANT USAGE ON *.* to sst@'%' IDENTIFIED BY 'sstpass123';
mysql> GRANT ALL PRIVILEGES on *.* to sst@'%';
mysql> GRANT USAGE on *.* to clusteroot@'%' IDENTIFIED BY 'ViV@s2010';
mysql> GRANT ALL PRIVILEGES on *.* to clusteroot@'%';
mysql> INSERT INTO mysql.user (host,user) values ('%','haproxy');
mysql> FLUSH PRIVILEGES;
mysql> quit

8. Create the configuration files and directory, copy the example configuration and create mysql exclusion configuration file:

mkdir -p /etc/mysql/conf.d/
cp /usr/share/mysql/wsrep.cnf /etc/mysql/conf.d/
touch /etc/my.cnf
echo '!includedir /etc/mysql/conf.d/' >> /etc/my.cnf

9. Configure MySQL wsrep with Galera library. Open /etc/mysql/conf.d/wsrep.cnf using text editor and find and edit following line:

For galera1.cluster.local(10.84.5.158):

wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://"
wsrep_sst_auth=sst:sstpass123

For galera2.cluster.local(10.84.5.159):

wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://10.84.5.158:4567"
wsrep_sst_auth=sst:sstpass123

10. Restart services in both servers:

service mysql restart

11. Check whether Galera replication is running fine:

mysql -e "show status like 'wsrep%'"
If the cluster is working, you should see following value in both servers:

wsrep_ready = ON

HAProxy servers

1. In both haproxy1 and haproxy2, we will start with installing virtual IP to make sure the HAProxy IP is always available. Lets download and install keepalived from here. OpenSSL header and popt library are required, so we will install it first using yum:

yum install -y openssl openssl-devel popt*
cd /usr/local/src
wget http://www.keepalived.org/software/keepalived-1.2.2.tar.gz
tar -xzf keepalived-1.2.2.tar.gz
cd keepalived-*
./configure
make
make install

2. Since we have virtual IP which shared between these 2 servers, we need to tell kernel that we have a non-local IP to be bind to HAProxy service later. Add following line into /etc/sysctl.conf:

net.ipv4.ip_nonlocal_bind = 1
Run following command to apply the changes:

sysctl -p

3. By default, keepalived configuration file will be setup under /usr/local/etc/keepalived/keepalived.conf. We will make things easier by symlink it into /etc directory. We will also need to clear the configuration example inside it:

ln -s /usr/local/etc/keepalived/keepalived.conf /etc/keepalived.conf
cat /dev/null > /etc/keepalived.conf

4. This step is different in both servers for keepalived configuration.

For haproxy1, add following line into /etc/keepalived.conf:

vrrp_script chk_haproxy {
        script "killall -0 haproxy" # verify the pid is exist or not
        interval 2                      # check every 2 seconds
        weight 2                        # add 2 points of prio if OK
}
 
vrrp_instance VI_1 {
        interface eth0			# interface to monitor
        state MASTER
        virtual_router_id 51		# Assign one ID for this route
        priority 101                    # 101 on master, 100 on backup
        virtual_ipaddress {
            10.84.5.181		# the virtual IP
        }
        track_script {
            chk_haproxy
        }
}
For haproxy2, add following line into /etc/keepalived.conf:

vrrp_script chk_haproxy {
        script "killall -0 haproxy"     # verify the pid is exist or not
        interval 2                      # check every 2 seconds
        weight 2                        # add 2 points of prio if OK
}
 
vrrp_instance VI_1 {
        interface eth0			# interface to monitor
        state MASTER
        virtual_router_id 51		# Assign one ID for this route
        priority 100                    # 101 on master, 100 on backup
        virtual_ipaddress {
            10.84.5.181		# the virtual IP
        }
        track_script {
            chk_haproxy
        }
}
5. Download and install HAProxy. Get the source from http://haproxy.1wt.eu/#down .We also need to install some required library using yum:

yum install pcre* -y
cd /usr/local/src
wget http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.19.tar.gz
tar -xzf haproxy-1.4.19.tar.gz
cd haproxy-*
make TARGET=linux26 ARCH=x86_64 USE_PCRE=1
make install

 
6. Create HAProxy configuration file and paste following configuration. This configuration will tell HAProxy to be a reverse-proxy for the virtual IP on port 3306. It then forward the request to backend servers. MySQL checking need to be done via haproxy user:

mkdir -p /etc/haproxy
touch /etc/haproxy/haproxy.cfg

Add following line into /etc/haproxy/haproxy.cfg:

defaults
        log global
        mode http
        retries 3
        option redispatch
        maxconn 4096
        contimeout 50000
        clitimeout 50000
        srvtimeout 50000
 
listen mysql_proxy 0.0.0.0:3306
        mode tcp
        balance roundrobin
        option tcpka
        option httpchk
        option mysql-check user haproxy
        server galera1 10.84.5.158:3306 weight 1
        server galera2 10.84.5.159:3306 weight 1

7. Since we only have 2 database servers, it means we have 2 members in the cluster. 
Even though it is working but still not a good idea to have database failover because it can cause “split brain”.  
Split brain mode refers to a state in which each database server does not know the high availability (HA) role of its redundant peer, 
and cannot determine which server currently has the primary HA role. So we will use both HAProxy servers to be the 3rd and 4th member. 
We called them arbitrator. Galera has provided the binary called garbd to overcome this problem. Download and install Galera library:

cd /usr/local/src
wget  https://yum.mariadb.org/5.5-galera/centos/7/x86_64/rpms/galera-25.3.26-1.rhel7.el7.centos.x86_64.rpm
rpm -Uhv galera-25.3.26-1.rhel7.el7.centos.x86_64.rpm

8.  Run following command to start garbd as daemon to join my_wsrep_cluster group:

garbd -a gcomm://10.84.5.158:4567 -g my_wsrep_cluster -d

9. Now lets start keepalived and HAProxy and do some testing whether the IP failover, 
database failover and load balancing are working. Run following command in both servers:

keepalived -f /etc/keepalived.conf
haproxy -D -f /etc/haproxy/haproxy.cfg

Ping IP 192.168.0.170 from another host. Now in haproxy1, stop the network:

service network stop

You will notice that the IP will be down for 2 seconds and then it will up again. 
It means that haproxy2 has taking over IP 192.168.0.170 from haproxy1. 
If you start back the network in haproxy1, you will noticed the same thing happen because haproxy1 will taking over back the IP from haproxy2, 
as what we configure in /etc/keepalived.conf. You can also try to kill haproxy process and you will see the virtual IP will be take over 
again by haproxy2.

In other hand, you can try to stop mysql process in galera2 and create a new database inside galera1. 
After a while, start back the mysql process in galera2 and you should see that galera2 will synchronize to galera1 as 
reference node to update data.

If everything working as expected, add following line into /etc/rc.local so the service started automatically after boot:

/usr/local/sbin/haproxy -D -f /etc/haproxy/haproxy.cfg
/usr/local/sbin/keepalived -f /etc/keepalived.conf
/usr/bin/garbd -a gcomm://10.84.5.158:4567 -g my_wsrep_cluster -d
Now your MySQL is running in high availability mode. The MySQL client just need to access 10.84.5.181 as the MySQL database server host.

*Notes: All steps above need to be done on all respective servers except if specified


