#!/bin/bash
# 用于监控负载，即load average：1  5 15 ，与设定的上限值进行比较 
# Author：huangxin

#过滤出过去一分钟之内cpu的平均负载,取整数部分  工具-uptime
load=`uptime |awk -F 'average:' '{print $2}'|cut -d',' -f1|sed 's/ //g' |cut -d. -f1`
#负载>20且发邮件标志为1-->记录当前信息&发送告警邮件
if [ $load -gt 20 ] && [ $send -eq "1" ]  
then
    echo "$addr `date +%T` load is $load" >../log/load.tmp
	#调用发邮件脚本(此处进行参数传递)  
    /bin/bash ../mail/mail.sh $addr\_load $load ../log/load.tmp
fi
#输出负载信息到标准日志  由main.sh中的exec定义
#记录所有的负载信息，包括正常和不正常
echo "`date +%T` load is $load"
