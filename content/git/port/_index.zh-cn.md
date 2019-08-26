---
date: 2019-08-26
title: 修改默认端口号
weight: 4
---

由于安全或者其它原因，我们可能会修改默认的SSH服务端口号，默认情况下，已有的git项目在pull或者push的时候会报错。现在假设原来的项目的remote设置为git@www.xxx.com:marks/web.git，将服务器SSH默认端口修改为1234后，导致push出错。有三种解决方式：

1. 直接修改URL为SSH://开头

    ```
       git remote set-url origin ssh://git@www.xxx.com:1234/marks/web.git
    ```

2. 修改本地配置文件

    ```
        #映射一个别名
        vi ~/.ssh/confighost xxxhostname www.xxx.comport 1234
    ```

2. 克隆仓库的时候直接指定端口

    ```
        git clone ssh://git@www.xxx.com:1234/marks/web.git
    ```

作者：marksdev  
链接：https://www.jianshu.com/p/b3dcd55ddc9d  
来源：简书  
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
