* * * * * Cài instance nginx thứ 2 * * * * * 

B1. Cài đặt các gói phụ thuộc:
	yum -y install gcc gcc-c++ make zlib-devel pcre-devel openssl-devel

B2. Tải mã nguồn nginx:

- Tải mã nguồn
	cd /usr/local/src
	wget http://nginx.org/download/nginx-1.12.1.tar.gz
– Giải nén mã nguồn vừa tải về
nginxVersion="1.12.1"
tar -xzf nginx-$nginxVersion.tar.gz 
ln -sf nginx-$nginxVersion nginx # Thuận lợi cho việc upgrade version nginx sau này.

– Chuyển vào thư mục chứa mã nguồn Nginx và tiến hành biên dịch
cd nginx

- Tạo các thư mục chứa file config và các thông tin log, sbin:
mkdir -p /opt/nginx/sbin
mkdir -p /opt/nginx/conf
mkdir -p /opt/nginx/log
./configure --user=nginx --group=nginx --prefix=/opt/nginx --sbin-path=/opt/nginx/sbin/nginx --conf-path=/opt/nginx/conf/nginx.conf --pid-path=/var/run/nginxHocNV.pid --lock-path=/var/run/nginxHocNV.lock --error-log-path=/opt/nginx/log/error.log --http-log-path=/opt/nginx/log/access.log --with-http_gzip_static_module --with-http_stub_status_module --with-http_ssl_module --with-pcre --with-file-aio --with-http_realip_module --without-http_scgi_module --without-http_uwsgi_module --without-http_fastcgi_module \
--add-module=../nginx-rtmp-module-master     \
--add-module=../nginx-vod-module-1.13

# Trên kia là 2 module (nginx-rtmp-module-master và nginx-vod-module-1.13) add thêm trong quá trình cài ( nếu ko cần thì có thể bỏ đi)

make
make install

B3. Viết scripts cho phép start/stop/restart
Có 2 cách:
* * * Cách 1:  Sử dụng systemctl:

- Tạo file sau:
	touch /usr/lib/systemd/system/nginxHNV.service
    chmod +x /usr/lib/systemd/system/nginxHNV.service

- Chèn vào nội dung sau:
[Unit]
Description=The nginx HTTP and reverse proxy server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginxHocNV.pid    
# Là thông số ở phần trên đã cài
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /var/run/nginxHocNV.pid
ExecStartPre=/opt/nginx/sbin/nginx -t
ExecStart=/opt/nginx/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true

[Install]
WantedBy=multi-user.target


- Sau đó sử dụng các lệnh:
start:
	systemctl start nginxHNV
stop:
	systemctl stop nginxHNV
status: 
	systemctl status nginxHNV

* * * Note:
T/h cài lần đầu mà chưa start đc (chỉ có 1 nginx và cài theo cách này thì cần tạo thêm user nginx)

useradd nginx -d /var/lib/nginx -s /sbin/nologin 
mkdir -p /var/lib/nginx/tmp/client_body
mkdir -p /var/lib/nginx/tmp/fastcgi
mkdir -p /var/lib/nginx/tmp/proxy
mkdir -p /var/lib/nginx/tmp/scgi
mkdir -p /var/lib/nginx/tmp/uwsgi
chown -R nginx:nginx /var/lib/nginx



* * * Cách 2: Viết scripts:

- Tạo file /etc/init.d/nginxHNV
- Với nội dung sau:

#!/bin/bash
## Khai bao duong dan cho nginx instance thứ 2, 3, ...
nginx='/opt/nginx/sbin/nginx'
echo Su dung: $1
case "$1" in
  
  start)
        pid=`ps -ef| grep $nginx |grep -v grep|awk -F' ' '{print $2}'`
        Res=$?
        if [ $pid >  0 ]
        then
                echo nginx is running ...
                ps -ef | grep $nginx
        else
                $nginx

                RETVAL=$?
                if [ $RETVAL -eq 0 ]
                then
                        echo Start successfull!
                else
                        echo Fail. Check again!!!
                fi
        fi

        ;;

  stop)
        $nginx -s stop
        RETVAL=$?
        if [ $RETVAL -eq 0 ]
        then
                echo Stop!
        else
                echo Fail. Check again!!!
        fi

        ;;

  restart)
        $nginx -s stop
        echo Stop! Next step starting ...
        $nginx
        RETVAL=$?
        if [ $RETVAL -eq 0 ]
        then
                echo Restart successfull!
        else
                echo Fail. Check again!!!
        fi
        ;;
  status)
        pid=`ps -ef| grep $nginx |grep -v grep|awk -F' ' '{print $2}'`
        if [ $pid >  0 ]
        then
                echo nginx is running ...
                ps -ef | grep $pid
        else
                echo nginx is stopped!!!
        fi
        ;;
  reload)
        $nginx -s reload
        echo Reload successfull!
        ;;
  configtest)
        $nginx -t
        ;;

    *)
        echo $"Usage: $0 {start|stop|status|reload|restart|configtest}"
        exit 2
esac

exit 0