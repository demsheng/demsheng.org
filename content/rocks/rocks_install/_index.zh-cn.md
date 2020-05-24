---
title: rocks 重装
weight: 14
pre: "<b></b>"
---



### 1. 依赖库重装  

#### 1. 安装　`convert` 命令

1. 方法一：参考　https://blog.csdn.net/gaofuqi/article/details/26698547

	```
	cd /home/li_changsheng/bin/
	wget  http://www.imagemagick.org/download/ImageMagick-6.8.9-1.tar.gz
	tar xvf  ImageMagick-6.8.9-1.tar.gz
	cd ImageMagick-6.8.9-1
	./configure --prefix=/home/li_changsheng/bin/ImageMagick-6.8.9-1-install
	make install
	```
	- 在http://www.imagemagick.org/download/上找到合适的版本，然后下载，我选择的版本是 ImageMagick-6.9.10-71.tar.gz
		```
		wget  http://www.imagemagick.org/download/ImageMagick-6.8.9-1.tar.gz 
		```
	- 解压刚才下载的文件
		```
		tar xvf  ImageMagick-6.8.9-1.tar.gz
		```
	- 进入解压目录：　
		```
		cd ImageMagick-6.8.9-1
		```
	- 检查配置，`--prefix` 重要！
		```
		./configure --prefix=/home/li_changsheng/bin/ImageMagick-6.8.9-1-install
		```
	如果发现没有安装jpeg（如下图），则必须先安装jpeg  
	- 安装jpeg：
	```
	yum install libjpeg* libpng* freetype* gd*
	```
	- 安装ImageMagick
	```
 		make install
	```
	输入convert -resize 100x100 src.jpg des.jpg  执行成功，表明安装成功。
	
2. 方法二：在每个节点运行　`yum install ImageMagick` 


### 2. 系统重装  
参考　http://www.rocksclusters.org/assets/usersguides/roll-documentation/base/6.2/install-frontend.html

1. Rocks官网 下载 rocks6.2 系统iso，（软碟通　或者　win7自带刻录，忘记哪个可以了）刻录到光盘

2. 设置光盘启动，安装主节点

3. 主节点运行 `insert-ethers`
4. 计算节点，设置网络启动，即可自动安装计算节点

### 3. 问题

1. 如果计算节点无法登录:

```
rocks set host sec_attr compute attr=root_pw
rocks sync host sec_attr compute
```

2. 如果 SGE 任务一直未　`wq` 状态，需要重新设置SGE，配置方法见[SGE]({{%relref "/rocks/SGE/_index.zh-cn.md" %}})


### 4. 修改节点名
参考　https://blog.csdn.net/weixin_40203160/article/details/78404527

#### 修改单个计算节点名字
1. 修改rocks的host名称

	```
	rocks set host name       compute-0-3       node13 
	rocks set host interface  name node13  eth0 node13
	```
	
2. 主节点和计算节点　`/etc/hosts` 中修改名字

	```
	10.1.255.251    node13.local    node13
	```
	
3. node13中

	```
	mv /opt/gridengine/default/spool/compute* /opt/gridengine/default/spool/node13
	```

4. 管理节点中，目录
`/opt/gridengine/default/common/local_conf`
`/opt/gridengine/default/spool/qmaster/admin_hosts`
`/opt/gridengine/default/spool/qmaster/exec_hosts`
下，文件名修改，其内容也修改

	```
	#compute-0-3      node13
	mv /opt/gridengine/default/common/local_conf/compute-0-3.local  /opt/gridengine/default/common/local_conf/node13.local
	sed -i "/conf_name/c\conf_name                    node3.local " /opt/gridengine/default/common/local_conf/node13.local
	mv /opt/gridengine/default/spool/qmaster/admin_hosts/compute-0-3.local  /opt/gridengine/default/spool/qmaster/admin_hosts/node13.local
	sed -i "/hostname/c\hostname  node3.local " /opt/gridengine/default/spool/qmaster/admin_hosts/node13.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-3.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node13.local
	sed -i "/hostname/c\hostname                    node13.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node13.local
	```

5. 重启SGE

	```
	/etc/init.d/sgemaster.sandbox stop
	/etc/init.d/sgemaster.sandbox start

	ssh node13 "/etc/init.d/sgeexecd.sandbox stop"
	ssh node13 "/etc/init.d/sgeexecd.sandbox start"
	```
	
#### 批量修改计算节点名字

