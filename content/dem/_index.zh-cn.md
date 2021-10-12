---
title: 离散元
weight: 3
pre: "<b></b>"
---

记录李长圣在开发离散元软件VBOX时的知识。

* [编译VTK ]({{%relref "vtk/_index.zh-cn.md" %}})
* c++ 
    - 单例模式 https://www.cnblogs.com/CheeseZH/p/5264519.html  
    单件模式（SingletonPattern）：确保一个类只有一个实例，并提供一个全局访问点。和全局变量一样方便，又没有全局变量的缺点，即不需要从一开始就创建对象，而是在需要时才创建它。
    - 局部类 嵌套类 http://www.cppblog.com/mzty/archive/2007/05/24/24766.html
    - 前置声明。c++ 两个头文件互相引用