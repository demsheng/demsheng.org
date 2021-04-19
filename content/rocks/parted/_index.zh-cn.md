---
title: 格式化8T硬盘
weight: 15
pre: "<b></b>"
---



### 2T以上采用parted

```bash
parted /dev/sdd
p #打印当前盘信息
mklabel gpt #创建gpt格式盘
mkpart #创建分区
sdd1 #指定分区名
ext4 #指定分区类型
0 #分区起始位置
-1 #分区结束位置
p #打印当前盘信息
quit
```
```bash
mkfs.ext4 /dev/sdd1
mount /dev/sdc1  sdc1_data_backup/
```

