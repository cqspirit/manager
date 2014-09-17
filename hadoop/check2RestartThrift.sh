#!/bin/bash
#add by geyong Aug 11 2014
#description: check thrift status,if it is down,restart it

export logfile="/var/log/thrift-status-$(date +%Y%m%d).log"

if [ -f $logfile ]; then
  echo "$logifle exists!"
else
  touch $logfile
fi

PS="/bin/ps"
GREP="/bin/grep"
checkname="thrift"

ret=`$PS auxwwwf |$GREP java|$GREP thrift |wc -l `

if [[ "$ret" -ge "1" ]]; then
     echo "[$(date +%Y-%m-%d' '%H:%M)]:OK! $checkname is running!">>$logfile
else
     echo "[$(date +%Y-%m-%d' '%H:%M)]:CRITICAL!! $checkname is down!">>$logfile
     echo "[$(date +%Y-%m-%d' '%H:%M)]:start $checkname ........">>$logfile
     su - hbase -c "/usr/lib/hbase/bin/hbase-daemon.sh  start thrift -f -c  -nonblocking -f -m 10 -w 50"
     if [[ "$?" -ne "1" ]]; then
        echo "[$(date +%Y-%m-%d' '%H:%M)]:start $checkname successed!!">>$logfile
     else
        echo "[$(date +%Y-%m-%d' '%H:%M)]:start $checkname failed!!!">>$logfile
     fi
fi
