---
title: 共享主节点磁盘
weight: 6
pre: "<b></b>"
---



1. 主节点，设置自动挂载，磁盘 `/dev/sdb1`  
在主节点修改 `/etc/fstab`
```bash
#2017/11/28 lichangsheng add sdb1 and sdc1
# home
/dev/sdb1 /state/sdb1_8T ext3 defaults 0 0 
```

2. 主节点，设置nfs，让计算节点共享目录 `/state/sdb1_8T`  
在主节点修改 `/etc/exports`
```bash
# all nodes share home
/state/sdb1_8T 10.10.1.1(rw,async,no_root_squash) 10.10.1.0/255.255.255.0(rw,async)
```

3. 主节点，修改家目录挂载点  
`vi /etc/passwd` # 这里的家目录永远不改 `/home/zhangsan`  
`vi /etc/auto.home` # 在这里修改家目录挂载点
```
#zhangsan   -nfsvers=3      sandbox.local:/export/home/zhangsan       # 原来
zhangsan    -nfsvers=3      sandbox.local:/state/sdb1_8T/home/zhangsan # 修改后
```

4. 集群配置信息同步，重启
```bash
rocks sync users # 同步账户信息，新建用户后必须同步后才生效，如果失败，重启再试
rocks sync config #同步集群配置信息，主机每次更改配置后必须使用该命令，否则会出错
rocks run host command="shutdown -h now" #重启
```

