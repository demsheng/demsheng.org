---
title: ssh
weight: 8
pre: "<b></b>"
---


## ssh免密码登陆

1. 在A机下生成公钥/私钥对
```
ssh-keygen -t rsa 
```
然后三次回车就可以了。
它在 `/home/lichangsheng` 下生成 `.ssh` 目录，`.ssh` 下有 `id_rsa` 和 `id_rsa.pub`
2. 把A机下的id_rsa.pub复制到B机下，在B机的 `~/.ssh/authorized_keys` 文件里，我用scp复制。（如果B机器没有.ssh和authorized_keys文件则创建这个文件夹和文件先）
```
scp /home/lichangsheng/.ssh/id_rsa.pub  li_changsheng@ip:/home/li_changsheng/.ssh/id_rsa_g3.pub
```
3. B机把从A机复制的 `id_rsa.pub` 添加到 `~/.ssh/authorzied_keys` 文件里。
```
cat ~/.ssh/id_rsa_g3.pub >> ~/.ssh/authorized_keys 
```


## 修改ssh登录端口号

1. 首先修改配置文件 `vim /etc/ssh/sshd_config`
2. 找到 `#Port 22` 一段，这里是标识默认使用22端口，修改为如下：
```
Port 22　　
Port 50000
```
然后保存退出
3. 执行 `/etc/init.d/sshd restart` ，这样SSH端口将同时工作与22和50000上。
　　
　　
　　
