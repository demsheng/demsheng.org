---
title: 基础
weight: 1
pre: "<b></b>"
---

`df -hl` 查看磁盘剩余空间  
`chown  账号名称 文件或目录` 更改文件拥有者 (chown )  
`chgrp  组名   文件或目录` 改变文件的用户组用命令 chgrp  


`df -hl` 查看磁盘剩余空间  
`df -h` 查看每个根路径的分区大小  
`du -sh` [目录名] 返回该目录的大小  
`du -sm` [文件夹] 返回该文件夹总M数  
`du -h` [目录名] 查看指定文件夹下的所有文件大小（包含子文件夹）  


#### 添加用户
```bash
adduser -g vbox zhangsan #添加用户
passwd zhangsan  # 修改密码
rocks sync users # 同步账户信息，新建用户后必须同步后才生效，如果失败，重启再试
```

#### 删除用户
```
userdel -r zhangsan # 删除用户，包括家目录
rocks sync users
```
#### 修改用户名
```
usermod  -l  新用户名  -d  /home/新用户名  -m  老用户名
rocks sync users
```
