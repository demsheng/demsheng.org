---
date: 2020-07-26
title: 彻底删除文件 
weight: 6
---

参考: https://www.jianshu.com/p/51559937fe49

*注意：在执行彻底删除之前先备份代码，以防操作失误*

#### 一、用 filter-branch 命令重写所有 commit 才能将文件从 Git 历史中完全移除。

1. 删除文件

    ```
    git filter-branch --index-filter 'git rm --cached --ignore-unmatch test/a.mp3'
    ```

2. 删除目录

    ```
    git filter-branch --index-filter 'git rm -rf --cached --ignore-unmatch test/'
    ```

二、依次执行下面命令

- 

    ```
    rm -rf .git/refs/original/
    git reflog expire --expire=now --all
    git fsck --full --unreachable
    git repack -A -d
    git gc --aggressive --prune=now
    git push --force
    ```



