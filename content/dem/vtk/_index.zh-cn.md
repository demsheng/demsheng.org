---
date: 2020-10-06
title: 编译vtk，win10+qt5+vtk8
weight: 3
---

参考 https://blog.csdn.net/annjeff/article/details/88597051


1. 编译之前规划  
    在进行编译之前先规划好编译中产生的文件所在的目录，清晰的目录结构是一个很不错的习惯。我的做法同其他博主类似，先为VTK新建一个文件夹，将此目录作为VTK的家目录。在VTK目录之下新建四个目录，它们分别是：VTK-8.2.0-src(将下载的源码解压到此目录下)；VTK-8.2.0-build(VTK在编译时生成编译的二进制文件放在此文件夹中)；VTK-8.2.0-Install-VS2017-x64-Release（生成的lib文件include文件放于其中，此即我们需要的库的Release版本）；VTK-8.2.0-Install-VS2017-x64-Debug（生成的lib文件include文件放于其中，此即我们需要的库的Debug版本）。最后需要声明：VTK官网提供了VTK-8.2.0-Data，这是运行VTK示例所需要的数据，一般不需要，下载下来也无妨，看个人需求吧。  
    
2. 开始Cmake编译VTK库  
    1. 打开安装的cmake-gui，选择VTK源码路径，以及二进制存放路径，此即我们规划的VTK-8.2.0-src与VTK-8.2.0-bin。然后开始Config即可。
    2. 选择Visual Studio 17 2017 Win64（64位版本的VS 2017）编译。选择后点击Finish。
    3. 第一次Config完成以后，此时界面会变成红色。我们需要对一些选项进行配置。这一步我们勾选BUILD_EXAMPLES即编译VTK自带的示例文件。当然这不是必须的，勾选编译示例会增加额外的编译时间。但是，BUILD_SHARED_LIBS一定确保是勾选的，VTK-8.2.0默认是勾选的。此项的作用是生成动态共享库DLL。
    4. 这一步选择是相当重要的，CMAKE_INSTALL_PREFIX是我们VTK库要安装的位置，亦即VTK编译后生成的库文件所在位置，建议将位置修改为我们规划的VTK-8.2.0-Install-VS2017-x64-Debug文件夹。虽然图中是Release，但是我还是建议选择Debug文件夹，因为我的思路是先生成Release版本的VTK库，生成后，将所有文件全部剪切到VTK-8.2.0-Install-VS2017-x64-Release文件夹下。接下来再次生成Debug版本，就会在Debug文件夹里了。之所以这么做，还是因为我们选择CMAKE_INSTALL_PREFIX路径后不可以改变。
    5. 因为我们要使用Qt所以此处要勾选VTK_Group_Qt。
    6. 使用第三方的经验告诉我们，Debug版本的库后面一般带d表示是Debug版本。例如：opencv_world400.lib是Release版本的库，opencv_world400d.lib是Debug版本的库。因此，为了区分版本，我们在CMAKE_DEBUG_POSTFIX后面添加d这样进行Debug版本编译时会在库文件名后面多个d。
    7. 如果你下载了VTK-8.2.0-Data，在VTK_DATA_STORE中可以选择VTK-8.2.0-Data所在的路径。这一步为非必要步骤。执行完以上步骤以后再次点击Config。
    8. 你会发现这里还是有一片红色区域，这里是让我们选择Qt5的位置，基本是Qt_DIR/5.12.0/msvc2017_64/lib/cmake/Qt*,按左侧的名字勾选即可。
    9. 确定VTK_QT_VERSION是5版本。然后再次点击Config。
    10. Configuring done后，此时是白色区域，代表没有错误。如果你的界面依旧有红色，返回检查以上哪步没有勾选，一直Config到白色界面位置。此时可以点击Generate。
    11. Generate done后，同样是白色区域，代表没有错误。到这里CMAKE的阶段就已经完成了。

