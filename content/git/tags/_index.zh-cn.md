---
date: 2021-01-01
title: 打标签
weight: 6
---



- `git tag` 列出标签
- `git tag -a v1.4 -m "my version 1.4"` 创建标签
- `git show v1.4` 列出标签信息和与之对应的提交信息
- `git push origin v1.5` 推送标签到共享服务器上
- `git tag -d v1.5` 删除本地标签
- `git push origin --delete v1.5` 删除远程标签

#### 列出标签

- 可带上可选的 -l 选项 --list

    ```
       $ git tag
       v1.0
       v2.0
    ```

- 1.8.5 系列标签
    ```
        $ git tag -l "v1.8.5*"
        v1.8.5
        v1.8.5-rc0
        v1.8.5-rc1
        v1.8.5-rc2
        v1.8.5-rc3
        v1.8.5.1
        v1.8.5.2
        v1.8.5.3
        v1.8.5.4
        v1.8.5.5
    ```

#### 创建标签

- 附注标签（annotated）

    ```
        $ git tag -a v1.4 -m "my version 1.4"
        $ git tag
        v0.1
        v1.3
        v1.4
    ```
    `-m` 选项指定了一条将会存储在标签中的信息。 如果没有为附注标签指定一条信息，Git 会启动编辑器要求你输入信息。

    通过使用 git show 命令可以看到标签信息和与之对应的提交信息：
    
    ```
    $ git show v1.4
    tag v1.4
    Tagger: Ben Straub <ben@straub.cc>
    Date:   Sat May 3 20:19:12 2014 -0700

    my version 1.4

    commit ca82a6dff817ec66f44342007202690a93763949
    Author: Scott Chacon <schacon@gee-mail.com>
    Date:   Mon Mar 17 21:52:11 2008 -0700

        changed the version number
    ```
    
- 轻量标签

    ```
        $ git tag v1.4-lw
        $ git tag
        v0.1
        v1.3
        v1.4
        v1.4-lw
        v1.5
    ```


    这时，如果在标签上运行 git show，你不会看到额外的标签信息。 命令只会显示出提交信息：

    ```
        $ git show v1.4-lw
        commit ca82a6dff817ec66f44342007202690a93763949
        Author: Scott Chacon <schacon@gee-mail.com>
        Date:   Mon Mar 17 21:52:11 2008 -0700

            changed the version number
    ```

#### 共享标签

默认情况下，git push 命令并不会传送标签到远程仓库服务器上。 在创建完标签后你必须显式地推送标签到共享服务器上。 这个过程就像共享远程分支一样——你可以运行 `git push origin <tagname>`。

```
$ git push origin v1.5
Counting objects: 14, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (12/12), done.
Writing objects: 100% (14/14), 2.05 KiB | 0 bytes/s, done.
Total 14 (delta 3), reused 0 (delta 0)
To git@github.com:schacon/simplegit.git
 * [new tag]         v1.5 -> v1.5
```

如果想要一次性推送很多标签，也可以使用带有 --tags 选项的 git push 命令。 这将会把所有不在远程仓库服务器上的标签全部传送到那里。

```
$ git push origin --tags
Counting objects: 1, done.
Writing objects: 100% (1/1), 160 bytes | 0 bytes/s, done.
Total 1 (delta 0), reused 0 (delta 0)
To git@github.com:schacon/simplegit.git
 * [new tag]         v1.4 -> v1.4
 * [new tag]         v1.4-lw -> v1.4-lw
```

现在，当其他人从仓库中克隆或拉取，他们也能得到你的那些标签。

#### 删除标签

要删除掉你本地仓库上的标签，可以使用命令 `git tag -d <tagname>`。 例如，可以使用以下命令删除一个轻量标签：

```
$ git tag -d v1.4-lw
Deleted tag 'v1.4-lw' (was e7d5add)
```

注意上述命令并不会从任何远程仓库中移除这个标签，你必须用 git push <remote> :refs/tags/<tagname> 来更新你的远程仓库：

第一种变体是 `git push <remote> :refs/tags/<tagname> `：

```
$ git push origin :refs/tags/v1.4-lw
To /git@github.com:schacon/simplegit.git
 - [deleted]         v1.4-lw
```

上面这种操作的含义是，将冒号前面的空值推送到远程标签名，从而高效地删除它。

第二种更直观的删除远程标签的方式是：

```
$ git push origin --delete <tagname>
```





链接：https://git-scm.com/book/zh/v2/Git-%E5%9F%BA%E7%A1%80-%E6%89%93%E6%A0%87%E7%AD%BE  

