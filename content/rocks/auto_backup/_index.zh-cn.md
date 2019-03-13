---
title: 自动备份
weight: 7
pre: "<b></b>"
---

#### 1. 设置计划 `vi /etc/crontab`

```bash
# every 2 min
#*/2 * * * * root /home/zhangsan/backup.sh
# run backup.sh every 30 days
* * */30 * * root /root/backup.sh
```

#### 2. 编写命令脚本 `vi /root/backup.sh`

```bash
#1. 先拷贝数据
cp -r /home/zhangsan /mnt/sda1 #数据存在/home/zhangsan目录下，备份到/mnt/sda1目录下，先将数据拷过来
#2. 打包
tar -zcPvf /mnt/sda1/zhangsan_$(date "+%Y%m%d").tar.gz /mnt/sda1/zhangsan  #将数据所在文件夹zhangsan打包 _%H%M
#3. 删除临时文件内容
rm -rf /mnt/sdc1/zhangsan
#4. 移动
find /mnt/sdc1 -mtime 60 -name "zhangsan_*.tar.gz" -exec mv {} /mnt/zhangsan/canDelIfOverOneYear ;          # 移动该文件夹下超过60天的文件，到canDelIfOverOneYear文件夹
#5. 删除超过一年的文件
find /mnt/sdc1/canDelIfOverOneYear -mtime 365 -name "*.tar.gz" -exec rm -rf {} \;   #删除该文件夹下超过365天的文件 -mtime 365 超过365天 -cmin +1 超过一分钟

```


