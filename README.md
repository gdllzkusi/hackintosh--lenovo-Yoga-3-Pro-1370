# Lenovo Yoga3 Pro **黑苹果安装**

##**一、机型配置如下**  
机型：Lenovo Yoga3 Pro  
CPU：Intel Core M 5Y71  
内存：8G DDR3 1600  
硬盘：三星PM871 256G  
核显：HD5300, 3200x1800  
声卡：Realtek ALC286  
无线网卡：bcm94352hmz  
BIOS：A6CN58WW  

##**二、安装方法**  
1，更新官网最新版bios（A6CN58ww），安装之前修改bios引导页面引导模式改成Legacy Support引导优先级改成UEFI第
2,下载10.13.6的镜像（http://bbs.pcbeta.com /viewthread-1790952-1-1.html）或者10.14.1的镜像（https://blog.daliansky.net/macOS-Mojave-10.14.1-18B75-official-version-with-Clover-4726-original- image.html）  
3，用transmac将镜像刻录到U盘   
4，使用我的安装系统使用的EFI（install-EFI）安装系统   
5，将安装系统使用的EFI（install-EFI）目录下的EFI文件夹，替换U盘EFI分区目录（是删除原来镜像自带的EFI后再放进去），U盘隐藏目录挂载可以使用diskgenius软件   
6，安装完成后，使用安装后使用的EFI（安装后使用的EFI）目录下的EFI引导开机   


##三、备注：
每个版本都有两个引导，一个安装系统使用，一个是安装系统完成后 重建缓存 更换安装后EFI引导  （重建缓存使用kext utility软件，打开后输入密码，等待重建缓存完成后退出，更换安装后EFI引导）  

目前有10.12.6、10.13.6、10.14.1 三个版本系统较为完美     

14.2暂时不能使用（核显dvmt小于64m则驱动显卡时会panic报错，报错位置一般为核显framebuffer，台式机可以通过bios设置解决，笔记本则不一定有该设置选项，一是可以通过复杂的EFI Shell里解决（群里详细版教程里面有，如果有想更新最新系统，使用这个方法），二是clover打patch补丁或者终端里打二进制补丁以及使用Lilu插件 ，目前14.2的补丁还没人制作出来所以暂时不能使用）     


安装完成后触摸板不能使用的方法   
打开访达→左上角选择前往→前往文件夹 进入 /System/Library/Extensions 目录下删除  AppleIntelLpssI2C.kext / AppleIntelLpssI2CController.kext两个文件，重建缓存后重启  