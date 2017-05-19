# Installation of Ubuntu 16.04 On UDisk


### 安装Ubuntu 16.04

我是在Mac电脑下工作的，首先需要制作一个U盘安装盘
因为Mac电脑是通过UEFI引导的，所以需要将U盘分区为GUID格式的，当然如果你不是在Mac下工作，就不必分区为GUID了，这样分区只是为了让UEFI可以在引导菜单中显示制作好的U盘安装盘。

在Mac下制U盘安装盘，首先要将下载好的IOS镜像文件转化成为IMG格式，假设我的Ubuntu系统IOS文件名为：*ubuntu-16.04-desktop-i386.iso*, 使用如下命令进行格式转化:

```localhost:Downloads wangzhizhou$  hdiutil convert -format UDRW -o ubuntu-16.04-desktop-i386.img ubuntu-16.04-desktop-i386.iso
```

转化后的文件名为：`ubuntu-16.04-desktop-i386.img.dmg`，这个其实名字没什么关系，重要的是镜像的内容按照Mac可识别的格式得到了转化，之后我们就将转化后的文件写入U盘。

写入U盘前，首先要找到U盘，我们使用`diskutil list`将当前插入电脑的所有磁盘显示出来，找出我们想要写入的那个,我这里显示如下：

```
localhost:Downloads wangzhizhou$ diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *121.3 GB   disk0
   1:                        EFI EFI                     209.7 MB   disk0s1
   2:          Apple_CoreStorage Macintosh HD            120.5 GB   disk0s2
   3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3
/dev/disk1 (internal, virtual):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                  Apple_HFS Macintosh HD           +120.1 GB   disk1
                                 Logical Volume on disk0s2
                                 DA03CC12-7D54-44AA-ADC8-424073352296
                                 Unlocked Encrypted
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *61.9 GB    disk2
   1:                        EFI EFI                     209.7 MB   disk2s1
   2:                  Apple_HFS                         61.6 GB    disk2s2
```

从上面看出，我要写入的U盘是`/dev/disk2`,因为它是外部物理盘，并磁盘大小与我的U盘大小一致，64GB左右。我已经使用磁盘工具把它格式化成GUID分区，所以支持UEFI引导。

我们先用命令把U盘推出，这样也能进行写入操作，因为我们是写入系统镜像，如果不推出就写入的话，不能写到磁盘的最开始部分，也就无法进行引导。我U盘的挂载点为`/Volumes/Ubuntu/`，所以使用如下命令：

```
localhost:Downloads wangzhizhou$ diskutil unmount /Volumes/Ubuntu/
Volume Ubuntu on disk2s2 unmounted
```

既然U盘已从挂载点卸载，我们就可以写入系统镜像文件了，注意是转化后的文件`ubuntu-16.04-desktop-i386.img.dmg`:

```
localhost:Downloads wangzhizhou$ sudo dd if=ubuntu-16.04-desktop-i386.img.dmg of=/dev/rdisk2 bs=1024m
Password:
1+1 records in
1+1 records out
1504051200 bytes transferred in 96.270441 secs (15623188 bytes/sec)
```

注意，我们使用了`/dev/rdisk2`作为写入的目标磁盘，rdisk2对应于disk2，通常使用它能够以更快的速度写入U盘，r代表removeable,即可移动磁盘的意思。

现在我们重启Mac，并在重启过程中按下`option`不放直到启动菜单出现我们的U盘安装盘，如果没有出现，说明没有制作成功，一定是哪个环节没有按步骤来，需要重头来一遍。注意U盘要插在电脑上。

```
localhost:Downloads wangzhizhou$ sudo reboot
```

重启电脑

之后就是正常的安装Ubuntu了，自己去摸索吧～

我靠，开机后居然不能引导，经过不断的百度，有网友称Ubuntu只对64位版本提供UEFI引导模式，呜呼，又得重新来一遍。先下载一个64位版的Ubuntu安装镜像，然后再重新来一次吧。如果使用传统BIOS引导完全不存在这种情况。


**这次文件名为：`ubuntu-16.04-desktop-amd64.iso`,就不一一说明了，直接贴命令行：**

