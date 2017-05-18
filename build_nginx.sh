#!/bin/bash
# Script build NGINX for centos 7
# Installing NGINX Dependencies
# install wget
if [ ! -x /usr/bin/wget ] ; then
    # some extra check if wget is not installed at the usual place                                                                           
    command -v wget >/dev/null 2>&1 || { echo >&2 "Please install wget or set it in your path. Aborting.";
	yum install wget -y; 
	yum install expect -y;	}
fi

# ensure that we have the required software to compile our own nginx
# setup from DVD
#yum -y install --disablerepo=\* --enablerepo=DVD httpd-devel git gcc gcc-c++ make libxml2 pcre-devel libxml2-devel curl-devel
# setup from internet
yum -y install httpd-devel git gcc gcc-c++ make libxml2 pcre-devel libxml2-devel curl-devel

cd /opt/
mkdir -p nginx-depend && cd nginx-depend

# install PCRE library
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz
tar -zxf pcre-8.40.tar.gz
cd pcre-8.40
./configure
make
sudo make install

#install zlib library
cd /opt/nginx-depend
wget http://zlib.net/zlib-1.2.11.tar.gz
tar -zxf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure
make
sudo make install

#install OpenSSL library 
cd /opt/nginx-depend
wget http://www.openssl.org/source/openssl-1.0.2f.tar.gz
cd /opt/nginx-depend
tar -zxf openssl-1.0.2f.tar.gz
cd openssl-1.0.2f
./configure darwin64-x86_64-cc --prefix=/usr
make
sudo make install

cd /opt/
wget http://nginx.org/download/nginx-1.10.3.tar.gz
tar zxf nginx-1.10.3.tar.gz
cd nginx-1.10.3

#Configuring the Build Options
./configure
--sbin-path=/usr/local/nginx/nginx
--conf-path=/usr/local/nginx/nginx.conf
--pid-path=/usr/local/nginx/nginx.pid
--with-pcre=../pcre-8.40
--with-zlib=../zlib-1.2.11
--with-http_ssl_module
--with-stream
--with-mail=dynamic
--add-module=/usr/build/nginx-rtmp-module
--add-dynamic-module=/usr/build/3party_module