1. 修改rocks的host名称
修改前后的主机名称，使用命令 `rocks list host` 可以查看所有节点主机名称
`1change.sh` 脚本如下：

	```
	#!/bin/bash
	rocksSetName()
	{
		rocks set host name   compute-0-3       node13 
		rocks set host name   compute-0-13      node12 
		rocks set host name   compute-0-2       node11 
		rocks set host name   compute-0-12      node10
		rocks set host name   compute-0-1       node9
		rocks set host name   compute-0-9       node8
		rocks set host name   compute-0-0       node6 
		rocks set host name   compute-0-10      node5 
		rocks set host name   compute-0-7       node4 
		rocks set host name   compute-0-11      node3 
		rocks set host name   compute-0-8       node7
		rocks set host name   compute-0-6       node1
		rocks set host name   compute-0-14      node0
		for i in {3..13}
		do
			rocks set host interface  name node$i  eth0 node$i
		done
		rocks set host interface  name node1  eth0 node1
		rocks set host interface  name node0  eth0 node0
	}

	rocksSetName
	```
	
2. 系统主机名称的修改
在系统文件 `/etc/hosts` 记录的是管理节点和计算节点的内网地址和主机名称，使用vim命令做相应的修改，注意ip地址和主机名称的对应

	```
	127.0.0.1       localhost.localdomain   localhost

	10.1.255.249    compute-0-15.local      compute-0-15
	10.1.255.250    node0.local     node0
	10.1.255.248    node1.local     node1
	10.1.255.242    node10.local    node10
	10.1.255.252    node11.local    node11
	10.1.255.241    node12.local    node12
	10.1.255.251    node13.local    node13
	10.1.255.243    node3.local     node3
	10.1.255.247    node4.local     node4
	10.1.255.244    node5.local     node5
	10.1.255.254    node6.local     node6
	10.1.255.246    node7.local     node7
	10.1.255.245    node8.local     node8
	10.1.255.253    node9.local     node9
	10.1.1.1        sandbox.local   sandbox
	172.18.127.150  sandbox.ecut.edu.cn
	```
	
	这是管理节点上的主机名称修改，与此相对应的，每一个计算节点上都需要做相应的修改，运行如下脚本 `2change.sh` ：
	
	```
	#!/bin/bash
	nodeHostname()
	{
		# modify the hostname
		for i in {3..13}
		do
		    ssh node$i "hostname node$i.local"
		    ssh node$i sed -i "/HOSTNAME/c\HOSTNAME=node$i.local" /etc/sysconfig/network
		done
		ssh node1 "hostname node1.local"
		ssh node1 sed -i "/HOSTNAME/c\HOSTNAME=node1.local" /etc/sysconfig/network
		ssh node0 "hostname node0.local"
		ssh node0 sed -i "/HOSTNAME/c\HOSTNAME=node0.local" /etc/sysconfig/network

		# modify the files /etc/hosts
		ssh node13  'sed -i "/10.1.255.251/c\10.1.255.251 node13.local node13  " /etc/hosts'
		ssh node12 'sed -i "/10.1.255.241/c\10.1.255.241 node12.local node12  " /etc/hosts'
		ssh node11 'sed -i "/10.1.255.252/c\10.1.255.252 node11.local node11  " /etc/hosts'
		ssh node10 'sed -i "/10.1.255.242/c\10.1.255.242 node10.local node10  " /etc/hosts'
		ssh node9  'sed -i "/10.1.255.253/c\10.1.255.253 node9.local node9  " /etc/hosts'
		ssh node8  'sed -i "/10.1.255.245/c\10.1.255.245 node8.local node8  " /etc/hosts'
		ssh node7  'sed -i "/10.1.255.246/c\10.1.255.246 node7.local node7  " /etc/hosts'
		ssh node6  'sed -i "/10.1.255.254/c\10.1.255.254 node6.local node6  " /etc/hosts'
		ssh node5  'sed -i "/10.1.255.244/c\10.1.255.244 node5.local node5  " /etc/hosts'
		ssh node4  'sed -i "/10.1.255.247/c\10.1.255.247 node4.local node4  " /etc/hosts'
		ssh node3  'sed -i "/10.1.255.243/c\10.1.255.243 node3.local node3  " /etc/hosts'
		ssh node1  'sed -i "/10.1.255.248/c\10.1.255.248 node1.local node1  " /etc/hosts'
		ssh node0  'sed -i "/10.1.255.250/c\10.1.255.250 node0.local node0  " /etc/hosts'

		for i in {3..13}
		do
		    ssh node$i "mv /opt/gridengine/default/spool/compute* /opt/gridengine/default/spool/node$i"
		done
		ssh node1 "mv /opt/gridengine/default/spool/compute* /opt/gridengine/default/spool/node1"
		ssh node0 "mv /opt/gridengine/default/spool/compute* /opt/gridengine/default/spool/node0"
	}

	nodeHostname

	```