```
localhost:Downloads JokerAtBaoFeng$ diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *251.0 GB   disk0
   1:                        EFI EFI                     209.7 MB   disk0s1
   2:          Apple_CoreStorage Macintosh HD            250.1 GB   disk0s2
   3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3
/dev/disk1 (internal, virtual):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                  Apple_HFS Macintosh HD           +249.8 GB   disk1
                                 Logical Volume on disk0s2
                                 3B2115D8-1852-411F-9052-ABA876FD6128
                                 Unencrypted
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *61.9 GB    disk2
   1:                        EFI EFI                     209.7 MB   disk2s1
   2:                  Apple_HFS Ubuntu16.04_64          61.6 GB    disk2s2
localhost:Downloads JokerAtBaoFeng$ diskutil unmountDisk /dev/disk2
Unmount of all volumes on disk2 was successful
localhost:Downloads JokerAtBaoFeng$ hdiutil convert -format UDRW -o ubuntu-16.04-desktop-amd64 ubuntu-16.04-desktop-amd64.iso
正在读取Driver Descriptor Map（DDM：0）…
正在读取Ubuntu 16.04 LTS amd64          （Apple_ISO：1）…
正在读取Apple（Apple_partition_map：2）…
正在读取Ubuntu 16.04 LTS amd64          （Apple_ISO：3）…
..............................................................................
正在读取EFI（Apple_HFS：4）…
..............................................................................
正在读取Ubuntu 16.04 LTS amd64          （Apple_ISO：5）…
..............................................................................
已耗时： 3.304s
速度：428.8M 字节/秒
节省：0.0%
created: /Users/JokerAtBaoFeng/Downloads/ubuntu-16.04-desktop-amd64.dmg
localhost:Downloads JokerAtBaoFeng$ sudo dd if=ubuntu-16.04-desktop-amd64.dmg of=/dev/rdisk2 bs=1024m
Password:
1+1 records in
1+1 records out
1485881344 bytes transferred in 95.220324 secs (15604666 bytes/sec)
```
系统镜像写入完成后，会弹出一个对话框，选择忽略即可。这次应该可以了，64位Ubuntu支持UEFI启动，并且我们的U盘已经按GUID分区方案分过区，现在重启Mac，并按住`option`不放即可。启动菜单这次会弹出U盘安装盘选项了。

哦这里又出现问题了，按住`option`重启后依然没有引导项，这是因为安装过程中，EFI引导文件被安装到了系统磁盘的EFI分区了，我们需要把那个文件拷到安装系统的U盘上的那个EFI分区。我们进入Mactonish HD，启动OS X，在命令行中把所有磁盘都列出来：

```
localhost:ubuntu wangzhizhou$ diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *121.3 GB   disk0
   1:                        EFI EFI                     209.7 MB   disk0s1
   2:          Apple_CoreStorage Macintosh HD            120.5 GB   disk0s2
   3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3
/dev/disk1 (internal, virtual):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                  Apple_HFS Macintosh HD           +120.1 GB   disk1
                                 Logical Volume on disk0s2
                                 DA03CC12-7D54-44AA-ADC8-424073352296
                                 Unlocked Encrypted
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *62.6 GB    disk2
   1:                        EFI NO NAME                 499.1 MB   disk2s1
   2:        Bios Boot Partition                         127.9 MB   disk2s2
   3:                 Linux Swap                         4.1 GB     disk2s3
   4:           Linux Filesystem                         57.9 GB    disk2s4
   ```
我们将EFI分区：`/dev/disk0s1`和`/dev/disk2s1`都挂载到路径`/Volumes`下，使用下面的命令：

```
localhost:~ wangzhizhou$ diskutil mount /dev/disk0s1;diskutil mount /dev/disk2s1
Volume EFI on /dev/disk0s1 mounted
Volume NO NAME on /dev/disk2s1 mounted
localhost:~ wangzhizhou$ ls /Volumes/
EFI		Macintosh HD	NO NAME
localhost:NO NAME wangzhizhou$ ls /Volumes/EFI/ /Volumes/NO\ NAME/
/Volumes/EFI/:
EFI

/Volumes/NO NAME/:
```
`/Volumes`下`EFI`和`NO NAME`目录就是两个EFI分区的挂载点，你发现`/Volumes/NO NAME/`目录下面什么也没有，这就是为什么U盘系统盘已经安装成功了却没法引导。因为它们错误的安装在了`/dev/disk0s1`下了,也就是挂载点`/Volumes/EFI`下了,我们需要把这些文件复制到`/Volumes/NO NAME/`,下，并作一些调整，用命令行说明吧，文字有点不太清楚了：

```
localhost:NO NAME wangzhizhou$ cp -r /Volumes/EFI/* /Volumes/NO\ NAME/
localhost:EFI wangzhizhou$ cd /Volumes/NO\ NAME/EFI/
localhost:EFI wangzhizhou$ ls
APPLE	ubuntu
localhost:EFI wangzhizhou$ pwd
/Volumes/NO NAME/EFI
localhost:EFI wangzhizhou$ rm -rf APPLE/
localhost:EFI wangzhizhou$ mkdir boot
localhost:EFI wangzhizhou$ cp ubuntu/grubx64.efi boot/bootx64.efi
localhost:EFI wangzhizhou$ cd /Volumes/EFI/EFI/
localhost:EFI wangzhizhou$ ls
APPLE	ubuntu
localhost:EFI wangzhizhou$ rm -rf ubuntu/
localhost:EFI wangzhizhou$ cd /Volumes/
localhost:Volumes wangzhizhou$ diskutil umount EFI;diskutil umount NO\ NAME/
Volume EFI on disk0s1 unmounted
Unmount successful for NO NAME/
```

好了我们的系统U盘上的EFI分区已经有了引导信息，这次按住`option`并重启应该能够引导Ubuntu启动了。

```
localhost:Volumes wangzhizhou$ sudo reboot
```
	


