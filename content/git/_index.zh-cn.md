---
title: git
weight: 4
pre: "<b></b>"
---

李长圣学习Git的笔记。

* [搭建Git服务器 ]({{%relref "init/_index.zh-cn.md" %}})
* [多个git账号的登录与切换]({{%relref "multuser/_index.zh-cn.md" %}})
* [fork后，更新到原作者的主分支]({{%relref "fork/_index.zh-cn.md" %}})
* [修改默认端口号]({{%relref "port/_index.zh-cn.md" %}})
* [彻底删除文件]({{%relref "rm/_index.zh-cn.md" %}})
* [打标签]({{%relref "tags/_index.zh-cn.md" %}})
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
* 放弃本地修改，直接覆盖之
	```
	git fetch --all
	git reset --hard origin/master
	```
* 回退到某个指定的版本
	
	```
	git reset --hard 139dcfaa558e3276b30b6b2e5cbbb9c00bbdca96 
	#后面的是git提交的历史版本号， `git log` 找到复制下来就行
	```
* 一次 `git push` 到多个远程库  
	需要给远程库添加多个url地址，git的一个远程库 可以对应多个地址，即我能让 远程库origin拥有多个url地址。 方法如下：
	- 首先，我们从零开始， 假设你现在想要增加3个远程库地址，分别为 :
		```
		\<url1\> https://git.oschina.net/shede333/swioslibary.git
		\<url2\> https://git.oschina.net/shede333/swscrollbar.git
		\<url3\> https://github.com/shede333/CoreAnimationTestSW.git
		```
	- 首先，先增加第一个地址 git remote add origin <url1>
	- 然后增加第二个地址 git remote set-url --add origin <url2>
	- 增加第三个地址 git remote set-url --add origin <url3>
	- ....依次类推  
	- 这样就完成了添加多个地址到origin库中了， 以后只要使用git push origin master 就可以一次性push到3各库里面了(使用git push也可)
	- 原理解析
	
		git remote set-url --add origin 就是往当前git项目的config文件里增加一行记录
		```
		[remote "origin"]
			url = https://git.nju.edu.cn/demsheng/QtVTKHelloWorld.git
			fetch = +refs/heads/*:refs/remotes/origin/*
			url = https://github.com/demsheng/QtVTKHelloWorld.git
		[branch "main"]
			remote = origin
			merge = refs/heads/main
		```
	- 注意  
	使用git push origin master时，你可以push到origin的多个url地址，
但是使用 git pull时，只能拉取origin里的一个url地址(即fetch-url，如上图)，这个fetch-url默认为 你添加的到origin的第一个地址，
如果你想更改，只需要更改config文件里，那三个url的顺序即可，fetch-url会直接对应排行第一的那个utl连接。

	- https://www.cnblogs.com/hsd1727728211/p/5331651.html