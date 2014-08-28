#!/bin/bash
#add by geyong Aug 28 2014
yum install wget curl vim
wget https://redis.googlecode.com/files/redis-2.6.11.tar.gz
tar xvzf redis-2.6.11.tar.gz
cd redis-2.6.11
make
make PREFIX=/usr/local/redis install 
