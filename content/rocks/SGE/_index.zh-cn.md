---
title: SGE
weight: 9
pre: "<b></b>"
---

+ `qstat -u \*` 查看所有任务

+ `qstat -f`    查看所有计算节点任务占用情况

+ `qsub  -l h=sand-0-0 sge.sh` 把 sge.sh 提交到 sand-0-0 节点

+ 任务一直 `qw` 状态
	- 情况一：SGE未启动，首先登录子节点，启动服务
		```
		cd $SGE_ROOT/default/common/
		sudo ./sgeexecd start
		```

	- 情况二：SGE未添加集群队列  
	SGE部署参考 http://www.chenlianfu.com/?p=2441

		1. (不确定是否需要重新安装SGE) ，安装方法见 http://gridscheduler.sourceforge.net/CompileGridEngineSource.html
			
			```
			% tar zvxf SGE6.2u5p2.tar.gz
			% cd SGE6.2u5p2/source
			% ./aimk -no-java -no-jni -no-secure -spool-classic -no-dump -only-depend
			% ./scripts/zerodepend
			% ./aimk -no-java -no-jni -no-secure -spool-classic -no-dump depend
			% ./aimk -no-java -no-jni -no-secure -spool-classic -no-dump
			
			% export SGE_ROOT=/opt/SGE6  
			% mkdir $SGE_ROOT
			% scripts/distinst -all -local -noexit
			% cd $SGE_ROOT
			% ./install_qmaster
			% ./install_execd
			```
		
		2. 添加all.q集群队列 `qconf -aq all.q`
		3. 修改all.q集群队列配置 `qconf -mq all.q`
			
			```
			qname                 all.q
			#这里需要配置计算节点
			hostlist              node0.local node3.local node4.local node5.local \
						          node6.local node7.local node8.local node9.local \
						          node10.local node11.local node12.local node13.local \
						          compute-0-15.local 
			seq_no                0
			load_thresholds       np_load_avg=1.75
			suspend_thresholds    NONE
			nsuspend              1
			suspend_interval      00:05:00
			priority              0
			min_cpu_interval      00:05:00
			processors            UNDEFINED
			qtype                 BATCH INTERACTIVE
			ckpt_list             NONE
			#这里需要配置并行环境 orte
			pe_list               orte make
			rerun                 FALSE
			#这里需要配置每个计算节点运行的最大线程数
			slots                 8
			tmpdir                /tmp
			shell                 /bin/csh
			prolog                NONE
			epilog                NONE
			shell_start_mode      posix_compliant
			starter_method        NONE
			suspend_method        NONE
			resume_method         NONE
			terminate_method      NONE
			notify                00:00:60
			owner_list            NONE
			user_lists            NONE
			xuser_lists           NONE
			subordinate_list      NONE
			complex_values        NONE
			projects              NONE
			xprojects             NONE
			```
		
		3. 添加并行化环境 `qconf -ap orte`
		4. 修改并行化环境 `qconf -mp orte`
			
			```
			pe_name            orte
			#这里设置并行环境最大线程数
			slots              100
			user_lists         NONE
			xuser_lists        NONE
			start_proc_args    /bin/true
			stop_proc_args     /bin/true
			allocation_rule    $pe_slots
			control_slaves     FALSE
			job_is_first_task  TRUE
			urgency_slots      min
			accounting_summary FALSE
			```
			5 SGE命令
			```
			qconf -ae hostname
			添加执行主机
			qconf -de hostname
			删除执行主机
			qconf -sel
			显示执行主机列表

			qconf -ah hostname
			添加管理主机
			qconf -dh hostname
			删除管理主机
			qconf -sh
			显示管理主机列表

			qconf -as hostname
			添加提交主机
			qconf -ds hostname
			删除提交主机
			qconf -ss
			显示提交主机列表

			qconf -ahgrp groupname
			添加主机用户组
			qconf -mhgrp groupname
			修改主机用户组
			qconf -shgrp groupname
			显示主机用户组成员
			qconf -shgrpl
			显示主机用户组列表

			qconf -aq queuename
			添加集群队列
			qconf -dq queuename
			删除集群队列
			qconf -mq queuename
			修改集群队列配置
			qconf -sq queuename
			显示集群队列配置
			qconf -sql
			显示集群队列列表

			qconf -ap PE_name
			添加并行化环境
			qconf -mp PE_name
			修改并行化环境
			qconf -dp PE_name
			删除并行化环境
			qconf -sp PE_name
			显示并行化环境
			qconf -spl
			显示并行化环境名称列表

			qstat -f
			显示执行主机状态
			qstat -u user
			查看用户的作业
			qhost
			显示执行主机资源信息
			```
		
			通过使用命令qconf -mq queuename来对队列进行配置。修改hostlist来配置该队列可以使用执行主机；修改slots来配置各台执行主机可使用的线程数。从而对队列的计算资源进行设置。
			部署完毕SGE后，会生成一个默认主机用户组@allhosts（未生成），它包含所有的执行节点；生成一个默认的all.q队列名（未生成），它包含所有节点所有计算资源。默认的队列包含的计算资源是最大的。
		
		
+ 设置每个用户使用CPU核的上限

	`qconf -mrqs`
	```
	{
	   name         peruser_limit
	   description  "per user rule sets"
	   enabled      TRUE
	   limit        users {*} to slots=48
	}
	```
	`48` 表示每个用户最多能用的CPU核数

[以下参考自](`https://blog.csdn.net/sinat_19628145/article/details/88654277`)

+ 查看主机情况 `qhost -q`
	- `BIP`	正常
	- `E`	错误状态
	- `a`	警告(a generic indicator of badness)
	- `u`	无法连接
	- `d`	被管理员设置无法使用
	可以通过下列方法对某个队列上的的节点进行操作
	清除错误	 `qmod -c all.q@cca-train02`
	设置节点不可用 `qmod -d all.q@cca-train02`
	设置节点可用 `qmod -e all.q@cca-train02`
	重启节点，详细操作见后
	
+ 查看进程运行情况 `qstat -f`

	状态码 | 详细信息
	------|-------
	`r` | 正在执行 |
	`t` | 把节点跑死了，请杀掉，不可等，占用大量资源 |
	`s` | 被暂时挂起，往往是由于优先级更高的job抢占了资源 |
	`dr/dt` | 节点挂了之后，删除任务会出现这个状态，只有节点重启任务才会消失 |
	`qw` | 正在等待，一旦有计算资源会马上执行 |
	`Eqw` | job的提交产生错误 |
	`hqw` | 该job依赖于其它正在执行的job，待前面的job执行完毕后再开始执行 |



	`qstat -f` 结果中的states

	```
	(a)larm, (u)nreachable, (E)rror state
	(au) whenever: - A node is down - A node is hung/frozen - Network problems
	```

	遇到错误状态怎么办？

	- 查看某一个任务的详细情况,找到错误
		```
		qstat -j <job-id>
		qalter -w v job-id
		```
	- 将某个队列从错误状态转变回正常状态
		```
		qmod -c all.q
		```
	- 遇到 `dr/dt` 状态请依次尝试下方的解决方法

		参考网址
		```
		qdel -j <job-id>
		qdel -f <job-id>
		sudo qdel -f <job-id>
		```
+ **重启**

	- `[centos]:`
	
		```
		cd $SGE_ROOT/default/common/
		sudo ./sgemaster start
		sudo ./sgeexecd start
		```
		
	- `[linux]:`
		```
		sudo /etc/init.d/gridengine-exec stop
		```
	
	
