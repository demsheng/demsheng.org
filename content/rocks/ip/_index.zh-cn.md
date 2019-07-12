---
title: IP配置
weight: 10
pre: "<b></b>"
---


+ `ifconfig` 查看IP地址

	```
		em1       Link encap:Ethernet  HWaddr ****  
				  inet addr:192.168.1.32  Bcast:10.10.1.255  Mask:255.255.255.0 # 集群局域网ip地址
				  inet6 addr: **** Scope:Link
				  UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
				  RX packets:11297 errors:0 dropped:0 overruns:0 frame:0
				  TX packets:4578 errors:0 dropped:0 overruns:0 carrier:0
				  collisions:0 txqueuelen:1000 
				  RX bytes:1695966 (1.6 MiB)  TX bytes:652377 (637.0 KiB)
				  Interrupt:35 

		em2       Link encap:Ethernet  HWaddr ****  
				  inet addr:114.2.1.1  Bcast:114.2.255.255  Mask:255.255.240.0 # 外网ip地址，我们都是连接这个ip
				  inet6 addr:  ***** Scope:Link
				  UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
				  RX packets:748 errors:0 dropped:0 overruns:0 frame:0
				  TX packets:1824 errors:0 dropped:0 overruns:0 carrier:0
				  collisions:0 txqueuelen:1000 
				  RX bytes:80412 (78.5 KiB)  TX bytes:194872 (190.3 KiB)
				  Interrupt:38 

		lo        Link encap:Local Loopback  
				  inet addr:127.0.0.1  Mask:255.0.0.0
				  inet6 addr: ::1/128 Scope:Host
				  UP LOOPBACK RUNNING  MTU:16436  Metric:1
				  RX packets:121109 errors:0 dropped:0 overruns:0 frame:0
				  TX packets:121109 errors:0 dropped:0 overruns:0 carrier:0
				  collisions:0 txqueuelen:0 
				  RX bytes:26637971 (25.4 MiB)  TX bytes:26637971 (25.4 MiB)
	```


+ `/etc/sysconfig/network-scripts/ifcfg-em2` 中保存了IP配置信息

	`more /etc/sysconfig/network-scripts/ifcfg-em2` 动态IP配置
	
	```
	DEVICE=em2
	HWADDR=43:21:32:43:21:32
	#IPADDR=114.123.123.123 #注释
	#NETMASK=255.255.255.0  #注释
	BOOTPROTO=dhcp          #dhcp动态获取IP
	ONBOOT=yes              #启用该网口
	MTU=1500
	```
	
	`more /etc/sysconfig/network-scripts/ifcfg-em2` 静态IP配置
	
	```
	DEVICE=em2
	HWADDR=43:21:32:43:21:32 
	IPADDR=114.123.123.123  #设置的静态IP地址
	NETMASK=255.255.255.0   #
	BOOTPROTO=static        #静态IP
	ONBOOT=yes              #启用该网口
	MTU=1500
	```





