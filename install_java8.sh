#!/bin/bash
#echo "Installing Java 8"
# install wget
if [ ! -x /usr/bin/wget ] ; then
    # some extra check if wget is not installed at the usual place                                                                           
    command -v wget >/dev/null 2>&1 || { echo >&2 "Please install wget or set it in your path. Aborting.";
	yum install wget -y; 
	yum install expect -y;
	yum install curl -y; }
fi

#file= "jdk-8u121-linux-x64.tar.gz"
yum update -y
cd /opt/
#mkdir -p setup  && cd setup
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
	if [ -e jdk-8u121-linux-x64.tar.gz ]
	then
		echo  jdk-8u121-linux-x64.tar.gz exists! 
	else
		wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz"
		tar -zxvf jdk-8u121-linux-x64.tar.gz
    fi 
else
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-i586.tar.gz"
	tar -zxvf jdk-8u121-linux-i586.tar.gz
fi

cd jdk1.8.0_121

alternatives --install /usr/bin/java java /opt/jdk1.8.0_121/bin/java 2
expect <<END
	spawn alternatives --config java
	expect "selection number:"
	send "1\r"
	expect eof
END

alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_121/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_121/bin/javac 2
alternatives --set jar /opt/jdk1.8.0_121/bin/jar
alternatives --set javac /opt/jdk1.8.0_121/bin/javac

export JAVA_HOME=/opt/jdk1.8.0_121
export JRE_HOME=/opt/jdk1.8.0_121/jre
export PATH=$PATH:/opt/jdk1.8.0_121/bin:/opt/jdk1.8.0_121/jre/bin
echo -e "export JAVA_HOME=/opt/jdk1.8.0_121 \nexport JRE_HOME=/opt/jdk1.8.0_121/jre \nexport PATH=$PATH:/opt/jdk1.8.0_121/bin:/opt/jdk1.8.0_121/jre/bin" >> ~/.bashrc
source ~/.bashrc




