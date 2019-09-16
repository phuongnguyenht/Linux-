Setup Mariadb cluster 3 node

cat /etc/hosts
192.168.12.132  app01
192.168.12.134  app02
192.168.12.131  app03

---------------------------------Install mariadb on Centos 7---------------------------------
---------------------------------Install mariadb on Centos 7---------------------------------
vi /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=http://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

yum install mariadb-server mariadb-client -y

Sau khi đã cài đặt xong MariaDB-server. Chay mysql_secure_installation để đặt mật khẩu cho Root và loại bỏ một số nguy cơ bảo mật.
mysql_secure_installation

mkdir -p /var/lib/mysql/data/tablespace
mkdir -p /var/lib/mysql/tmp
mkdir -p /var/lib/mysql/logs/iblogs
mkdir -p /var/lib/mysql/logs/binlog
cd /var/lib && chown -R mysql.mysql mysql

Cấu hình chi tiết trên từng host như trong folder đính kèm.

vào server master chạy galera_new_cluster
Check
MariaDB [(none)]> SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size';
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 3     |
+--------------------+-------+
1 row in set (0.28 sec)

MariaDB [(none)]> show status like 'wsrep_incoming_addresses';
+--------------------------+-------------------------------------------------------------+
| Variable_name            | Value                                                       |
+--------------------------+-------------------------------------------------------------+
| wsrep_incoming_addresses | 192.168.12.132:3306,192.168.12.134:3306,192.168.12.131:3306 |
+--------------------------+-------------------------------------------------------------+
1 row in set (0.00 sec)

Fatal error: Can't open and lock privilege tables: Table 'mysql.user' doesn't exist
Centos 7
Fix:
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
[root@app01 my.cnf.d]# systemctl start mariadb
[root@app01 my.cnf.d]# mysql_secure_installation

I have this error, but in my case galera_new_cluster not works.
problem solved by editing /var/lib/mysql/grastate.dat file and change safe_to_bootstrap to 1.

---------------Cài thêm xinetd và rsync: yum -y install rsync xinetd -------------------------------------

Clustercheck is a useful bash script to make a proxy (ex: HAProxy) capable of monitoring the MariaDB server.
vi /usr/bin/clustercheck
chmod +x /usr/bin/clustercheck

Next, create a xinetd script for the clusterchek with the vi command in the "/etc/xinet.d/" directory:
vi /etc/xinetd.d/mysqlchk
# default: on
# description: mysqlchk
service mysqlchk
{
        disable = no
        flags = REUSE
        socket_type = stream
        port = 9201             # This port used by xinetd for clustercheck
        wait = no
        user = nobody
        server = /usr/bin/clustercheck
        log_on_failure += USERID
        only_from = 0.0.0.0/0
        per_source = UNLIMITED
}

vi /etc/services
add new line

mysqlchk        9201/tcp                # mysqlchk
xinetd          9098/tcp                # ...

Then start the xinetd service:
systemctl start xinetd
systemctl enable xinetd


mysql -u root -p
GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY 'clustercheckpassword!' ;
GRANT PROCESS ON *.* TO 'clustercheckuser'@'127.0.0.1' IDENTIFIED BY 'clustercheckpassword!' ;
exit;

select Host,User,Password from mysql.user;

Testing clustercheck:

/usr/bin/clustercheck
Make sure the results code is 200.

-----------------------------------Configure HAProxy-------------------------------------
# MariaDB  cluster
listen galera_cluster
  bind 10.144.40.69:3306
  balance roundrobin
  option httpchk
  mode tcp
  server galera_node01 10.144.40.67:3306 check port 9201 inter 2000 rise 2 fall 5
  server galera_node02 10.144.40.66:3306 backup check port 9201 inter 2000 rise 2 fall 5
  server galera_node03 10.144.40.68:3306 backup check port 9201 inter 2000 rise 2 fall 5


 vi /etc/sysctl.conf
  net.ipv4.ip_nonlocal_bind=1
sysctl -p 
