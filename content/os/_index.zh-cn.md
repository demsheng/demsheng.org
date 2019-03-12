---
title: 系统安装
weight: 5
pre: "<b></b>"
---


#### win10 ubuntu18 双系统安装， 以 dell G7 为例

1. win10中，分区, 分出5G（FAT32格式）放ubuntu安装文件， 100G用来安装ubuntu   
  `出现问题，尝试用diskgen修改硬盘分区为MBR格式`
2. win10中，将 ubuntu.iso 解压到 5G的盘中
3. easyuefi设置5G盘启动项，/efi/boot/grubx64.efi?  
  `出现问题，关闭win10快速启动。bios中关闭安全启动，修改 STAT为 ACHI?`
4. F12启动，安装ubuntu，新建800M的分区给/boot，100G给/，设置启动项安装到/boot所在分区，/sda5?
        

 
