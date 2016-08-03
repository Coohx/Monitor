#!/bin/bash
# 发送邮件的脚本
# 传入参数 $1 $2 组成邮件的主题  $3是邮件的内容

log=$1
#当前时间戳 
t_s=`date +%s`
#两个小时以前的时间戳
t_s2=`date -d "2 hours ago" +%s`
if [ ! -f /tmp/$log ]
then
	#首次执行脚本创建和$1同名的log文件，保存时间戳
	echo $t_s2 > /tmp/$log
fi

t_s2=`tail -1 /tmp/$log|awk '{print $1}'`
#每一次执行完后，将当前时刻的时间戳追加到log文件，下一次执行脚本时作为t_s2的时间戳,用于计算前后两次执行脚本的时间差
echo $t_s>>/tmp/$log


v=$[$t_s-$t_s2]
echo $v

if [ $v -gt 3600 ]       #如果这次发送告警的时间距离上次发送告警邮件的时间大于3600s
then    
	#执行mail.php，调用邮件引擎
	# "$1 $2"是邮件主题  $3是邮件内容
 	/usr/bin/php  ../mail/mail.php "$1 $2" "$3"
	#若至少3在600s以后发送下一次告警，则用0标记本次告警，即保证告警频率为1小时一次
 	echo "0" > /tmp/$log.txt
else    
	#如果3600s内此脚本被在调用了10次以上，即故障持续了10次，则发送一次警告
	#log.txt 里面记录故障发生的次数，做邮件收敛
	if [ ! -f /tmp/$log.txt ]
	then
    	echo "0" > /tmp/$log.txt
	fi
  	nu=`cat /tmp/$log.txt`
    nu2=$[$nu+1]
    echo $nu2>/tmp/$log.txt
    if [ $nu2 -gt 10 ]
    then    
        /usr/bin/php  ../mail/mail.php "trouble continue 10 min $1  $2 " "$3"
        echo "0" > /tmp/$log.txt
    fi      
fi      

