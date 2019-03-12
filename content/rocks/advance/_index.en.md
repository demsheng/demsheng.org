---
title: 进阶
weight: 1
pre: "<b></b>"
---

记录了 李长圣在南京大学尹宏伟课题组 Rocks 集群管理经验。

#### 添加用户
```bash
adduser -g vbox zhangsan
passwd zhangsan
#同步账户信息，新建用户后必须同步后才生效，如果失败，重启再试
rocks sync users

# 修改家目录
vi /etc/passwd 
vi /etc/auto.master
vi /etc/auto.home

#同步集群配置信息，主机每次更改配置后必须使用该命令，否则会出错
rocks sync config 
#重启
rocks run host command="shutdown -h now"
```

#### 修改用户名
```
usermod  -l  新用户名  -d  /home/新用户名  -m  老用户名
```

#### 自动挂载

修改 `/etc/fstab`
```bash
#2017/11/28 lichangsheng add sdb1 and sdc1
/dev/sdb1 /home/li_changsheng/projects/sdb1_8T ext3 defaults 0 0
/dev/sdc1 /mnt/sdc1_data_backup ext3 defaults 0 0
```

#### nfs让计算节点共享磁盘
修改 `/etc/exports`
```bash
/export 10.10.1.1(rw,async,no_root_squash) 10.10.1.0/255.255.255.0(rw,async)
```

