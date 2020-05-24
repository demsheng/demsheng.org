---
title: LSF
weight: 10
pre: "<b></b>"
---

引自　[简书](https://www.jianshu.com/p/601ca9f33b31)

#### 简介
LSF （Load Sharing Facility）是一个被广泛使用的作业管理系统，具有高吞吐、配置灵活的优点。通过 LSF 集中监控和调度，可以充分利用计算机的CPU、内存、磁盘等资源。


常用命令

- bqueues：查看计算队列
- bhosts：查看计算节点列表
- lsload：查看负载
- bsub：提交作业
- bjobs：查看作业状态
- bkill：终止作业
- bpeek：查看作业的标准输出
- bhist：作业历史信息

### 作业提交bsub

#### bsub调用方法
可以通过以下三种方法使用 bsub 来提交作业：

1. 直接在命令行中输入完整参数：
2. 进入 bsub 环境交互提交：
3. 编写作业提交脚本供 bsub 处理。

#### 直接输入完整参数

可以直接在 bsub 的命令行中输入完整的参数来提交一个作业，比如：

```
$ bsub -n 4 -q example-queue -o example.out ./example "-input data.txt"
```

其中所用的参数说明如下：

- -n 指定所需的处理器数目；
- -q 指定作业运行的队列；
- -o 指定作业运行信息的输出文件；
- "-input data.txt" 是传递给执行程序 example 的命令行参数。

这种方式比较适合提交简单的作业，更复杂的作业控制需要编写作业脚本。

#### 使用作业提交脚本

LSF 作业脚本本质上也是一个 shell 脚本，在其中可以用 #BSUB开头的行来指明 bsub作业参数。下面是一个 LSF 作业脚本示例：

```
# example.lsf

#BSUB -L /bin/bash
#BSUB -J example-mpi4py
#BSUB -q example-queue
#BSUB -n 4
#BSUB -o example.out
#BSUB -e example.err

mpirun python example-mpi4py.py
```

其中各参数说明如下：

- -L 指明所用的执行 shell，默认会调用 /bin/sh 执行脚本；
- -J 指定作业名；
- -q 指定作业队列；
- -n 指定作业所需的进程数；
- -o 指定作业的标准输出文件；
- -e 指定作业的错误输出文件。

提交作业脚本，使用下面的命令：

```
$ bsub < example.lsf
```

#### 交互式提交

在终端中输入 bsub 并回车后会进入 bsub 交互环境，在其中可输入作业参数和执行作业程序。在 bsub 交互环境下可以一次提交多个参数相同的作业，例如：

```
$ bsub
bsub> -n 4
bsub> -q example-queue
bsub> -o example.out
bsub> PROG1
bsub> PROG2
bsub> PROG3
bsub> Ctrl+D
```

使用 Ctrl+D 可退出 bsub 交互环境。


#### 查看作业信息

可以用 bjobs 命令查看用户正在运行中的作业：

```
$ bjobs
```

使用 -l参数和某个作业的 JOBID，可以查看该作业的详细信息：

```
$ bjobs -l JOBID
```

#### 中止作业

使用 bkill 命令中止某个作业：

```
$ bkill JOBID
```

以上简要介绍了 LSF 作业管理系统。


