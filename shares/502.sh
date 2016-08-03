#!/bin/bsah
# nginx服务器上常见错误502监控子脚本

d=`date -d "-1 min" +%H:%M`
# $log 在主脚本指定，即监控网站的日志路径
c_502=`grep :$d:  $log  |grep ' 502 '|wc -l`
if [ $c_502 -gt 10 ] && [ $send == 1 ]; then
     echo "$addr $d 502 count is $c_502">../log/502.tmp
     /bin/bash ../mail/mail.sh $addr\_502 $c_502  ../log/502.tmp
fi
#记录日志
echo "`date +%T` 502 $c_502"

