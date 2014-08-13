#!/bin/bash
SQL_path=/usr/local/mysql/bin/
SQL_pwd='mysql!123456'
Remote_ip=172.18.109.56
File_tmp=/public/data-backup/temp
socket=/tmp/mysql.sock

#1.next-37slaver backup databases;
version=$1
databases=$2 #'sense_users' #"sense_explore sense_future sense_live sense_management sense_report sense_review sense_users"
echo ">>>>>>>>>>1.start to backup dbs in slaver"
ssh root@$Remote_ip sh /public/app/batchscripts/multipleDump.sh  $version   $databases
#2.scp backup sql to local
echo ">>>>>>>>>>2.scp backup sql to local"
rm -rf $File_tmp/*$1.sql
scp -r root@$Remote_ip:/public/data-backup/tmp/*$1.sql $File_tmp
/bin/ls -l $File_tmp
#3.backup local dbs
echo ">>>>>>>>>>3.backup local dbs"
currTime=$(date +%Y%m%d-%H%M)
$SQL_path/mysqldump -h localhost -uroot -p$SQL_pwd --socket=$socket --all-databases | gzip >/public/data-backup/mysql/alldatabases-$currTime.sql.gz
#4.drop local dbs;
echo ">>>>>>>>>>4.truncate local dbs"
for i in $databases
  do
    $SQL_path/mysql -h localhost -uroot -p$SQL_pwd -e " create database IF NOT EXISTS $i;"
    echo "start to drop database:$i"
    $SQL_path/mysql -h localhost -uroot -p$SQL_pwd -e " drop database $i;"
    echo "start to create database:$i"
    $SQL_path/mysql -h localhost -uroot -p$SQL_pwd -e " create database IF NOT EXISTS $i;"
done
#5.create local dbs and import data;
echo "create local dbs and import data"
for i in $databases
  do
  $SQL_path/mysql -u root -p$SQL_pwd $i< $File_tmp/$i-$version.sql
done

if [ 0 -eq $? ]; then
   echo "sync database from $Remote_ip success！"
else
   echo "sync database from $Remote_ip failed!"
   exit
fi
