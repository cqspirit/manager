#!/bin/sh
#by geyong jue 4 2012

#export oper=$1
export src=next-20
export des=next-21
export logfile="./logs/distcp-$src-to-$des-$(date +%Y%m%d-%H%M).log"
function execute(){
  if  [ "$1"x = ""x ] ;
  then
     echo "Processing notes" > /dev/null
  else
     distcp $*
  fi
}

function distcp(){
  currTime=$(date +%Y%m%d-%H%M) #string of date time
  echo "*********************************************$currTime***********************************************************************" 	>>$logfile
  echo "start  distcp $1 from $src to $des "  											   	>>$logfile
  echo "command is:hadoop distcp -update -skipcrccheck hftp://$src:50070/export/modfiy/$1  webhdfs://$des:50070/move/import/$1				     "	>>$logfile
  hadoop distcp -update -skipcrccheck hftp://$src:50070/move/import/$1  webhdfs://$des:50070/move/import/$1 
  echo "finish distcp table:$1" 													>>$logfile
  echo "result is $?"															>>$logfile
  echo "*****************************************************************************************************************************" 	>>$logfile
}

export -f distcp
export -f execute

usage="usage:./distcp.sh"
if [ $# -ne 0 ]; then
  echo $usage
  exit 1
fi
#case $1 in
#  import);;
#  export);;
#  *)echo $usage;exit 1;
#esac
#shift

if [ -f $logfile ]; then
  echo "$logifle exists!"
else
  touch $logfile
fi

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
awk -F"\t+" '{system("execute " $1)}' $bin/tables.conf
