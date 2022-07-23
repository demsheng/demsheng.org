---
title: singularity
weight: 9
pre: "<b></b>"
---

为了在centos等集群上使用yade，采用singularity下载ubuntu的容器，在该容器中安装yade，之后打包成sif可执行文件，该文件可用直接在centos集群中执行,运行方法如下：

```
singularity exec ubuntu2004.simg yade --version
```

### 修改yade官方镜像

```
singularity build yade2020.sif docker:registry.gitlab.com/yade-dev/docker-prod:ubuntu20.04

#运行yade，出现以下错误，运行如下内容修复
#ImportError: libQt5Core.so.5: cannot open shared object file: No such file or directory
singularity build --sandbox yade2020/ yade2020.simg
su
singularity shell --writable ubuntu2004/
#参考下文更新为国内源，加快下载速度
apt-get install libqt5core5a
strip --remove-section=.note.ABI-tag /lib/x86_64-linux-gnu/libQt5Core.so.5
yade --version
exit

singularity build yade2020.simg yade2020/
singularity exec ubuntu2004.simg yade --version
```

### 从ubuntu20.04镜像构建包含yade的ubuntu2004.simg

- 采用系统：`centos 7.0`
- sif 仅可读
- sandbox 可修改，增删软件
	
```
#1. centos 中安装 singularity 
yum install singularity

#2. 从远程下载ubuntu20.04镜像，并构建为sandbox
singularity build --sandbox ubuntu2004/ docker://homebrew/ubuntu20.04

##或者
##2.从远程下载ubuntu20.04镜像，并构建为sif。之后，sif转为sandbox
#singularity build ubuntu2004.sif docker://homebrew/ubuntu20.04	
#singularity build --sandbox ubuntu2004/ ubuntu20yade2018.simg

#sandbox中安装yade
#用root增删软件，sandbox内外都为root
su
#########################################################################
#交互式进入sandbox
singularity shell --writable ubuntu2004/
#更新为国内源，加快下载速度
cp /etc/apt/sources.list /etc/apt/sources.list.backup
apt update
apt install vim
vim /etc/apt/sources.list
#将以下信息写入sources.list
###
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security multiverse
###
#安装yade
apt install yade
#运行yade，出现以下错误，运行如下内容修复
#ImportError: libQt5Core.so.5: cannot open shared object file: No such file or directory
apt-get install libqt5core5a
strip --remove-section=.note.ABI-tag /lib/x86_64-linux-gnu/libQt5Core.so.5
#sandbox内测试
yade --version
#推出sandbox
exit
#########################################################################

#4. sandbox转为simg(sif)，后缀名随便
singularity build ubuntu2004.simg ubuntu2004/
#如果提示找不到tmp，centos中运行如下命名
mkdir /home/lichangsheng/tmp
#转成普通用户
su lichangsheng

#5. sandbox外测试，1）本机测试，2）复制ubuntu2004.simg到centos集群，用如下命令测试
singularity exec ubuntu2004.simg yade --version
```


### 北京并行超算云中使用 `ubuntu2004.simg`
- 直接运行 `srun -n 1 -c 12 singularity exec /path/to/ubuntu20yade2018.simg  yade -j12 /path/to/GeoStructLab/shear/gen.py ./mat.txt`
- 采用 `Slurm` 提交计算 `sbatch job.sh`
```
#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=v6_384
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -t 14400
#SBATCH --output=%j.out
#SBATCH --error=%j.err

source /public1/soft/modules/module.sh
module load singularity/3.5.3-wzm
export GSL=/path/to/GeoStructLab

time srun -n 1 -c 8 singularity exec /path/to/yade2020.simg yade -n -x -j8 /path/to/script.py ./matCohFricCai2016.txt
time srun -n 1 -c 8 singularity exec /path/to/yade2020.simg yade -n -x -j8 /path/to/script.py ./matCohFricCai2016.txt
```

**特别注意：**

