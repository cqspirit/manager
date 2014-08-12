#!/bin/sh
# by geyong may 8 2013
# install xen based on fedora17
#1.安装软件vim
yum -y install vim
#2.屏蔽selinux
sed -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
#3.安装bridge-utils
yum -y  install bridge-utils libvirt-daemon-xen python-virtinst libvirt-daemon-config-network libvirt-daemon-driver-network
systemctl disable NetworkManager.service || systemctl restart network.service
chkconfig network on
#4.config network
echo 'DEVICE=br1 
TYPE=Bridge 
BOOTPROTO=none
ONBOOT=yes 
DELAY=0 
NM_CONTROLLED=yes
IPADDR=172.18.109.11
GATEWAY=172.18.109.1
DNS1=8.8.8.8
DNS2=8.8.4.4'>/etc/sysconfig/network-scripts/ifcfg-br1

echo '
BRIDGE=br1' >>/etc/sysconfig/network-scripts/ifcfg-em1

sed -i 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/g' /etc/sysconfig/network-scripts/ifcfg-em1
sed -i 's/IPADDR0/#IPADDR0/g' /etc/sysconfig/network-scripts/ifcfg-em1
sed -i 's/PREFIX0/#PREFIX0/g' /etc/sysconfig/network-scripts/ifcfg-em1
sed -i 's/IPV6INIT/#IPV6INIT/g' /etc/sysconfig/network-scripts/ifcfg-em1
sed -i 's/IPV4_FAILURE_FATAL/#IPV4_FAILURE_FATAL/g' /etc/sysconfig/network-scripts/ifcfg-em1
sed -i 's/DEFROUTE/#DEFROUTE/g' /etc/sysconfig/network-scripts/ifcfg-em1
sed -i 's/DNS/#DNS/g' /etc/sysconfig/network-scripts/ifcfg-em1
sed -i 's/GATEWAY/#GATEWAY/g' /etc/sysconfig/network-scripts/ifcfg-em1
sed -i 's/GATEWAY/#GATEWAY/g' /etc/sysconfig/network-scripts/ifcfg-em1

/etc/init.d/network restart
#5.安装xen
yum -y install xen
#6.设置默认启动xen内核
cat /boot/grub2/grub.cfg |grep Fedora
grub2-set-default  'Fedora Linux, with Xen hypervisor'
grub2-editenv list
grub2-mkconfig –o /boot/grub2/grub.cfg
#7.重启
reboot
