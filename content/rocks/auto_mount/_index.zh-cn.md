---
title: 自动挂载
weight: 2
pre: "<b></b>"
---



### 自动挂载
在主节点修改 `/etc/fstab`
```bash
#2017/11/28 lichangsheng add sdb1 and sdc1
# home
/dev/sdb1 /state/sdb1_8T ext3 defaults 0 0 
# backup dir
/dev/sdc1 /mnt/sdc1_data_backup ext3 defaults 0 0
```


