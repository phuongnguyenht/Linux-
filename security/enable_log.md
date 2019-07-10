-----	Enable log kernel Centos	-----

Centos7: 
vi /etc/rsyslog.conf 
bỏ comment đi là được

Note:
```
/var/log/message: thông tin chung về hệ thống
/var/log/auth.log: các log về xác thực
/var/log/kern.log: các log về nhân của hệ điều hành
/var/log/cron.log: các log về dịch vụ Crond (dịch vụ lập lịch chạy tự động)
/var/log/maillog: Các log của máy chủ email
/var/log/qmail/ : Thư mục log của phân mềm Qmail
/var/log/httpd/: Thư mục log truy cập và lỗi của phần mềm Apache
/var/log/lighttpd: Thư mục log truy cập và lỗi của phần mềm Lighttpd
/var/log/boot.log : Log của quá trình khởi động hệ thống
/var/log/mysqld.log: Log của MySQL
/var/log/secure: Log xác thực
/var/log/utmp hoặc /var/log/wtmp : file lưu bản ghi đăng nhập
/var/log/yum.log: các log của Yum log files
```