4. SGE配置文件的修改
在 `/opt/gridengine/default/common/local_conf` 目录下存放着计算节点文件，具体如下

	```
	-rw-r--r-- 1 sge sge 289 Nov  5 22:31 compute-0-15.local
	-rw-r--r-- 1 sge sge 283 Oct 22 23:23 node0.local
	-rw-r--r-- 1 sge sge 284 Oct 22 23:19 node10.local
	-rw-r--r-- 1 sge sge 284 Oct 22 23:18 node11.local
	-rw-r--r-- 1 sge sge 284 Oct 22 23:16 node12.local
	-rw-r--r-- 1 sge sge 283 Oct 22 22:42 node13.local
	-rw-r--r-- 1 sge sge 283 Oct 22 23:22 node1.local
	-rw-r--r-- 1 sge sge 283 Oct 22 23:22 node3.local
	-rw-r--r-- 1 sge sge 283 Oct 22 23:21 node4.local
	-rw-r--r-- 1 sge sge 283 Oct 22 23:21 node5.local
	-rw-r--r-- 1 sge sge 283 Oct 22 23:26 node6.local
	-rw-r--r-- 1 sge sge 282 Nov  6 12:30 node7.local
	-rw-r--r-- 1 sge sge 283 Oct 22 23:20 node8.local
	-rw-r--r-- 1 sge sge 283 Oct 22 23:19 node9.local
	-rw-r--r-- 1 sge sge 225 Oct 20 22:48 sandbox.local
	```
	
	不仅仅在这个目录，在另外两个目录下同样存放着类似文件，分别是
