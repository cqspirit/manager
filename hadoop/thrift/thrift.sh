#!/bin/sh
#by geyong jue 4 2012

export opobj=$1
export oper=$2
export filter=""
#export grep="/bin/grep"
export sortcond=""

function deal_cmd(){
  #echo "deal_cmd-$#:$*"
  if  [ "$1"x = ""x ] ;
  then
     echo "Processing notes" > /dev/null
  else
     executeHandler $*
  fi
}

function executeHandler(){
 #echo "exehandle-$#-$*"
 if [ "$1"x = "$opobj"x -o "$opobj"x = "all"x ] ;
 then
    execute $*
 else
    #echo "$opobj:$1"
    echo "not have to execute">/dev/null
 fi
}

function execute(){
  #echo $*
  if [ "status"x = "$oper"x ] ;
  then 
    print_cmd "$1"
    #echo "ssh $3@$2 $5 $6 $7 $8 $9"
    ssh root@$1 netstat -an |grep '0.0.0.0:9090' 
    #echo `exit`
    sleep 1
  elif [  "list"x = "$oper"x ] ;
  then
    ssh root@$1 netstat -an |grep ':9090' |grep -v '0.0.0.0:9090'
    sleep 1 
    #echo `exit` 
  elif [  "count"x = "$oper"x ] ;
  then
     executecount  $1
  elif [  "sort"x = "$oper"x ] ;
  then
     ssh root@$1 netstat -an |grep ':9090' |grep -v '0.0.0.0:9090' >> order
  else
    echo "null"
  fi
}

function print_cmd(){
   echo "*******$********************************************************************************"
}
function executecount(){
    print_cmd "$1"
    if [ "$filter"x = ""x ] ;
    then
      ssh root@$1 netstat -an |grep ':9090'|grep -v '0.0.0.0:9090 ' 
      curr=`ssh root@$1 netstat -an |grep ':9090' |grep -v '0.0.0.0:9090'|wc -l`
    else
      ssh root@$1 netstat -an |grep ':9090'|grep -v '0.0.0.0:9090'|grep $filter
      curr=`ssh root@$1 netstat -an |grep ':9090' |grep -v '0.0.0.0:9090'|grep $filter |wc -l`
    fi
    sleep 1
    echo "                                                                                     total:$curr"
    summ=`cat sum`
    summ=$[$summ+$curr]
    #echo $summ
    echo $summ >sum
}

function getsort(){
  for  i in $* ;
  do 
   sortcond=$sortcond" -k $i"
  done
  #echo "sortcond $sortcond"
}

export -f deal_cmd 
export -f executeHandler 
export -f execute
export -f print_cmd
export -f getsort
export -f executecount
#typeset -F

usage="usage:./thrift.sh next-(53,58,59,63,64,69,74,84,89,94,99)|all status|list|sort order|count [137.132.145] \n
	example:   ./thrift.sh  \tnext-53 status     	\t\t   #check the thriftserver listening port\n
            	\t ./thrift.sh  \tall     \tlist       	\t\t   #list all thrift connection by vm\n
           	\t ./thrift.sh  \tall     \tsort \t4    \t     #collect all thrift connections by vm and sort  by the column\n
            	\t ./thrift.sh  \tall     \tsort \t4  5 \t     \n
           	\t ./thrift.sh  \tall     \tcount      	\t\t   #collect all thrift connections and count by vm and sum the total\n
           	\t ./thrift.sh  \tall     \tcount\t75  	\t     #collect all thrift connections and filter by ip"
if [ $# -le 1 ]; then
  echo -e $usage
  exit 1
fi
case $1 in
  crawler-31);;
  crawler-36);;
  crawler-41);;
  crawler-50);;
  crawler-78);;
  crawler-83);;
  crawler-88);;
  crawler-93);;
  crawler-98);;
  all);;
  *)echo -e $usage;exit 1;
esac
shift
case $1 in
  count) filter=$2 ;;
  status) ;;
  list) ;;
  sort) getsort $2 $3 $4 $5 ;;
  *) echo -e $usage; exit 1;
esac
touch sum
touch order
echo "0" > sum
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
awk -F"\t+" '{system("deal_cmd " $1" "$2" "$3" "$4" "$5 )}' $bin/conf.sh

if [ "$1"x = "count"x ];
then
   print_cmd total  
   echo `cat sum`
elif [ "$1"x = "sort"x ];
then
  sort order $sortcond 
fi

rm -rf sum
rm -rf order
exit 0
