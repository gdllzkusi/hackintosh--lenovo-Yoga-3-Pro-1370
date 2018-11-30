机型配置如下
•	机型：Lenovo Yoga3 Pro
•	CPU：Intel Core M 5Y71
•	内存：8G DDR3 1600
•	硬盘：三星PM871 256G
•	核显：HD5300, 3200x1800
•	声卡：Realtek ALC286
•	无线网卡：bcm94352hmz
•	BIOS：A6CN58WW
工作情况
•	显卡 HD5300 
•	声卡人ALC286 
•	触摸板/触摸屏I2C
•	wifi+蓝牙 
•	电量显示 
•	睡眠
•	USB内建
•	摄像头
•	HDMI输出 
•	icloud Facetime  iMessage 
•	音量调节
•	亮度调节
不工作
•	SD读卡器
•	触摸板手势功能

安装黑苹果
	更新官网最新版bios（A6CN58ww） ，安装之前修改bios  Boot页面 Boot Mode改成Legacy Support   Boot priority改成UEFI first
	下载10.13.6的镜像（http://bbs.pcbeta.com/viewthread-1790952-1-1.html）或者10.14.1的镜像（https://blog.daliansky.net/macOS-Mojave-10.14.1-18B75-official-version-with-Clover-4726-original-image.html）
	用transmac将镜像刻录到U盘
	使用我的安装系统使用的EFI（install-EFI）安装系统
	将 安装系统使用的EFI（install-EFI）目录下的EFI文件夹，替换U盘EFI分区目录（是删除原来镜像自带的EFI后再放进去），U盘隐藏目录挂载可以使用diskgenius 软件
	安装完成后，使用 安装后使用的EFI（EFI used after installation）目录下的EFI引导开机

10.14.1安装完成后触摸板不能使用的方法
	打开访达→左上角选择前往→前往文件夹 输入，/System/Library/Extensions 里有两个名字以Appleintelpsi2ccontroller开头的两个驱动，选择直接删除它们然后重建缓存，重启即可使用触摸板（10.13.6没有这个步骤）
 
YOGA3 pro 黑苹果 QQ群：778791091 欢迎大家加入



感谢 limurphy 帮忙定制 hotpatch batt 电池补丁
感谢RehabMan 各项帖子教程&驱动
感谢 黑果小兵 帮忙定制ALC286声卡驱动，解决了麦克风问题

感谢远景帮助过我的各位大神，没有你们我就不会做到把这个本子黑的这么完美。
 