- `script.py` 脚本中， 需要设置 `O.run(wait=True)` ，即不进入交互模式，一直等待计算完成。
- `-n` 不启动GUI界面
- `-x` 执行完 `script.py` ，即退出yade




### 进阶：Singularity入门之运行容器
- https://cloud.tencent.com/developer/article/1478616

#### 下载已存在镜像
和Docker类似，要运行 Singularity 也需要先获取镜像，Singularity 可以从Singularity Hub 或者 Docker Hub 来获取已存在的镜像。

```
Singularity Hub
singularity -d build lolcow.simg shub://GodloveD/lolcow

Docker Hub
singularity -d build lolcow.simg docker://godlovedc/lolcow
singularity -d build centos.simg docker://centos
singularity -d build ubuntu.simg docker://ubuntu
```

#### 交互模式运行
```
$ singularity shell ubuntu.simg
Singularity: Invoking an interactive shell within container...

Singularity ubuntu.simg:~> pwd
/home/admin
Singularity ubuntu.simg:~> id
uid=1000(admin) gid=1000(admin) groups=1000(admin),10(wheel)
```

#### 执行一个命令并退出
```
$ singularity exec ubuntu.simg bash -c  "pwd && id"
/home/admin
uid=1000(admin) gid=1000(admin) groups=1000(admin),10(wheel)
```

### 运行一个容器
```
$ singularity run ubuntu.simg
admin@bdmaster:~$ pwd
/home/admin
admin@bdmaster:~$ id
uid=1000(admin) gid=1000(admin) groups=1000(admin),10(wheel)
```

#### 后台运行容器实例

```
启动实例
$ singularity instance.start ubuntu.simg test1
$ singularity instance.start ubuntu.simg test2
```

#### 查看实例
```
$ singularity instance.list
DAEMON NAME      PID      CONTAINER IMAGE
test1            14172    /home/admin/ubuntu.simg
test2            14239    /home/admin/ubuntu.simg
```

#### 操作实例
可以通过 shell, exec, run 命令来连到容器中运行命令

- 使用 shell 命令连入容器
```
$ singularity shell instance://test1
Singularity ubuntu.simg:~> ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
admin      1     0  0 03:14 ?        00:00:00 singularity-instance: admin [test1]
admin      3     0  3 03:14 pts/0    00:00:00 /bin/bash --norc
admin      4     3  0 03:14 pts/0    00:00:00 ps -ef
```
- 使用 exec 执行命令
```
$ singularity exec instance://test1 ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
admin      1     0  0 03:14 ?        00:00:00 singularity-instance: admin [test1]
admin      6     0  0 03:15 pts/0    00:00:00 ps -ef
```

- 停止实例
```
$ singularity instance.stop test1
$ singularity instance.stop test1
```

- 绑定目录
在 Singularity 中也可以在 shell, run, instance.start 等命令中通过 "-B" 选项来实现 Docker 中 “-v” 选项提供挂载卷的功能，比如：
```
$ singularity shell -B /apps:/apps ubuntu.simg
```

### 参考网站
- Singularity入门之运行容器 https://cloud.tencent.com/developer/article/1478616
- Singularity入门之通过沙盒创建镜像 https://cloud.tencent.com/developer/article/1478617
- Singularity构建容器镜像 https://zhuanlan.zhihu.com/p/138806519
- Singularity 快速上手, 带你飞 https://blog.csdn.net/CODE_RabbitV/article/details/120440819
- singularity基本用法 https://blog.csdn.net/HackerTom/article/details/116355126
- Docker镜像转Singularity镜像的全过程 https://blog.csdn.net/weixin_39505820/article/details/122582164
- 容器 https://docs.hpc.sjtu.edu.cn/container/index.html
- 容器引擎 - Singularity 使用说明 https://zhuanlan.zhihu.com/p/448811231
- Singularity实践教程 + Docker 转 Singularity 的避坑指南 https://blog.csdn.net/Tanqy1997/article/details/125304273
- 下载image https://hub.docker.com/
- singularity手册 https://docs.sylabs.io/guides/3.1/user-guide/index.html

