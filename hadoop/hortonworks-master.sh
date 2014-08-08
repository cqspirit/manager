#!/bin/bash
#add by geyong Aug 8 2014
#1.依赖软件
yum install -y openssl-devel openssh-clients rsync lrzsz vim wget  curl
#2.system opt
#swap 2X system memory ，Master nodes(RAID 10, 多网卡，多电源)，slave（裸挂载，/grid/0/） 
#3.enlarge 打开文件句柄数
echo '*   soft    nofile  40000
*  hard    nofile  40000'>>/etc/security/limits.conf
#4.disable selinux
sed -i 's:SELINUX=enforcing:SELINUX=disabled:g'  /etc/selinux/config
setenforce 0
getenforce
#5.time rsync
touch /etc/rc.d/init.d/timesync
echo '#!/bin/bash
# add by geyong Mar 1 , 2013
# auto sync the date when the system start
/usr/sbin/ntpdate pool.ntp.org >> /var/log/ntpdate.log'>/etc/init.d/timesync
chmod u+x /etc/rc.d/init.d/timesync
ln -s /etc/rc.d/init.d/timesync /etc/rc3.d/S90timesync
yum install ntp ntpdate -y && ntpdate pool.ntp.org && service ntpd start
chkconfig ntpd on
#6.stop iptables
chkconfig iptables off
/etc/init.d/iptables stop
#7.disable packagekit
echo 'enabled=0'>/etc/yum/pluginconf.d/refresh-packagekit.conf
#8.dns
echo '172.18.109.30   next-20
172.18.109.31   next-21
172.18.109.32   next-22
172.18.109.33   next-23
172.18.109.34   next-24
172.18.109.35   next-25
172.18.109.36   next-26
172.18.109.37   next-27
172.18.109.38   next-28
172.18.109.39   next-29
172.18.109.40   next-30
172.18.109.41   next-31
172.18.109.42   next-32
172.18.109.43   next-33
172.18.109.44   next-34
172.18.109.45   next-35
172.18.109.46   next-36
172.18.109.47   next-37
172.18.109.48   next-38
172.18.109.49   next-39
172.18.109.50   next-40
172.18.109.51   next-41
172.18.109.52   next-42
172.18.109.53   next-43
172.18.109.54   next-44
172.18.109.55   next-45
172.18.109.56   next-46
172.18.109.57   next-47
172.18.109.58   next-48
172.18.109.59   next-49
172.18.109.60   next-50
172.18.109.61   next-51
172.18.109.62   next-52
172.18.109.63   next-53
172.18.109.64   next-54
172.18.109.65   next-55
172.18.109.66   next-56
172.18.109.67   next-57
172.18.109.68   next-58
172.18.109.69   next-59
172.18.109.70   next-60
172.18.109.71   next-61
172.18.109.72   next-62
172.18.109.73   next-63
172.18.109.74   next-64
172.18.109.75   next-65
172.18.109.76   next-66
172.18.109.77   next-67
172.18.109.78   next-68
172.18.109.79   next-69
172.18.109.80   next-70
172.18.109.81   next-71
172.18.109.82   next-72
172.18.109.83   next-73
172.18.109.84   next-74
172.18.109.58   next-48
172.18.109.53   next-43
172.18.109.85   next-75
172.18.109.86   next-76
172.18.109.87   next-77
172.18.109.88   next-78
172.18.109.89   next-79
172.18.109.90   next-80
172.18.109.91   next-81
172.18.109.92   next-82
172.18.109.93   next-83
172.18.109.94   next-84
172.18.109.95   next-85
172.18.109.96   next-86
172.18.109.97   next-87
172.18.109.98   next-88
172.18.109.99   next-89
172.18.109.100  next-90
172.18.109.101  next-91
172.18.109.102  next-92
172.18.109.103  next-93
172.18.109.104  next-94
172.18.109.105  next-95
172.18.109.106  next-96
172.18.109.107  next-97
172.18.109.108  next-98
172.18.109.109  next-99' >>/etc/hosts
#9.option linux kernel config
sysctl -w vm.swappiness=0
echo "vm.swappiness = 0" >> /etc/sysctl.conf
#10.get latest ambari.repo and install 
wget http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.0/ambari.repo
cp ambari.repo /etc/yum.repos.d
yum repolist
yum install ambari-server -y
ambari-server setup -s
ambari-server start
ps -ef | grep Ambari



