#!/bin/bash
#add by geyong Nov 24 2014
#1.change ssh port
sed 's/#Port 22/Port 51822/g' /etc/ssh/sshd_config
/sbin/service sshd restart
