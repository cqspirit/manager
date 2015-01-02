#!/bin/sh
# by geyong  june 14 2012
# delete the expired files
find /public/data-backup/mysql -ctime +5 -exec rm -f {} \;
socket=/tmp/mysql.sock
currTime=$(date +%Y%m%d-%H%M) #string of date time
#bakup all databases
mysqldump -h localhost -uroot -p'mysql!123456' --socket=$socket  --all-databases | gzip >/public/data-backup/mysql/alldatabases-$currTime.sql.gz
