#!/bin/bash

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

LOG_FILE="$bin/logs/crawler-web-$(date +%Y%m%d).log"
if [ -f $LOG_FILE ]; then
  echo "$LOG_FILE exists!"
else
  touch $LOG_FILE
fi

echo "=================================$(date +%Y-%m-%d' '%H:%M)=======================">>$LOG_FILE

NGINX_FILE=/usr/local/nginx/conf/upsteam_crawler.conf
COMMAND='ls /crawler-cluster/web/member'
ZOOKEEPER_CLI="$bin/zookeeper-3.4.6/bin/zkCli.sh"
ZOOKEEPER_SERVER_IP='172.18.109.64'
ZOOKEEPER_SERVER_PORT='2181'

servers=`echo $COMMAND|$ZOOKEEPER_CLI  -server $ZOOKEEPER_SERVER_IP:$ZOOKEEPER_SERVER_PORT |tail  -2|head -1`
#echo $servers
b=${servers/[/}
c=${b//,/ }
d=${c/]/}

if  [ "$d"x = ""x ] ;
  then
     echo "GetData From Zookeeper error!" >> $LOG_FILE
     return
  else
     echo "GetData From Zookeeper successed!" >> $LOG_FILE
fi
echo 'upstream  crawler {' >$NGINX_FILE
echo '      ip_hash;'>>$NGINX_FILE
for server in $d
do
 echo "server:${server%:*} ">>$LOG_FILE
 echo " server   ${server%:*}  weight=1 max_fails=2 fail_timeout=10s;">>$NGINX_FILE
done
echo "}" >>$NGINX_FILE
/sbin/service nginx reload
