MariaDB Installation (Version 10.1.21) via RPMs on CentOS 7

rpm -qa | grep mariadb
then remove the mariadb 5.5 packages using (changing to your versions):

rpm -e --nodeps "mariadb-libs-5.5.56-2.el7.x86_64"
rpm -e --nodeps "mariadb-server-5.5.56-2.el7.x86_64"
rpm -e --nodeps "mariadb-5.5.56-2.el7.x86_64"

Các gói cần cài đặt:
https://rpms.southbridge.ru/rhel7/mariadb-10.1/x86_64/rpms/

jemalloc-3.6.0-1.el7.x86_64.rpm
MariaDB-10.1.21-centos7-x86_64-client.rpm
MariaDB-10.1.21-centos7-x86_64-compat.rpm
galera-25.3.19-1.rhel7.el7.centos.x86_64.rpm
jemalloc-devel-3.6.0-1.el7.x86_64.rpm
MariaDB-10.1.21-centos7-x86_64-common.rpm
MariaDB-10.1.21-centos7-x86_64-server.rpm
boost-program-options-1.53.0-27.el7.x86_64.rpm

Các bước cài đặt:

mkdir /media/Centos 
mount -t iso9660 -o loop /opt/CentOS-7-x86_64-DVD-1810.iso /media/Centos
yum --disablerepo=\* --enablerepo=c7-media install rsync nmap lsof perl-DBI nc

1) First install all of the dependencies needed. Its easy to do this via YUM packages: yum install rsync nmap lsof perl-DBI nc
2) rpm -ivh jemalloc-3.6.0-1.el7.x86_64.rpm
3) rpm -ivh jemalloc-devel-3.6.0-1.el7.x86_64.rpm
4) rpm -ivh MariaDB-10.1.21-centos7-x86_64-common.rpm 
rpm -ivh MariaDB-10.1.21-centos7-x86_64-compat.rpm 
rpm -ivh MariaDB-10.1.21-centos7-x86_64-client.rpm 
rpm -ivh galera-25.3.19-1.rhel7.el7.centos.x86_64.rpm 
rpm -ivh MariaDB-10.1.21-centos7-x86_64-server.rpm
While installing MariaDB-10.1.21-centos7-x86_64-common.rpm there might be a conflict with older MariaDB packages. we need to remove them and install the original rpm again.

Here is the error message for dependencies:

[root@centos-2 /]# rpm -ivh MariaDB-10.1.21-centos7-x86_64-common.rpm 
warning: MariaDB-10.1.21-centos7-x86_64-common.rpm: Header V4 DSA/SHA1 Signature, key ID 1bb943db: NOKEY
error: Failed dependencies:
	mariadb-libs < 1:10.1.21-1.el7.centos conflicts with MariaDB-common-10.1.21-1.el7.centos.x86_64

Solution: search for this package:

[root@centos-2 /]# rpm -qa | grep mariadb-libs
mariadb-libs-5.5.52-1.el7.x86_64
Remove this package:

[root@centos-2 /]# rpm -ev --nodeps mariadb-libs-5.5.52-1.el7.x86_64
Preparing packages...
mariadb-libs-1:5.5.52-1.el7.x86_64
While installing the Galera package there might be a conflict in installation for a dependency package. Here is the error message:

[root@centos-2 /]# rpm -ivh galera-25.3.19-1.rhel7.el7.centos.x86_64.rpm 
error: Failed dependencies:
	libboost_program_options.so.1.53.0()(64bit) is needed by galera-25.3.19-1.rhel7.el7.centos.x86_64

The dependencies for Galera package is: libboost_program_options.so.1.53.0

Solution:

[root@centos-2 hocnv]# rpm -ivh boost-program-options-1.53.0-27.el7.x86_64.rpm
Preparing...                          ################################# [100%]
Updating / installing...
   1:boost-program-options-1.53.0-27.e################################# [100%]



[root@centos-2 /]#rpm --import http://yum.mariadb.org/RPM-GPG-KEY-MariaDB
After step 4, the installation will be completed. The last step will be to run mysql_secure_installation to secure the production server by dis allowing remote login for root, creating root password and removing the test database.

5) mysql_secure_installation

-----------------TH install lỗi:------------------------
 rpm -ivh MariaDB-10.2.9-centos7-x86_64-common.rpm
error: Failed dependencies:
        MariaDB-compat is needed by MariaDB-common-10.2.9-1.el7.centos.x86_64
[root@app03 opt]# rpm -ivh MariaDB-10.2.9-centos7-x86_64-compat.rpm
error: Failed dependencies:
        MariaDB-common is needed by MariaDB-compat-10.2.9-1.el7.centos.x86_64

Yes; installing both together:

[root@app03 opt]# rpm -ivh MariaDB-10.2.9-centos7-x86_64-common.rpm  MariaDB-102.9-centos7-x86_64-compat.rpm
Preparing...                          ################################# [100%]
Updating / installing...
   1:MariaDB-compat-10.2.9-1.el7.cento################################# [ 50%]
   2:MariaDB-common-10.2.9-1.el7.cento################################# [100%]

