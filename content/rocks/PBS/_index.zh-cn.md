---
title: PBS
weight: 11
pre: "<b></b>"
---

#### 查看　提交　删除

+ `qstat` 查看
+ `qsub  pbs.sh` 提交

	`pbs.sh`　中内容：

	```
	#PBS -N sheng ##可以给任务一个名字,方便辨识
	#PBS -l nodes=1:ppn=12 ##使用1节点，每个节点12核
	vboxdaily push.py
	vbox2jpg --dir=./data
	convert -delay 100 ./data/*[0-9].jpg -loop 0 ./data/process.gif 
	```
+ `qdel 31` 删除作业号为31的作业

```
[zhangsan@mu01 ~]$ qsub pbs.sh 
28.mu01

[zhangsan@mu01 ~]$ qstat

Job id                    Name             User            Time Use S Queue
------------------------- ---------------- --------------- -------- - -----
31.mu01                    zhangsan         lichangsheng    00:00:13 R batch
   
[zhangsan@mu01 ~]$ qdel 28

[zhangsan@mu01 ~]$ qstat
Job id                    Name             User            Time Use S Queue
------------------------- ---------------- --------------- -------- - -----
31.mu01                    sheng            lichangsheng    00:22:43 C batch
```

```
Job id      Name       User      Time Use    S        Queue
作业号      作业名     提交人    运行的时间  作业状态  队列
```

通常作业状态：

- Q 作业排队
- R 作业执行
- C 作业清除
- E 作业退出
- H 作业挂起



PBS(Portable Batch System)最初由NASA的Ames研究中心开发，主要为了提供一个能满足异构计算网络需要的软件包，用于灵活的批处理，特别是满足高性能计算的需要，如集群系统、超级计算机和大规模并行系统。PBS的主要特点有：代码开放，免费获取；支持批处理、交互式作业和串行、多种并行作业。
