#! /bin/bash
#====================================================================
# sys-mon.sh
#
# Copyright (c) 2011, WangYan <webmaster@wangyan.org>
# All rights reserved.
# Distributed under the GNU General Public License, version 3.0.
#
# Monitor system mem and load, if too high, restart some service.
#
# See: https://wangyan.org/blog/sys-mon-shell-script.html
#
# V 0.5, Date: 2011-12-08
#====================================================================

# Need to monitor the service name
# Must be in /etc/init.d folder exists
NAME_LIST="httpd nginx mysql"

# Single process to allow the maximum CPU (%)
PID_CPU_MAX="25"

# The maximum allowed memory (%)
PID_MEM_SUM_MAX="95"

# The maximum allowed system load
SYS_LOAD_MAX="6"

# Log path settings
LOG_PATH="/var/log/sys-mon.log"

# Date time format setting
DATA_TIME=$(date +"%y-%m-%d %H:%M:%S")

# Your email address
EMAIL="webmaster@example.com"

# Your website url
MY_URL="http://106.187.38.210/p.php"

#====================================================================

for NAME in $NAME_LIST
do
    PID_CPU_SUM="0";PID_MEM_SUM="0"
    PID_LIST=`ps aux | grep $NAME | grep -v root`

    IFS_TMP="$IFS";IFS=$'\n'
    for PID in $PID_LIST
    do
        PID_NUM=`echo $PID | awk '{print $2}'`
        PID_CPU=`echo $PID | awk '{print $3}'`
        PID_MEM=`echo $PID | awk '{print $4}'`
#       echo "$NAME: PID_NUM($PID_NUM) PID_CPU($PID_CPU) PID_MEM($PID_MEM)"

        PID_CPU_SUM=`echo "$PID_CPU_SUM + $PID_CPU" | bc`
        PID_MEM_SUM=`echo "$PID_MEM_SUM + $PID_MEM" | bc`

        if [ `echo "$PID_CPU >= $PID_CPU_MAX" | bc` -eq 1 ];then
            if [[ "$NAME" = "php-fpm" || "$NAME" = "httpd" ]];then
                sleep 5
                if [ `echo "$PID_CPU >= $PID_CPU_MAX" | bc` -eq 1 ];then
                    echo "${DATA_TIME}: kill ${NAME}($PID_NUM) successful (CPU:$PID_CPU)" | tee -a $LOG_PATH
                    kill $PID_NUM
                fi
            else
                echo "${DATA_TIME}: [WARNING!] ${NAME}($PID_NUM) cpu usage is too high! (CPU:$PID_CPU)" | tee -a $LOG_PATH
            fi
        fi
    done
    IFS="$IFS_TMP"

    SYS_LOAD=`uptime | awk '{print $(NF-2)}' | sed 's/,//'`
    SYS_MON="CPU:$PID_CPU_SUM MEM:$PID_MEM_SUM LOAD:$SYS_LOAD"
#   echo -e "$NAME: $SYS_MON\n"

    SYS_LOAD_TOO_HIGH=`awk 'BEGIN{print('$SYS_LOAD'>'$SYS_LOAD_MAX')}'`
    PID_MEM_SUM_TOO_HIGH=`awk 'BEGIN{print('$PID_MEM_SUM'>'$PID_MEM_SUM_MAX')}'`

    if [[ "$SYS_LOAD_TOO_HIGH" = "1" || "$PID_MEM_SUM_TOO_HIGH" = "1" ]];then
        /etc/init.d/$NAME stop
        sleep 5
        for ((i=1;i<4;i++))
        do
            if [ `pgrep $NAME | wc -l` = "0" ];then
                echo "$DATA_TIME: Stop $NAME successful! ($SYS_MON)" | tee -a $LOG_PATH
                break
            else
                echo "${DATA_TIME}: [WARNING!] Stop $NAME failed[$i]! ($SYS_MON)" | tee -a $LOG_PATH
                pkill $NAME && killall $NAME
            fi
        done
        /etc/init.d/$NAME start
        sleep 5
        for ((ii=1;ii<4;ii++))
        do
            if [ `pgrep $NAME | wc -l` != "0" ];then
                echo "$DATA_TIME: Start $NAME successful!" | tee -a $LOG_PATH
                break
            else
                echo "${DATA_TIME}: [WARNING!] Start $NAME failed[$ii]! ($SYS_MON)" | tee -a $LOG_PATH
                /etc/init.d/$NAME start
                sleep 5
            fi
        done
        if [ `pgrep $NAME | wc -l` != "0" ];then
            echo "${DATA_TIME}: [ERROR!] Start $NAME failed! ($SYS_MON)" | mail -s "Start $NAME failed" $EMAIL
        fi
    fi
done

STATUS_CODE=`curl -o /dev/null -s -w %{http_code} $MY_URL`
#echo -e "STATUS CODE: $STATUS_CODE\n"

if [ "$STATUS_CODE" != "200" ];then
    sleep 3
    STATUS_CODE=`curl -o /dev/null -s -w %{http_code} $MY_URL`
    if [ "$STATUS_CODE" != "200" ];then
        echo "${DATA_TIME}: [WARNING!] Website Downtime! ($SYS_MON)" | tee -a $LOG_PATH
        echo "${DATA_TIME}: [WARNING!] Website Downtime! ($SYS_MON)" | mail -s "Start $NAME failed" $EMAIL
    fi
fi
