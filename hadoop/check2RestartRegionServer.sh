#add by geyong Aug 11 2014
#description: check regionserver status,if it is down,restart it

export logfile="/var/log/regionserver-status-$(date +%Y%m%d).log"

if [ -f $logfile ]; then
  echo "$logifle exists!"
else
  touch $logfile
fi

PS="/bin/ps"
GREP="/bin/grep"

ret=`$PS auxwwwf |$GREP java|$GREP HRegionServer|wc -l `

if [[ "$ret" -ge "1" ]]; then
     echo "[$(date +%Y-%m-%d %H:%M)]:OK!  RegionServer is running!">>$logfile
else
     echo "[$(date +%Y-%m-%d %H:%M)]:CRITICAL!! RegionServer is down!">>$logfile
     echo "[$(date +%Y-%m-%d %H:%M)]:start RegionServer........">>$logfile
     su - hbase -c "/usr/lib/hbase/bin/hbase-daemon.sh --config /etc/hbase/conf start regionserver"
     if [[ "$?" -ne "1" ]]; then
        echo "[$(date +%Y-%m-%d %H:%M)]:start RegionServer successed!!">>$logfile
     else
        echo "[$(date +%Y-%m-%d %H:%M)]:start RegionServer failed!!!">>$logfile
     fi
fi
