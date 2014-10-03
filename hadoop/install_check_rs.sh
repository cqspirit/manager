#!/bin/sh
#by geyong Oct 3 2014
yum install -y curl
curl https://raw.githubusercontent.com/cqspirit/manager/master/hadoop/check2RestartRegionServer.sh > /usr/bin/check2RestartRS.sh
chmod u+x /usr/bin/check2RestartRS.sh
echo '* * * * * root /usr/bin/check2RestartRS.sh'>/etc/crontab
/sbin/service crond restart 
