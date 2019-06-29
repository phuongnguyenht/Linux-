vi /etc/ssh/sshd_config
Subsystem       sftp    /usr/libexec/openssh/sftp-server
=> sua:
Subsystem       sftp    /usr/libexec/openssh/sftp-server -l INFO -f AUTH

vi /etc/rsyslog.conf
=> Them dong:
auth.*    /var/log/sftp.log/sftp

service sshd restart
service rsyslog restart