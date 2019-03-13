---
title: 修改家目录
weight: 5
pre: "<b></b>"
---

#### 原理:  
`/etc/passwd` 里的家目录永远不改 `/home/zhangsan`  
`rocks` 中 `/exoprt` 指向 一个磁盘（如 `/state/partition1` ），`home` 在该磁盘中。 采用 `autofs` 自动挂载家目录到 `/home/zhangsan` 。  
#### 操作如下：  

1. 在 `/etc/auto.master` 中设置 `/home` 挂载点。  
    在主节点修改 `vi /etc/auto.master`
    ```
    /home  /etc/auto.home  --timeout=1200
    ```

2. 在 `/etc/auto.home` 中设置主节点 `sandbox.local` 的目录 `/state/sdb1_8T/home/zhangsan` 为 `zhangsan` 的家目录。  
    在主节点修改 `vi /etc/auto.home`
    ```
    # 挂载的目录名               挂载的主节点目录（主节点 和 计算节点公用该目录）
    #zhangsan   -nfsvers=3      sandbox.local:/export/home/zhangsan       # 原来
    zhangsan    -nfsvers=3      sandbox.local:/state/sdb1_8T/home/zhangsan # 修改后
    ```

3. 同步配置到计算节点

    ```bash
    rocks sync users # 同步账户信息，新建用户后必须同步后才生效，如果失败，重启再试
    rocks sync config #同步集群配置信息，主机每次更改配置后必须使用该命令，否则会出错
    rocks run host command="shutdown -h now" #重启
    ```

