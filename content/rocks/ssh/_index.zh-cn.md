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

## ssh通过代理连接服务器

引自　[ssh通过代理连接服务器](https://www.52os.net/articles/ssh-over-proxies.html)

单位联网只能通过http代理联网，可以采用下面配置连接外网的主机.

编辑ssh客户端配置文件 `/etc/ssh/ssh_config` ,加入：
```
Host yinhw #别名，可以不设置
Hostname 52os.net  #域名或者ip如114.*.*.*
User zhangsan
Port 8080
#IdentityFile 证书路径
#### proxy.beijing.net 8080为http代理
ProxyCommand corkscrew proxy.beijing.net 8080  %h %p 
```
使用下面命令连接即可：
```
ssh yinhw
```

## ssh反向隧道

引自　https://blog.csdn.net/u011539200/article/details/88392446

1. 场景

    A机，在公司内网。B机，在公网，有固定公网IP地址。C机，在家里。
    需要一个功能：在家里，从C机登陆到B机，然后，登陆B机的某个端口，能进入到A机，这样，可以操作A机上的各种资料。


2. 步骤

    首先，在B机上建立一个账号，用于ssh隧道

    ```
    adduser userssh
    ```
    userssh专用于ssh隧道。

    修改 `/etc/ssh/shhd_config` ，把GatewayPorts打开:
    ```
    GatewayPorts yes
    ```
    然后
    ```
    service sshd restart
    ```

    重启启动服务。

3. 在内网的A机执行：
    ```
    ssh -o TCPKeepAlive=yes -o ServerAliveInterval=30 -Nf -R 6000:127.0.0.1:22 userssh@43.110.20.200
    ```
     把A机的22端口，映射到B机6000端口。其中，43.110.20.200是B机的公网IP。

4. 在公网B机执行
    ```
    ssh -p 6000 bri@localhost
    ```
    就可以登陆到A机。

5. 在C机，先登陆到B机，再从B机登陆到A机，即可操作A机的各种资料。


6. 持续连接问题，务必要有一个任何情况下都能生效的重连机制，至少断电重启之后就一定可以连上。比如，需要一个开机启动的服务，这个服务，每隔一分钟，用fabric登录公网主机，然后从公网主机登录内网主机，看看是否能成功，如果成功，表明反向隧道是可用的，如果不成功，反向隧道是不可用的，需要关闭久的，开启新的。

    http://www.cnblogs.com/shengulong/p/7553920.html

    http://www.cnblogs.com/shengulong/p/7553920.html

    https://blog.csdn.net/wangfei8348/article/details/60886006/


    SSH 保持连接 （解决Broken pipe）
    在使用SSH客户端进行连接管理的时候如果长时间不输入命令， 服务器会自动断开连接， 尤其是有的人使用SSH作为代理连接这样的情况更是突出， 因此我在网上搜集了可以让 SSH 保持连接的方法与大家分享

    在服务器端， 可以让服务器发送“心跳”信号测试提醒客户端进行保持连接
    通过修改 sshd 的配置文件，能够让 SSH Server 发送“心跳”信号来维持持续连接，下面是设置的内容

    打开服务器 `/etc/ssh/sshd_config` ，我在最后增加一行
    ```
        ClientAliveInterval 60
        ClientAliveCountMax 1
    ```
    这 样，SSH Server 每 60 秒就会自动发送一个信号给 Client，而等待 Client 回应，（注意：是服务器发心跳信号，不是客户端，这个有别于一些 FTP Client 发送的 KeepAlives 信号哦～～～），如果客户端没有回应，会记录下来直到记录数超过 ClientAliveCountMax 的值时，才会断开连接。

7. 网卡休眠

    网卡休眠造成的，设置关闭：

    修改 `/etc/grub.conf` ，在kernel行末尾追加 `pcie_aspm=off`

8. 启动重连

    加入到启动脚本

9. 主机休眠，

10. 断网后重连


## xshell 设置隧道

A能连B，B能连C．
A想连接C，先建立一条B->C的隧道．


1. A的xshell中设置连接B的ip，端口，可登录到B的用户
    隧道设置如下：
    源主机 127.0.0.3 侦听端口 12345
    目标主机 C的ip 侦听端口 22
2. A的xshell中设置连接127.0.0.3，端口　12345，可登录到C的用户
    这里，在A中登录127.0.0.3时，会自动通过设置的隧道登录到目标主机 C







