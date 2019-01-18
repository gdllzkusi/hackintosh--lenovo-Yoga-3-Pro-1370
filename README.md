# Lenovo Yoga3 Pro **黑苹果安装**

##一、机型配置如下    
  *  机型：Lenovo Yoga3 Pro  
  *  CPU：Intel Core M 5Y71  
  *  内存：8G DDR3 1600  
  *  硬盘：三星PM871 256G  
  *  核显：HD5300, 3200x1800  
  *  声卡：Realtek ALC286  
  *  无线网卡：bcm94352hmz  
  *  BIOS：A6CN58WW  

##二、工作情况    
  *  显卡HD5300：（亮度调整正常）注入 ig-platform-id 0x16260006  
  *  声卡ALC286：（扬声器、耳机切换，内置麦克风正常）注入ID11
  *  触摸板（syna 2B22触摸板）  
  *  fn热键（+上下键调整亮度、+左右键调整声音）  
  *  休眠唤醒（睡眠一晚上掉电2%很完美）  
  *  usb（2.0/3.0正常识别，并且内建内置usb设备）  
  *  蓝牙+WiFi（原机自带联想版bcm94352z）  
  *  摄像头（免驱）  
  *  HDMI输出（hdmi声音输出尚无测试）   

##三、安装方法    
    *  更新官网最新版bios（A6CN58ww），UEFI MODE 模式改为Legacy Support  
    *  下载镜像使用用transmac将镜像刻录到U盘  
    *  使用我的安装系统使用的EFI（install-EFI）安装系统（无驱动，安装减少报错）   
    *  安装完成后，kext utility 软件重建缓存  
    *  使用安装后使用的EFI（安装后使用的EFI）目录下的EFI引导开机   
    *  详细安装过程请参考 daliansky 写的安装教程
 [联想小新Air 13黑苹果安装教程](https://blog.daliansky.net/Lenovo-Xiaoxin-Air-13-macOS-Mojave-installation-tutorial.html)

##三、备注：     
   *  每个版本都有两个引导，一个安装系统使用，一个是安装系统完成后 重建缓存 更换安装后EFI引导  （重建缓存使用kext utility软件，打开后输入密码，等待重建缓存完成后退出，更换安装后EFI引导）  

   *  目前有10.13.6、10.14.1 版本系统较为完美     

   *  14.2暂时不能使用（核显dvmt小于64m则驱动显卡时会panic报错，报错位置一般为核显framebuffer，台式机可以通过bios设置解决，笔记本则不一定有该设置选项，一是可以通过复杂的EFI Shell里解决（群里详细版教程里面有，如果有想更新最新系统，使用这个方法），二是clover打patch补丁或者终端里打二进制补丁以及使用Lilu插件 ，目前14.2的补丁还没人制作出来所以暂时不能使用）     


####安装完成后触摸板不能使用的方法   
  *  打开访达→左上角选择前往→前往文件夹 进入 /System/Library/Extensions 目录下删除  AppleIntelLpssI2C.kext / AppleIntelLpssI2CController.kext两个文件，重建缓存后重启    

##有问题反馈
  *  在使用中有任何问题，欢迎反馈给我，可以用以下联系方式跟我交流

* 邮件(gdllzkusi@gmail.com)
* QQ: 374593607  

##感激
   * 感谢以下的大神,排名不分先后
   * 感谢daliansky 帮忙定制applealc声卡驱动  
   * 感谢penghubingzhou 帮忙解决syna触摸板无手势功能  
   * 感谢acidanthera、RehabMan、vit9696 等等大神做出来的q以及出了n多教程的大神前辈们，有你们才能让yoga3 pro 这么完美

