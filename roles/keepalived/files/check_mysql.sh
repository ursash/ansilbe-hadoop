#!/bin/bash

#MYSQL_PORT=3306
pid_file=/tmp/`basename $0`.pid
if [ -f $pid_file ];then
 ps -p `cat $pid_file` &> /dev/null
 [[ "$?" -eq "0" ]] && echo "`date` : $0 exist." && exit 0
fi
echo $$ > $pid_file

KEEPALIVED_STATUS=`ps -C keepalived --no-header | wc -l`
MYSQL_STATUS=`ps -C mysqld --no-header | wc -l`

if [[ $MYSQL_STATUS -eq 0 ]];then
 if [[ $KEEPALIVED_STATUS -ne 0 ]];then
  service keepalived stop
 fi
else
 if [[ $KEEPALIVED_STATUS -eq 0 ]];then
  service keepalived start
 fi
fi