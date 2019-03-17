---
date: 2019-02-12
title: 多个git账号的登录与切换
weight: 2
---

Ref [https://blog.csdn.net/qq_36602939/article/details/79794686](https://blog.csdn.net/qq_36602939/article/details/79794686)

1. 新建user1的SSH Key

    生成密钥

    ```
    ssh-keygen -t rsa -C "geovbox@163.com"
    ```

    看见两个文件： `id_rsa` `id_rsa.pub`
    复制密钥 `id_rsa.pub` 到git账号里。

2. 新建user2的SSH Key

    ```
    #新建SSH key：
    $ cd ~/.ssh 
    ssh-keygen -t rsa -C "sheng0619@163.com"  # 新建工作的SSH key
    # 设置名称为id_rsa_demsheng
    Enter file in which to save the key (~/.ssh/id_rsa): id_rsa_demsheng
    ```

    新密钥添加到SSH agent中
    因为默认只读取id_rsa，为了让SSH识别新的私钥，需将其添加到SSH agent中：
    ```
    ssh-add ~/.ssh/id_rsa_demsheng
    ```
    
    如果出现Could not open a connection to your authentication agent的错误，就试着用以下命令：
    
    ```
    ssh-agent bash
    ssh-add ~/.ssh/id_rsa_work
    ```

3. 修改config文件

    在~/.ssh目录下找到config文件，如果没有就创建：
    
    ```
    touch config        # 创建config
    ```
    然后修改如下：
    我的config配置如下：
    ```
    # 该文件用于配置私钥对应的服务器
    # Default github user(first@mail.com)
    Host github.com
    HostName github.com
    User git 
    IdentityFile /home/lichangsheng/.ssh/id_rsa

    # second user(second@mail.com)
    # 建一个github别名，新建的帐号使用这个别名做克隆和更新
    Host demsheng.github.com
    HostName github.com 
    User git 
    IdentityFile /home/lichangsheng/.ssh/id_rsa_demsheng
    ```

    其规则就是：从上至下读取config的内容，在每个Host下寻找对应的私钥。这里将GitHub SSH仓库地址中的git@github.com替换成新建的Host别名如：demsheng.github.com，那么原地址是：git@github.com:demsheng/sheng.git，替换后应该是：demsheng.github.com:funpeng/sheng.git.

4. 打开新生成的~/.ssh/id_rsa_demsheng.pub文件，将里面的内容添加到GitHub后台。


5. 以下命令可以检查当前用户： `ssh -T git@github.com` `ssh -T git@demsheng.github.com`


6. 以下命令可以检查当前秘钥： `ssh-add -l`


