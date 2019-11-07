---
title: Git笔记
weight: 4
pre: "<b></b>"
---

李长圣学习Git的笔记。

* [搭建Git服务器 ]({{%relref "init/_index.zh-cn.md" %}})
* [多个git账号的登录与切换]({{%relref "multuser/_index.zh-cn.md" %}})
* [fork后，更新到原作者的主分支]({{%relref "fork/_index.zh-cn.md" %}})
* 设置用户 
	```
	git config --global user.name "geovbox"
	git config --global user.email "geovbox@163.com"
	```
	
* 重命名文件夹/文件 
	```
	git mv -f content/rocks/advance/ content/rocks/share`
	```
	
* 修改 Git 远程仓库地址 `gedit .git/config`
```
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        fetch = +refs/heads/*:refs/remotes/origin/*
        #设置使用哪个远程库
        url = ssh://li_changsheng@ip:1234/home/vpost.git
#       url = https://github.com/demsheng/vpost.git
[branch "master"]
        remote = origin
        merge = refs/heads/master
```

* [修改默认端口号]({{%relref "port/_index.zh-cn.md" %}})