`/opt/gridengine/default/spool/qmaster/admin_hosts` , `/opt/gridengine/default/spool/qmaster/exec_hosts`
修改方法类似，可以使用sed命令做批量修改。脚本 `3sge_set.sh` 如下

	```
	#!/bin/bash

	#sge 
	#compute-0-3      node13
	mv /opt/gridengine/default/common/local_conf/compute-0-3.local  /opt/gridengine/default/common/local_conf/node13.local
	sed -i "/conf_name/c\conf_name                    node3.local " /opt/gridengine/default/common/local_conf/node13.local
	mv /opt/gridengine/default/spool/qmaster/admin_hosts/compute-0-3.local  /opt/gridengine/default/spool/qmaster/admin_hosts/node13.local
	sed -i "/hostname/c\hostname  node3.local " /opt/gridengine/default/spool/qmaster/admin_hosts/node13.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-3.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node13.local
	sed -i "/hostname/c\hostname                    node13.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node13.local

	# compute-0-13      node12 
	mv /opt/gridengine/default/common/local_conf/compute-0-13.local  /opt/gridengine/default/common/local_conf/node12.local
	sed -i "/conf_name/c\conf_name                    node12.local " /opt/gridengine/default/common/local_conf/node12.local
	mv /opt/gridengine/default/spool/qmaster/admin_hosts/compute-0-13.local  /opt/gridengine/default/spool/qmaster/admin_hosts/node12.local
	sed -i "/hostname/c\hostname  node12.local " /opt/gridengine/default/spool/qmaster/admin_hosts/node12.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-13.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node12.local
	sed -i "/hostname/c\hostname  node12.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node12.local

	# compute-0-2       node11 
	mv /opt/gridengine/default/common/local_conf/compute-0-2.local   /opt/gridengine/default/common/local_conf/node11.local
	sed -i "/conf_name/c\conf_name                    node11.local " /opt/gridengine/default/common/local_conf/node11.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-2.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node11.local
	sed -i "/hostname/c\hostname                      node11.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node11.local

	# compute-0-12      node10
	mv /opt/gridengine/default/common/local_conf/compute-0-12.local  /opt/gridengine/default/common/local_conf/node10.local
	sed -i "/conf_name/c\conf_name                    node10.local " /opt/gridengine/default/common/local_conf/node10.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-12.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node10.local
	sed -i "/hostname/c\hostname                      node10.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node10.local


	#rocks set host name   compute-0-1       node9
	mv /opt/gridengine/default/common/local_conf/compute-0-1.local  /opt/gridengine/default/common/local_conf/node9.local
	sed -i "/conf_name/c\conf_name                    node9.local " /opt/gridengine/default/common/local_conf/node9.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-1.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node9.local
	sed -i "/hostname/c\hostname                      node9.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node9.local


	#rocks set host name   compute-0-9       node8
	mv /opt/gridengine/default/common/local_conf/compute-0-9.local  /opt/gridengine/default/common/local_conf/node8.local
	sed -i "/conf_name/c\conf_name                    node8.local " /opt/gridengine/default/common/local_conf/node8.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-9.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node8.local
	sed -i "/hostname/c\hostname                      node8.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node8.local

	#rocks set host name   compute-0-0       node6 
	mv /opt/gridengine/default/common/local_conf/compute-0-0.local  /opt/gridengine/default/common/local_conf/node6.local
	sed -i "/conf_name/c\conf_name                    node6.local " /opt/gridengine/default/common/local_conf/node6.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-0.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node6.local
	sed -i "/hostname/c\hostname                      node6.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node6.local

	#rocks set host name   compute-0-10      node5 
	mv /opt/gridengine/default/common/local_conf/compute-0-10.local /opt/gridengine/default/common/local_conf/node5.local
	sed -i "/conf_name/c\conf_name                    node5.local " /opt/gridengine/default/common/local_conf/node5.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-10.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node5.local
	sed -i "/hostname/c\hostname                      node5.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node5.local


	#rocks set host name   compute-0-7       node4 
	mv /opt/gridengine/default/common/local_conf/compute-0-7.local  /opt/gridengine/default/common/local_conf/node4.local
	sed -i "/conf_name/c\conf_name                    node4.local " /opt/gridengine/default/common/local_conf/node4.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-7.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node4.local
	sed -i "/hostname/c\hostname                  node4.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node4.local


	#rocks set host name   compute-0-11      node3 
	mv /opt/gridengine/default/common/local_conf/compute-0-11.local  /opt/gridengine/default/common/local_conf/node3.local
	sed -i "/conf_name/c\conf_name                    node3.local " /opt/gridengine/default/common/local_conf/node3.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-11.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node3.local
	sed -i "/hostname/c\hostname                      node3.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node3.local


	#rocks set host name   compute-0-8       node7
	mv /opt/gridengine/default/common/local_conf/compute-0-8.local  /opt/gridengine/default/common/local_conf/node7.local
	sed -i "/conf_name/c\conf_name                    node7.local " /opt/gridengine/default/common/local_conf/node7.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-8.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node7.local
	sed -i "/hostname/c\hostname                      node7.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node7.local

	#rocks set host name   compute-0-6       node1
	mv /opt/gridengine/default/common/local_conf/compute-0-6.local  /opt/gridengine/default/common/local_conf/node1.local
	sed -i "/conf_name/c\conf_name                    node1.local " /opt/gridengine/default/common/local_conf/node1.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-6.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node1.local
	sed -i "/hostname/c\hostname                      node1.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node1.local

	#rocks set host name   compute-0-14      node0
	mv /opt/gridengine/default/common/local_conf/compute-0-14.local  /opt/gridengine/default/common/local_conf/node0.local
	sed -i "/conf_name/c\conf_name                    node0.local " /opt/gridengine/default/common/local_conf/node0.local
	mv /opt/gridengine/default/spool/qmaster/exec_hosts/compute-0-14.local   /opt/gridengine/default/spool/qmaster/exec_hosts/node0.local
	sed -i "/hostname/c\hostname                      node0.local " /opt/gridengine/default/spool/qmaster/exec_hosts/node0.local

	```

5. 重启守护进程
完成以上任务以后重启管理节点上的sgeqmaster守护进程以及所有计算节点下的sgeexecd进程，脚本 `4change.sh` 如下：

	```
	#!/bin/bash

	restartSge_execd()
	{
		/etc/init.d/sgemaster.sandbox stop
		/etc/init.d/sgemaster.sandbox start
		for i in {3..13}
		do
		    ssh node$i "/etc/init.d/sgeexecd.sandbox stop"
		    ssh node$i "/etc/init.d/sgeexecd.sandbox start"
		done
		ssh node1 "/etc/init.d/sgeexecd.sandbox stop"
		ssh node1 "/etc/init.d/sgeexecd.sandbox start"
		ssh node0 "/etc/init.d/sgeexecd.sandbox stop"
		ssh node0 "/etc/init.d/sgeexecd.sandbox start"
	}

	restartSge_execd
	```

6. 查看并且检验系统作业脚本和rocks管理脚本
运行 `qhost` ， 可以看到结果

7. 运行rocks命令， 比如 `rocks sync config` 或者所有计算节点运行同一个命令： `rocks run host ls` , 能够得出正常的输出结果即说明rocks管理脚本同样没有问题。





