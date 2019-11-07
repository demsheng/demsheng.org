---
title: 登录进入bash
weight: 12
pre: "<b></b>"
---

- 问题：用户目录消失，登录进入 `bash`
- 原因：`/var` 满，导致 `autofs` 无法运行，`/share` 和 `/home` 无法自动挂载，
- 解决办法： `mv /var/log/messages-20190825 /mnt/sdc1_data_backup/var_log`

