# Config log for haproxy with rsyslog

HAProxy is frequently used as a load-balancer in front of a Galera cluster. While diagnosing an issue with HAProxy configuration, I realized that logging doesn’t work out of the box on CentOS 6.5. Here is a simple recipe to fix the issue.

```
If you look at the top of /etc/haproxy/haproxy.cfg, you will see something like:

global
    log         127.0.0.1 local2
[...]
```

This means that HAProxy will send its messages to rsyslog on 127.0.0.1. But by default, rsyslog doesn’t listen on any address, hence the issue.

```
Let’s edit /etc/rsyslog.conf and uncomment these lines:

$ModLoad imudp
$UDPServerRun 514

This will make rsyslog listen on UDP port 514 for all IP addresses. Optionally you can limit to 127.0.0.1 by adding:

$UDPServerAddress 127.0.0.1
```
Now create a /etc/rsyslog.d/haproxy.conf file containing:

```
local2.*    /var/log/haproxy.log

You can of course be more specific and create separate log files according to the level of messages:

local2.=info     /var/log/haproxy-info.log
local2.notice    /var/log/haproxy-allbutinfo.log

```
Then restart rsyslog and see that log files are created:

```
# service rsyslog restart
# systemctl restart rsyslog 
Shutting down system logger:                               [  OK  ]
Starting system logger:                                    [  OK  ]

# ls -l /var/log | grep haproxy
-rw-------. 1 root   root      131  3 oct.  10:43 haproxy-allbutinfo.log
-rw-------. 1 root   root      106  3 oct.  10:42 haproxy-info.log

# service rsyslog restart
Shutting down system logger:                               [  OK  ]
Starting system logger:                                    [  OK  ]
 
# ls -l /var/log | grep haproxy
-rw-------. 1 root   root      131  3 oct.  10:43 haproxy-allbutinfo.log
-rw-------. 1 root   root      106  3 oct.  10:42 haproxy-info.log
```
Now you can start your debugging session!