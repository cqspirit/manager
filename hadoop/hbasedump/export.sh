#!/bin/sh
#by geyong jue 4 2012

export oper=$1
export logfile="./logs/datamove-$oper-$(date +%Y%m%d-%H%M).log"

function execute(){
  if  [ "$1"x = ""x ] ;
  then
     echo "Processing notes" > /dev/null
  else
     dump $*
  fi
}

function dump(){
  echo "*********************************************$(date +%Y%m%d-%H%M)************************************************************" 	|tee -a $logfile
  echo "start  $oper table:$1"  												   	|tee -a $logfile
  if [ "$oper"x = "import"x ]; then
        tablename=$2
  else
        tablename=$1 
  fi
  echo "command is:hbase org.apache.hadoop.hbase.mapreduce.Driver $oper $tablename /move/import/$1 " 				        |tee -a $logfile
  nohup su - hdfs "hbase org.apache.hadoop.hbase.mapreduce.Driver $oper $tablename /move/import/$1 "  |tee -a $logfile
  echo "finish $oper table:$1" 														|tee -a $logfile
  echo "the result is $?"														|tee -a $logfile
  echo "*********************************************$(date +%Y%m%d-%H%M)************************************************************" |tee -a $logfile
}

export -f dump 
export -f execute

usage="usage:./dump.sh export|import"
if [ $# -ne 1 ]; then
  echo $usage
  exit 1
fi
case $1 in
  import);;
  export);;
  *)echo $usage;exit 1;
esac
shift

if [ -f $logfile ]; then
  echo "$logifle exists!"
else
  touch $logfile
fi
echo "start Time is: $(date +%Y%m%d-%H%M) " >>$logfile
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
awk -F"\t+" '{system("execute " $1" "$2 )}' $bin/tables.conf
echo "end Time is: $(date +%Y%m%d-%H%M) " >>$logfile
