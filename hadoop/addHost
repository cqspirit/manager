#!/bin/bash
#add by geyong Feb 27 2014
#1.Installed base Dependencies package
yum install -y openssl-devel  openssh-clients
yum install -y rsync lrzsz   vim wget 

#2.you have to synchronization time on boot if it is Virtual Machine.
touch /etc/rc.d/init.d/timesync
echo '#!/bin/bash
# add by geyong Mar 1 , 2013
# auto sync the date when the system start
/usr/sbin/ntpdate pool.ntp.org >> /var/log/ntpdate.log'>/etc/init.d/timesync
chmod u+x /etc/rc.d/init.d/timesync
ln -s /etc/rc.d/init.d/timesync /etc/rc3.d/S90timesync
yum install ntp ntpdate -y 
ntpdate pool.ntp.org 
/sbin/service ntpd start
#3.disable SELinux
sed -e 's:SELINUX=enforcing:SELINUX=disabled:g' /etc/sysconfig/selinux
sed -i 's:SELINUX=enforcing:SELINUX=disabled:g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 

#4.ssh config
sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's:#AuthorizedKeysFile:AuthorizedKeysFile:g' /etc/ssh/sshd_config
/sbin/service sshd restart

#5 modify hosts
echo '
172.18.109.31   next-21
172.18.109.36   next-26
172.18.109.41   next-31
172.18.109.46   next-36
172.18.109.51   next-41
172.18.109.30   next-20
172.18.109.35   next-25
172.18.109.40   next-30
172.18.109.45   next-35
172.18.109.50   next-40
172.18.109.56   next-46
172.18.109.57   next-47
172.18.109.60   next-50
172.18.109.88   next-78
172.18.109.93   next-83
172.18.109.98   next-88
172.18.109.103   next-93
172.18.109.108   next-98'>>/etc/hosts

#6 disable iptables 
/etc/init.d/iptables stop
chkconfig iptables off

#7.reboot
reboot
