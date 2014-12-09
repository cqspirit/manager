#!/bin/bash
yum install -y git make autoconf automake wget pcre pcre-devel zlib zlib-devel openssl openssl-devel mod-perl-devel gcc gcc-++
mkdir -p /opt/soft
cd /opt/soft/
#FastDFS Lib Install
git clone git://github.com/happyfish100/libfastcommon.git
cd libfastcommon/
./make.sh
./make install
cd-

#FastDFS Install
git clone git://github.com/happyfish100/fastdfs.git
cd fastdfs/
./make.sh
./make.sh installl
cp ./conf/* /etc/fdfs/
rm /etc/fdfs/*.sample -f
rm /etc/fdfs/*.jpg -f
cd-

#Nginx+Module Inatall
git clone git://github.com/happyfish100/fastdfs-nginx-module.git
wget http://nginx.org/download/nginx-1.4.7.tar.gz
tar zxvf nginx-1.4.7.tar.gz
mv fastdfs-nginx-module/ nginx-1.4.7
cd nginx-1.4.7/
conf="--with-http_stub_status_module --with-http_realip_module --with-http_gzip_static_module --add-module=fastdfs-nginx-module/src"
./configure $conf
make
make install
cp fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/
cd-
