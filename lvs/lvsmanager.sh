#!/bin/sh
#description:Start LVS of Director server
VIP=137.132.145.75
RIP1=137.132.145.151
RIP2=137.132.145.75
/etc/rc.d/init.d/functions
case "$1" in
   start)
       echo "start LVS of Director Server"
       #set the Virtual IP address and sysctl parameter
       #/sbin/ifconfig eth0:0 $VIP broadcast $VIP netmask 255.255.255.255 up
       echo "1">/proc/sys/net/ipv4/ip_forward
       #clear ipvs table
       /sbin/ipvsadm -C
       #set LVS
       /sbin/ipvsadm -A -t $VIP:8080 -s rr -p 600
       /sbin/ipvsadm -a -t $VIP:8080 -r $RIP1:8080 -i
       /sbin/ipvsadm -a -t $VIP:8080 -r $RIP2:8080 -i
       #Run LVS
       /sbin/ipvsadm
       ;;
   stop)
       echo "close LVS Director sever"
       echo "0">/proc/sys/net/ipv4/ip_forward
       /sbin/ipvsadm -C
       #/sbin/ifconfig eth0:0 down
       ;;
    *)
    echo "Usage:$0 {start|stop}"
    exit 1
esac
