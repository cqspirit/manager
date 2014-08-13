#!/bin/bash
curversion=$1
shift
SQL_name=$* #'sense_explore sense_future sense_live sense_management sense_report sense_review sense_users'  #数据库名称；
SQL_pwd='mysql!123456'                        #数据库密码；
SQL_path=/usr/local/mysql/bin        #数据库命令目录；
BACKUP_tmp=/public/data-backup/tmp     #备份文件临时存放目录；
rm -rf $BACKUP_tmp/*$curversion.sql
#BACKUP_path=/public/data-backup/dump           #备份文件压缩打包存放目录；
for i in $SQL_name
  do
    echo "start to backup db:$i"
    $SQL_path/mysqldump -uroot -p$SQL_pwd $i > $BACKUP_tmp/$i-$curversion.sql
  sleep 3
done
 # sleep 10
