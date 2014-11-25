#!/bin/bash
 
echo '
[atrpms] 
name=Red Hat Enterprise Linux $releasever - $basearch - ATrpms 
baseurl=http://dl.atrpms.net/el$releasever-$basearch/atrpms/stable 
gpgkey=http://ATrpms.net/RPM-GPG-KEY.atrpms 
gpgcheck=1 
enabled=1 ' >>/etc/yum.repos.d/CentOS-Base.repo

yum -y install fail2ban

sed -i 's:logtarget = SYSLOG:logtarget = /var/log/fail2ban.log:g'  /etc/fail2ban/fail2ban.conf
sed -i 's:fail2ban@example.com:6estates@gmail.com:g'  /etc/fail2ban/jail.conf
/sbin/service fail2ban start
/sbin/service iptables status
/sbin/service iptables start
chkconfig fail2ban on 
chkconfig iptables on 
echo 'install finish!'
