---
title: rocks 重装
weight: 13
pre: "<b></b>"
---



#### 1. 依赖库重装  
yum install ImageMagick #convert

#### 2. 系统重装  
参考　http://www.rocksclusters.org/assets/usersguides/roll-documentation/base/6.2/install-frontend.html

1. Rocks官网 下载 rocks6.2 系统iso，（软碟通　或者　win7自带刻录，忘记哪个可以了）刻录到光盘

2. 设置光盘启动，安装主节点

3. 主节点运行 `insert-ethers`
4. 计算节点，设置网络启动，即可自动安装计算节点

#### 3. 问题

1. 如果计算节点无法登录:

```
rocks set host sec_attr compute attr=root_pw
rocks sync host sec_attr compute
```

2. 如果 SGE 任务一直未　`wq` 状态，需要重新设置SGE，配置方法见[SGE]({{%relref "/rocks/SGE/_index.zh-cn.md" %}})

