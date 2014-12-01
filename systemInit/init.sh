#!/bin/bash
#add by geyong Nov 24 2014
#1.change ssh port
sed 's/#Port 22/Port 51822/g' /etc/ssh/sshd_config
/sbin/service sshd restart
#2. install openldap clients and nfs autofs
yum  install openldap-clients nss-pam-ldapd nfs-utils autofs -y

#authconfig-tui
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
#start nslcd
/sbin/service nslcd start
chkconfig nslcd on

echo '/home /etc/auto.nfs'>> /etc/auto.master
echo '*       -rw,soft,intr      ldap.6estates.com:/home/&' > /etc/auto.nfs

service rpcbind stop
service rpcidmapd stop
service nfslock stop
service nfs stop
service autofs stop
service rpcbind start 
service rpcidmapd start 
service nfslock start
service nfs start
service autofs start
chkconfig rpcbind on
chkconfig rpcidmapd on
chkconfig nfslock on
chkconfig nfs on
chkconfig autofs on
sed -i 's/%sadm/#%sadm/g' /etc/sudoers
echo 'sadm    ALL=(ALL)       ALL' >>/etc/sudoers

#sudo ldappasswd -xWD cn=Manager,dc=ldap,dc=6estates,dc=com -S uid=crawler,ou=People,dc=ldap,dc=6estates,dc=com
#cn=Manager,dc=ldap,dc=6estates,dc=com




