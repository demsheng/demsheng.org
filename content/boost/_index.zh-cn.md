---
title: boost
weight: 5
pre: "<b></b>"
---

李长圣学习boost的笔记。

## [boost的link 和 runtime-link，搭配shared 和 static](https://blog.csdn.net/zhuhongshu/article/details/41412151)

转自：http://blog.csdn.net/yasi_xi/article/details/8660549

link：生成动态链接库/静态链接库。生成动态链接库需使用shared方式，生成静态链接库需使用 static方式。

runtime-link：动态/静态链接C/C++运行时库。同样有shared和static两种方 式，这样runtime-link和link一共可以产生4种组合方式。虽然它和link属性没有直接关系，但我们习惯上，一个工程如果用动态链接那么所有库都用动态链接，如果用静态链接那么所有库都用静态链接。所以这样其实只需要编译2种组合即可，即link=shared runtime-link=shared和link=static runtime-link=static。


还有人总结windows下boost库的命名特点：

link=static runtime-link=static 得到 libboostxxxxx.lib 
link=shared runtime-link=shared 得到 boostxxxx.lib 和 boostxxxx.dll 
由以上的文件夹层次结构基本就可以得出结论： 
１、以“lib”开头的是“link-static”版本的，而直接以“boost”开头的是“link-shared”版本的。 
２、有“d”的为debug版本，没有的则是release版本。 
３、有“s”的为“runtime-link-static”版本，没有的则是“runtime-link-shared”版本。 
４、有“mt”的为“threading-multi”版本，没有的则是“threading-single”版本。


一位在微软做过编译器开发的大牛是这样解释的：

假设一个库A依赖于库B，我们自己的程序client依赖于库A，即：

1363048971_5435 
那么，link指的是client->A，runtime-link指的是A -> B


配置                |  链接过程                                        |  运行时需要的文件 
---------------------------------|----------------------------------------------------------------------------|--------- 
link=static  runtime-link=static |  client通过A.a (A.lib)静态包含A；A通过B.a (B.lib)静态包含B；不关 .so .dll的事| client 
link=static  runtime-link=shared |  client通过A.a (A.lib)静态包含A；在运行时，client要动态调用B.so (B.dll)      | client B.so (B.dll) 
link=shared  runtime-link=shared |  client会包含A.a (A.lib)；A会包含 B.a (B.lib)；但都只保存动态库的真正实现的stub，运行时通过stub去动态加载A.so (A.dll) B.so (B.dll)中的实现|  client A.so (A.dll) B.so (B.dll) 
link=shared  runtime-link=static |  client会包含A.a (A.lib)，但只包含真正实现的stub；A通过B.a (B.lib)静态包含B；运行时，client会动态调用A.so (A.dll) |   client A.so (A.dll) 



