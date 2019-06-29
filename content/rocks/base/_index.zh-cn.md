---
title: 基础
weight: 1
pre: "<b></b>"
---

- `df -hl` 查看磁盘剩余空间  
- `chown  账号名称 文件或目录` 更改文件拥有者 (chown )  
- `chgrp  组名   文件或目录` 改变文件的用户组用命令 chgrp  
- `df -hl` 查看磁盘剩余空间  
- `df -h` 查看每个根路径的分区大小  
- `du -sh [目录名]` 返回该目录的大小  
- `du -sm [文件夹]` 返回该文件夹总M数  
- `du -h [目录名]` 查看指定文件夹下的所有文件大小（包含子文件夹）  
- `gedit ~/.config/user-dirs.dirs` Ubuntu 桌面显示路径修改

- 添加用户
```bash
adduser -g vbox zhangsan #添加用户
passwd zhangsan  # 修改密码
rocks sync users # 同步账户信息，新建用户后必须同步后才生效，如果失败，重启再试
```

- 删除用户
```
userdel -r zhangsan # 删除用户，包括家目录
rocks sync users
```
- 修改用户名
```
usermod  -l  新用户名  -d  /home/新用户名  -m  老用户名
rocks sync users
```


- 权限管理
`ll` 显示的内容如下：
```
-rwxrw-r‐-1 root root 1213 Feb 2 09:39 abc
```

	`chmod` 改变文件或目录的权限
	- `chmod 755 abc` 赋予abc权限rwxr-xr-x
	- `chmod u=rwx，g=rx，o=rx abc` 同上 **u=用户权限，g=组权限，o=不同组其他用户权限**
	- `chmod u-x，g+w abc` 给abc去除用户执行的权限，增加组写的权限
	- `chmod a+r abc` 给所有用户添加读的权限


	- 10个字符确定不同用户能对文件干什么
		- 第一个字符代表文件（-）、目录（d），链接（l）
		- 其余字符每3个一组（rwx），读（r）、写（w）、执行（x）
		- 第一组rwx：文件所有者的权限是读、写和执行
		- 第二组rw-：与文件所有者同一组的用户的权限是读、写但不能执行
		- 第三组r--：不与文件所有者同组的其他用户的权限是读不能写和执行
	- 也可用数字表示为：r=4，w=2，x=1  因此rwx=4+2+1=7
		- 1 表示连接的文件数
		- root 表示用户
		- root表示用户所在的组
		- 1213 表示文件大小（字节）
		- Feb 2 09:39 表示最后修改日期
		- abc 表示文件名


