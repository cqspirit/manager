#!/bin/bash 
#install nginx add By geyong 1 Sep 2014

#1.add nginx user
groupadd -r nginx
useradd -r -g nginx -s /bin/false -M nginx
#2.configure
NGINX_USER='nginx'
NGINX_GROUP='nginx'
CONF_PATH='/etc/nginx/'
INSTALL_PATH='/usr/local'
SBIN_PATH='/usr/local/bin'
mkdir -p $CONF_PATH
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
./configure --prefix=$INSTALL_PATH  --user=$NGINX_USER  --group=$NGINX_GROUP --sbin-path=$SBIN_PATH --conf-path=$CONF_PATH
make
make install