3. 开始VS编译安装VTK
    1. Cmake阶段完成以后，找到我们规划的VTK-8.2.0-bin文件夹，找到VTK.sln。打开Visual Studio2017，如果你安装了VAssitX插件（小番茄）建议您暂时关闭该插件，因为会降低速度。此时打开VTK.sln项目，因为项目非常大，文件非常多，所以打开的速度会比较慢。
    2. 当你发现VS左下角显示就绪时，此时项目已经加载完毕。
    3. 此时选择【生成】-->【批生成】。
    4. 在ALL_BUILD  Release x64 栏 勾选 √---->点击【生成】。还记得刚刚让你准备的瓜子、花生、电影么，现在派上用场了^ _ ^，因为这一步会执行很长的时间。看电脑配置，一般电脑大约在半小时左右。
    5. 有木有很开心，终于生成完了。
    6. 接下来，把刚刚勾选的ALL_BUILD Release后面的√去掉，下拉，在INSTALL Release后面勾选。这一步就是在安装VTK的Release版本。其本质就是生成Release版本的库文件。放心好了，这一步很快的。
    7. 当你看到这一步的时候，你已经成功的生成了VTK-8.2.0的Release版本的库文件。到哪里去找呢？生成的Release版库文件在我们规划的VTK-8.2.0-Install-VS2017-x64-Debug里面（因为我们Camke时选择的这个文件夹），这时我们需要把文件剪切到VTK-8.2.0-Install-VS2017-x64-Release文件夹里，到这里Release版本生成成功。
    8. 这便是VTK的库文件  
    
        ```
        bin
        include
        lib
        share
        ```
    9. 你会发现Release版本的后面没有d。我们以后使用VTK进行开发，用的就是这些库文件。
    10. 如果你需要Debug版本的VTK库，此时需要在【生成】-->【批生成】里，把刚刚勾选的INSTALL Release后面的√取消。然后可以直接一起勾选ALL_BUILD DEBUG x64 与 INSTALL Debug,生成结束以后，会在VTK-8.2.0-Install-VS2017-x64-Debug文件夹里生成库文件。此时编译阶段完成。
    11. 生成的Debug版本的库后面带d，以区分Release版本。
    
4. 安装VTK后续配置  
VTK的Release版本与Debug版本的库都已经生成完毕了，此时我们该考虑如何在Qt Creator中使用生成的VTK库。如何在Qt Creator 中使用VTK库，我会在下面一篇文章中详细介绍，这里我们先做一些准备。
    1. 将VTK Release版本中的QVTKWidgetPlugin放于Qt 的 Designer里
Qt作为图形显示软件，其强大之处在于可以直接绘制UI界面，而VTK是Qt 的好基友，因此为其专门生成来的可用于Qt 的Designer界面绘制的插件。方法也很简单，将Release 版本下 D:\VTK\VTK-8.2.0\VTK-8.2.0-Install-VS2017-x64-Release\plugins\designer\QVTKWidgetPlugin.dll复制到 Qt Creator的D:\Qt\5.12.0\msvc2017_64\plugins\designer\文件夹下，此时单独打开Qt Designer（msvc2017_64版）会发现已经集成了QVTK。可以通过拖动的方式绘制。
    2. 将VTK的路径放于系统的Path路径里
【控制面板】-->【系统和安全】--【系统】-->【高级系统设置】-->【环境变量】，新建，固定写VTK_DIR变量值为VTKConfig.cmake所在的路径，这里是方便后面以Cmake的方式构建VTK程序。

5. 结语  
如果你已经坚持看到这里，而且是已经编译成功，恭喜你，后来人。接下来你可以进行VTK的学习，这里我想向你推荐两本书。你在学习VTK，基本可以判定你是本科及以上学历，如果你英文还好，推荐你看《VTKUsersGuide》VTK官网可以下载pdf，如果你英文有些吃力，可以看《VTK图形图像开发进阶》这本书，国内经典书籍，作者也是较早使用VTK的前辈。总之，希望你可以坚持下去，也希望我的博客可以带给你一点帮助。

