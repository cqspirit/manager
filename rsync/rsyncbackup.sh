#!/bin/sh
# by geyong
# backup all bactchScripts
logfile="/public/app/batchscripts/rsync.log"
if [ -f $logfile ]; then
  echo "power cloaked in simplicity!">>$logfile
else
  touch $logfile
  echo "power cloaked in simplicity!">>$logfile
fi
currTime=$(date +%Y%m%d-%H%M) #string of date time
echo "=========================================$currTime================================================================">>$logfile
echo "******************Start rsync batchScripts,start time is $(date +%Y%m%d-%H%M)*****************************************">>$logfile
echo "start to rsync 172.29.34.96 backupfiles! current  time is $(date +%Y%m%d-%H%M)">>$logfile
rsync -vzrtopg --progress --delete root@172.29.34.96::mysql-backup  --password-file=/etc/rsyncd-client.scrt /public/data-backup/172.29.34.96/ >>$logfile
echo "start to rsync 172.29.34.116 backupfiles!current  time is $(date +%Y%m%d-%H%M)">>$logfile
rsync -vzrtopg --progress --delete root@172.29.34.116::mysql-backup --password-file=/etc/rsyncd-client.scrt /public/data-backup/172.29.34.116/ >>$logfile
echo "start to rsync 172.29.35.187 backupfiles!current  time is $(date +%Y%m%d-%H%M)">>$logfile
rsync -vzrtopg --progress --delete root@172.29.35.187::mysql-backup --password-file=/etc/rsyncd-client.scrt /public/data-backup/172.29.35.187/ >>$logfile
echo "start to rsync 137.132.145.151 backupfiles!current  time is $(date +%Y%m%d-%H%M)">>$logfile
rsync -vzrtopg --progress --delete root@137.132.145.151::mysql-backup --password-file=/etc/rsyncd-client.scrt /public/data-backup/137.132.145.151/ >>$logfile
echo "start to rsync lms-i.comp.nus.edu.sg backupfiles!current  time is $(date +%Y%m%d-%H%M)">>$logfile
rsync -vzrtopg --progress --delete root@lms-i.comp.nus.edu.sg::data-backup --password-file=/etc/rsyncd-client.scrt /public/data-backup/lms-i.comp.nus.edu.sg/ >>$logfile
echo "start to rsync next1-i.comp.nus.edu.sg backupfiles!current  time is $(date +%Y%m%d-%H%M)">>$logfile
rsync -vzrtopg --progress --delete root@next1-i.comp.nus.edu.sg::data-backup --password-file=/etc/rsyncd-client.scrt /public/data-backup/next1-i.comp.nus.edu.sg/ >>$logfile
echo "*****************finished backup batchscripts,end time is $(date +%Y%m%d-%H%M)*****************************************">>$logfile
