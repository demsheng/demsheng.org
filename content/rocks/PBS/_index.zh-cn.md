---
title: PBS
weight: 11
pre: "<b></b>"
---

参考 https://www.jianshu.com/p/2f6c799ca147

#### 查看　提交　删除

+ `qstat` 查看
+ `qstat -n` 查看提交节点等详细信息
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

    | Job id | Name    | User   | Time Use   | S        | Queue |
    | ------ | ------- | ------ | ---------- | -------- | ----- |
    | 作业号 |  作业名 | 提交人 | 运行的时间 | 作业状态 | 队列 |


通常作业状态S：

- Q 作业排队
- R 作业执行
- C 作业清除
- E 作业退出
- H 作业挂起



PBS(Portable Batch System)最初由NASA的Ames研究中心开发，主要为了提供一个能满足异构计算网络需要的软件包，用于灵活的批处理，特别是满足高性能计算的需要，如集群系统、超级计算机和大规模并行系统。PBS的主要特点有：代码开放，免费获取；支持批处理、交互式作业和串行、多种并行作业。

#### 作业控制
- qsub：提交作业
- qdel：取消作业
- qsig：给作业发送信号
- qhold：挂起作业
- qrls：释放挂起的作业
- qrerun：重新运行作业
- qmove：将作业移动到另一个队列
- qalter： 更改作业资源属性

#### 作业监测
- qstat：显示作业状态
- showq： 查看所有作业


#### 节点状态
- pbsnodes：列出集群中所有节点的状态和属性


#### PBS 作业属性

可以用两种方式设置 PBS 作业属性：

- 通过命令行参数传递给 qsub 命令；
- 在 PBS 脚本中以 #PBS 方式指定。

下表列出常用的 PBS 作业属性

| 属性 | 取值 | 说明 |
| :----- | :----- | :----- |
| -l | 以逗号分隔的资源列表 | 设定作业所需资源 |
| -N | 作业名称 | 设定作业的标准输出文件路径 |
| -o | 文件路径 | 设定作业的标准错误文件路径 |
| -e | 文件路径 | 设定作业名称 |
| -p | -1024 到 +1023 之间的整数 | 设定作业优先级，越大优先级越高 |
| -q | 队列名称 | 设定作业队列名称 |

比较常用的作业资源如下：

| 资源	 | 取值 | 说明 |
| :----- | :----- | :----- |
| nodes | 节点资源构型 | 设定作业所需计算节点资源 |
| walltime | hh:mm:ss | 设定作业所需的最大 wallclock 时间 |
| cput | hh:mm:ss | 设定作业所需的最大 CPU 时间 |
| mem | 正整数，后面可跟 b，kb，mb，gb | 设定作业所需的最大内存 |
| ncpus | 正整数 | 设定作业所需的 CPU 数目 |

可以用以下方法设定节点资源构型：

1. 设定所需节点数：`nodes=<num nodes>`
2. 设定所需节点数和每个节点上使用的处理器数目：`nodes=<num nodes>:ppn=<num procs per node>`
3. 设定所用的节点：`nodes=<list of node names separated by '+'>`

#### PBS 环境变量
下表列出常用的 PBS 环境变量：

| 环境变量    | 说明                                               |
| --------------- | ---------------------------------------------------- |
| PBS_ENVIRONMENT | 批处理作业为 PBS_BATCH，交互式作业为 PBS_INTERACTIVE |
| PBS_JOBID       | PBS 系统给作业分配的标识号                |
| PBS_JOBNAME     | 用户指定的作业名称                          |
| PBS_NODEFILE    | 包含作业所用计算节点的文件名           |
| PBS_QUEUE       | 作业所执行的队列名称                       |
| PBS_O_HOME      | 执行 qsub 命令的 HOME 环境变量值           |
| PBS_O_PATH      | 执行 qsub 命令的 PATH 环境变量值           |
| PBS_O_SHELL     | 执行 qsub 命令的 SHELL 环境变量值          |
| PBS_O_HOST      | 执行 qsub 命令节点名称                       |
| PBS_O_QUEUE     | 提交的作业的最初队列名称                 |
| PBS_O_WORKDIR   | 执行 qsub 命令所在的绝对路径              |

#### 提交批处理作业
用以下命令形式提交批处理作业：
`qsub [options] <control script>`

作业提交后一般会先排队等待，PBS 系统会根据作业的优先级和可用的计算资源来调度和执行作业。

PBS 脚本本质上是一个 Linux shell 脚本，在 PBS 脚本中可以用一种特殊形式的注释（#PBS）作为 PBS 指令以设定作业属性。下面是一个 PBS 脚本示例：

```
#!/bin/bash

# file: example.pbs

### set job name
#PBS -N example-job
### set output files
#PBS -o example.stdout
#PBS -e example.stderr
### set queue name
#PBS -q example-queue
### set number of nodes
#PBS -l nodes=2:ppn=4

# enter job's working directory
cd $PBS_O_WORKDIR

# get the number of processors
NP=`cat $PBS_NODEFILE | wc -l`

# run an example mpi4py job
mpirun -np $NP -machinefile $PBS_NODEFILE python example_mpi4py.py
```

用以下命令提交该作业：`qsub example.pbs`


#### 取消或停止作业
要取消或停止一个作业，需要得到该作业的作业标识号 <job ID >，可以通过 qstat 命令获得。

#### 取消排队等待的作业
取消一个正在排队等待的作业，可用以下命令：`qdel <job ID >`

#### 停止正在运行的作业
要停止一个正在运行的作业，可用向其发送 KILL 信号：`qsig -s KILL <job ID>`

#### 交互式作业
交互式的计算作业通过类似于下面的命令使用：`qsub -I [options]`

例如要求 2 台计算节点，运行在 example-queue 队列上的交互式作业，执行如下命令：`qsub -I -l nodes=2 -q example-queue`

执行完以上命令，等 PBS 系统分配好资源后会进入所分配的第一台计算节点，可在其命令终端上执行交互式的计算任务，如要退出交互作业，可在终端输入 exit 命令，或使用按键 `Ctrl+D` 。




