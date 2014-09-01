#!/bin/bash 
#install nginx add By geyong 1 Sep 2014
INSTALL_PATH=/usr/local
#模块依赖性
yum -y install gcc gcc-c++ autoconf automake
#gzip模块需要zlib库
#rewrite模块需要pcre库
#ssl功能需要openssl库等
yum -y install zlib zlib-devel openssl openssl-devel pcre pcre-devel
#get latest nginx version
mkdir -p /opt/soft
cd /opt/soft
wget http://nginx.org/download/nginx-1.6.1.tar.gz
tar zxvf nginx-1.6.1.tar.gz
cd nginx-1.6.1
./configure --prefix=$INSTALL_PATH
make
make install
