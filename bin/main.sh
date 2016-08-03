#!/bin/bash
# main.sh 主脚本，整个脚本的入口
#Written by huangxin

# 是否发送邮件的开关
export send=1
# 过滤ip地址    grep -A 1 输出匹配到的内容和它下面的1行  awk -F 指定分段符
export addr=`/sbin/ifconfig |grep -A1 'eth0' |grep addr: |awk '{print $2}'|awk -F: '{print $2}'`
dir=`pwd`
# 只需要最后一级目录名  awk的内址变量NF指匹配到的行的段数
# last_dir=`echo $dir|awk -F'/' '{print $NF}'`
last_dir=`echo ${dir##/*/}`

# 下面的判断目的是，保证执行脚本的时候，我们在bin目录里，不然监控脚本、邮件和日志很有可能找不到  
# bin目录固定不变的，bin的上级目录mon的路径是不确定的，所以依靠相对路径bin来确定其他几个目录
if [ $last_dir == "bin" ] || [ $last_dir == "bin/" ]; then
    conf_file="../conf/mon.conf"
else
    echo "you should cd bin dir"
    exit
fi

# exec定义输出日志，规范化 
# exec将当前脚本及其子脚本的所有的重定向统一管理,将标准输出、标准错误追加到指定的日志文件中
exec 1>>../log/mon.log 2>>../log/err.log

#向日志中记录负载信息，调用load.sh子脚本
echo "`date +"%F %T"` load average"
/bin/bash ../shares/load.sh

#先检查配置文件中是否需要监控502  to_mon_502=1 就需要监控
if grep -q 'to_mon_502=1' $conf_file; then
    export log=`grep 'logfile=' $conf_file |awk -F '=' '{print $2}' |sed 's/ //g'`
    /bin/bash  ../shares/502.sh
fi
