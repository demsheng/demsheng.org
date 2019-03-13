---
title: 配置同步
weight: 3
pre: "<b></b>"
---

集群配置信息同步
```bash
rocks sync users # 同步账户信息，新建用户后必须同步后才生效，如果失败，重启再试
rocks sync config #同步集群配置信息，主机每次更改配置后必须使用该命令，否则会出错
```

