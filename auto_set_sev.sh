#!/usr/bin/env bash

set -e 
usage() { echo "Usage: $0 [-a iplist] [-t type] [-p package] [ -s srcdest ] [ -d desdest]" 1>&2; exit 1; }

while getopts ":a:t:p:s:d:h" o; do
    case "${o}" in
        a)
            a=${OPTARG}
            ;;
        t)
            t=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        s)
            s=${OPTARG}
            ;;
        d)
            d=${OPTARG}
            ;;
        *)
		usage
            ;;
    esac
done
shift $((OPTIND-1))

echo $a $t $p

FILENAME=`pwd`/$(basename "$a")
IFS=$'\r\n' GLOBIGNORE='*' command eval  'XYZ=($(cat $FILENAME))'

echo $FILENAME

case $t in  
    "yum" )
       for i in ${XYZ[@]}  
       do  
          IFS=':' read -r -a array <<< "$i"
	  HOSTNAME=${array[0]}
	  USERNAME=${array[1]}
	  PASSWORD=${array[2]}
	  echo $HOSTNAME $USERNAME $PASSWORD 
          expect -c "
	        spawn ssh $USERNAME@$HOSTNAME \"yum -y install $p \"
	  	  expect {
		    \"*yes/no*\" {send \"yes\r\"; exp_continue}
	            \"*password:*\" {send \"$PASSWORD\r\"; exp_continue}
		  } "
       done   
       ;;
    "pip" )
       for i in ${XYZ[@]}  
       do  
          IFS=':' read -r -a array <<< "$i"
	  HOSTNAME=${array[0]}
	  USERNAME=${array[1]}
	  PASSWORD=${array[2]}
	  echo $HOSTNAME $USERNAME $PASSWORD 
          expect -c "
	        spawn ssh $USERNAME@$HOSTNAME \"pip install $p \"
	  	  expect {
		    \"*yes/no*\" {send \"yes\r\"; exp_continue}
	            \"*password:*\" {send \"$PASSWORD\r\"; exp_continue}
		  } "
       done
       ;;   
    "scp" )
       for i in ${XYZ[@]}  
       do  
          IFS=':' read -r -a array <<< "$i"
	  HOSTNAME=${array[0]}
	  USERNAME=${array[1]}
	  PASSWORD=${array[2]}
	  echo $HOSTNAME $USERNAME $PASSWORD 
          expect -c "
	        spawn scp -r  $s $USERNAME@$HOSTNAME:$d/
	  	  expect {
		    \"*yes/no*\" {send \"yes\r\"; exp_continue}
	            \"*password:*\" {send \"$PASSWORD\r\"; exp_continue}
		  } "
       done
       ;;
esac

