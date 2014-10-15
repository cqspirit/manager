#!/bin/bash 
#install nginx add By geyong 1 Sep 2014

#1.add nginx user
groupadd -r nginx
useradd -r -g nginx -s /bin/false -M nginx
#2.configure
NGINX_USER='nginx'
NGINX_GROUP='nginx'
INSTALL_PATH='/usr/local/nginx'
#3.install dependences
yum -y install gcc gcc-c++ autoconf automake wget
#gzip needs zlib  rewrite needs pcre ssl needs openssl
yum -y install zlib zlib-devel openssl openssl-devel pcre pcre-devel libevent
#get latest nginx version
mkdir -p /opt/soft
cd /opt/soft
wget http://nginx.org/download/nginx-1.6.1.tar.gz
tar zxvf nginx-1.6.1.tar.gz
cd nginx-1.6.1
./configure --prefix=$INSTALL_PATH  --user=$NGINX_USER  --group=$NGINX_GROUP
make
make install
#4 install as service
curl https://raw.githubusercontent.com/cqspirit/manager/master/nginx/nginxd >/etc/init.d/nginxd 
chmod u+x /etc/init.d/nginxd 
chkconfig nginxd on
chkconfig --list |grep nginxd
#5 install finish
echo -e "nginx install finish!\n \t\tinstall path:$INSTALL_PATH \n \t\tuser and group:$NGINX_USER.$NGINX_GROUP"
