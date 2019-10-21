---
title: rocks 重装
weight: 13
pre: "<b></b>"
---



#### 1. 依赖库重装  
yum install ImageMagick #convert

#### 2. 系统重装  

1. rocks 下载 6 系统iso，（软碟通？win7自带刻录）刻录到光盘

2. 设置光盘启动，安装主节点

3. 设置网络启动，安装计算节点


	如果计算节点无法登录:

	```
	rocks set host sec_attr compute attr=root_pw
	rocks sync host sec_attr compute
	```

