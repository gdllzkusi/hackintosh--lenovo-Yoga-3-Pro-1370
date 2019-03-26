#### 一、Yoga3 Pro无缘无故降频，温度上来之后卡顿？
    DPTF（Intel® Dynamic Platform and Thermal Framework）的原因导致，DPTF全称为Dynamic Platform and Thermal Framework，英特尔动态平台和热框架，是用来控制触屏和温控使用的，可以在不同的模式下，比如笔记本或者平板，可以进行不同的温控调整，只有部分符合条件的电脑/平板才能安装。说通俗一点就是根据温度高低来调整CPU的工作频率，就是说，当侦测到温度高时，就会去调整CPU工作频率，让机器能够正常的工作，达到平衡运行，确保机器不会因温度过高而不能正常运行。  解决办法为：卸载Dynamic Platform and Thermal Framework 驱动，同时 bios 设置 DPTF  → disable  关闭

#### 二、Yoga3 Pro为什么需要分两个安装引导？  
    因为Yoga3 Pro 屏幕分辨率为3K高分辨率屏幕，原厂默认dvmt pre-allocated 设置为32M，且设置隐藏不可见，核显dvmt小于64m则驱动显卡时会panic报错，报错位置一般为核显framebuffer台式机可以通过bios设置解决，笔记本则不一定有该设置选项。
    1、可以通过复杂的EFI Shell里解决，目前 yoga3 pro 的bios 能使用EFI shell。 命令修改的只有A6CN38WW版本，但是大量用户降级该版本 bios 之后出现卡死情况，所以目前不推荐使用。
    2、clover打patch补丁或者终端里打二进制补丁（Disable minStolenSize less or equal fStolenMemorySize assertion），我们现在采用的方法就是这个。
    3、破解 bios高级菜单，能够显示出隐藏的所有设置选项，通过修改dvmt pre-allocated 为128M。
    
#### 三、双系统启动引导为什么会丢失？  
    1、请关闭 Windows快速启动（右下角电源管理，进入电源和睡眠设置界面，选择电源按钮的功能，电源选项下的系统设置界面，点击更改当前不可用的设置，使能关机设置的选项）
    2、电脑开机或者重启时请不要插任何USB储存设备（U盘，移动硬盘，SD卡） 
    
#### 四、如何操作写U盘EFI分区/硬盘的EFI分区?
    1、如果你的Yoga3 Pro/Yoga3 11 系统是 Windows8.1，那么在我的电脑里面直接可以访问U盘的EFI分区（200Mz左右的一个磁盘），直接删除里面的EFI分区，然后复制我仓库下载的安装EFI引导（根目录必须是EFI文件夹，原理可以百度UEFI启动方式）
    2、如果你电脑是 Windows10 系统，请使用 diskgenius 软件，把U盘下面的EFI分区（有时会显示为ESP分区），该分区默认为隐藏，且没有分配盘符，你需要把它显示分区，分配一个盘符，这样在打开我的电脑里面就会显示出来EFI分区，操作完成之后请用 diskgenius删除盘符，隐藏分区。
    3、Mac下挂载EFI分区非常简单，利用Clover Configurator软件。下载最新版Clover Configurator，打开，左边列表点击 Mount EFI，找到所要挂载的硬盘EFI分区，点击 Mount Patition输入电脑密码，然后点击Open Partition，即可打开EFI分区。

