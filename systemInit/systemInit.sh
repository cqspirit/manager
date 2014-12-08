#!/bin/sh
#by geyong jue 4 2012
#1. setup common software
yum -y install vim wget openssh openssh-clients ntpdate rsync lrzsz

#2. config time sync
   #time sync right now
/usr/sbin/ntpdate pool.ntp.org
   #time sync everyday
echo '
00 00 * * * root /usr/sbin/ntpdate pool.ntp.org >> /var/log/ntpdate.log'>>/etc/crontab
/sbin/service crond restart 
   #time sync when system restart
touch /etc/rc.d/init.d/timesync
echo '#!/bin/bash
# add by geyong  Mar 1 , 2013
# auto sync the date when the system start
/usr/sbin/ntpdate pool.ntp.org >> /var/log/ntpdate.log'>/etc/init.d/timesync
chmod u+x /etc/rc.d/init.d/timesync
ln -s /etc/rc.d/init.d/timesync /etc/rc3.d/S90timesync

#3. nfs auto mount home
yum -y install nfs-utils autofs
echo 'TIMEOUT=300
BROWSE_MODE="no"
MAP_OBJECT_CLASS="automountMap"
ENTRY_OBJECT_CLASS="automount"
MAP_ATTRIBUTE="ou"
ENTRY_ATTRIBUTE="cn"
VALUE_ATTRIBUTE="automountInformation"'>/etc/sysconfig/autofs
/etc/init.d/rpcbind stop
/etc/init.d/nfs stop
/etc/init.d/nfslock stop
/etc/init.d/autofs stop
/etc/init.d/rpcbind start
/etc/init.d/nfs start  
/etc/init.d/nfslock start
/etc/init.d/autofs start
chkconfig rpcbind on
chkconfig nfs on    
chkconfig nfslock on

yum -y install openldap openldap-clients nss-pam-ldapd authconfig
yum -y erase sssd

authconfig \
--enableldap \
--enableldapauth \
--ldapserver='ldap://ldap.6estates.com' \
--ldapbasedn='dc=ldap,dc=6estates,dc=com' \
--enablemkhomedir \
--enableshadow \
--enablelocauthorize \
--passalgo=sha256 \
--update

cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
sed -e 's:files dns:files ldap dns:g' /etc/nsswitch.conf
sed -i -e 's:files dns:files ldap dns:g' /etc/nsswitch.conf

#4.add sudo without password user
echo '
%sadm   ALL=(ALL)       NOPASSWD: ALL' >>/etc/sudoers

#5.disable SELinux
/usr/sbin/sestatus -v 
sed -e 's:SELINUX=enforcing:SELINUX=disabled:g' /etc/sysconfig/selinux
sed -i 's:SELINUX=enforcing:SELINUX=disabled:g' /etc/sysconfig/selinux
sed -i 's:SELINUX=enforcing:SELINUX=disabled:g' /etc/selinux/config
#6 ssh config
sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's:#AuthorizedKeysFile:AuthorizedKeysFile:g' /etc/ssh/sshd_config
/sbin/service sshd restart
#7 disable iptables
chkconfig iptables off
#8.modify file limit 
echo '*   soft    nofile  40000
*   hard    nofile  40000' >> /etc/security/limits.conf
#9.reboot

reboot
