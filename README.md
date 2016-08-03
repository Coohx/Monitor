### Monitor 自定监控

>  思路：指定一个脚本包，包含主程序、子程序、配置文件、邮件引擎、输出日志等。
   > a.主程序：作为整个脚本的入口，是整个系统的命脉。
   > b.配置文件：是一个控制中心，用它来开关各个子程序，指定各个相关联的日志文件。
   > c.子程序：这个才是真正的监控脚本，用来监控各个指标。
   > d.邮件引擎：是由一个php程序来实现，它可以定义发邮件的服务器、发邮件人以及收邮件人。
   > e.输出日志：整个监控系统要有日志输出。


>  mon目录，总监控目录(monitor)

```
   含有5个子目录：
        bin 主脚本目录
		conf 配置文件目录
		mail 邮件引擎，含php、shell脚本
		shares 子shell脚本目录
		log 输出日志

```


> 监控系统架构：
```

                                        （主目录 mon）
                 ___________________________________|_____________________________________
                |          |                    |                   |                     |
               bin        conf                shares               mail                  log
                |          |                    |                   |                     |
           [main.sh]   [ mon.conf]       [load.sh 502.sh]   [mail.php mail.sh]    [mon.log err.log ]


```