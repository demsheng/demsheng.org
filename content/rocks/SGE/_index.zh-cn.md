---
title: SGE
weight: 9
pre: "<b></b>"
---

+ `qstat -u \*` 查看所有任务

+ `qstat -f`    查看所有计算节点任务占用情况

+ `qsub  -l h=sand-0-0 sge.sh` 把 sge.sh 提交到 sand-0-0 节点

+ 任务一直 `qw` 状态，首先登录子节点，启动服务
	```
	cd $SGE_ROOT/default/common/
	sudo ./sgeexecd start
	```

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
	
	
