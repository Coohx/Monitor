#!/bin/bash
# 磁盘使用量监控子脚本
# Author:huangxin

rm -f ../log/disk.tmp
# awk -F '[ %]+' 指定两个分隔符：空格或% ,即空格和%都可以在同一行作为分隔符
# 过滤出磁盘各个分区的使用百分比
for r in `df -h |awk -F '[ %]+' '{print $5}'|grep -v Use`
do
    if [ $r -gt 90 ] && [ $send -eq "1" ];then
   		#记录磁盘使用量超过90%的信息
		echo "$addr `date +%T` disk useage is $r" >>../log/disk.tmp
	fi

	if [ -f ../log/disk.tmp ];then
		df -h >> ../log/disk.tmp
  		/bin/bash ../mail/mail.sh $addr\_disk $r ../log/disk.tmp
  		echo "`date +%T` disk useage is nook"
	else
    	echo "`date +%T` disk useage is ok"
	fi
done
