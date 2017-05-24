# 前提准备

- 熟悉`Markdown`文档书写, 这里有份[语法说明](http://www.appinn.com/markdown/basic.html)

- 熟悉`Git`的版本控制的基本用法，这里有个[简明手册](http://www.bootcss.com/p/git-guide/)

- 在`GitHub`上创建一个帐号, 一个很好的[`Git`和`GitHub`学习资源](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)

- 至少看过一次[`MkDocs`的使用文档](http://www.mkdocs.org)

- 在`Read the Docs`上[开通](http://readthedocs.org)一个帐号

# 环境搭建

本机安装有`python`环境和`pip`包管理器。然后执行下面命令：

```
pip install mkdocs
```

# 写作过程

## 创建默认文档

``` 
mkdocs new demo && cd demo
```

输出：

```
INFO    -  Creating project directory: demo 
INFO    -  Writing config file: demo/mkdocs.yml 
INFO    -  Writing initial docs: demo/docs/index.md 
```

默认的文档结构:

```
demo
├── docs             //这个目录下存放markdown编写的文档
│   └── index.md     
└── mkdocs.yml       //项目的配置文件，包括文档目录和主题风格配置
```

本地文档浏览使用下面命令：

```
mkdocs serve
```

输出:

```
INFO    -  Building documentation... 
INFO    -  Cleaning site directory 
[I 170524 09:23:48 server:283] Serving on http://127.0.0.1:8000
```

用浏览器打开<http://127.0.0.1:8000>, 就可以查看文档了。如果在调试服务器开启的情况下修改项目文件，修改会被自动检测到，并重新生成项目，实时预览修改后的效果。

这样就可以在`docs`文件夹下面创建文档文件，并修改`mkdocs.yml`配置文件，使新增加的文件在文档目录结构中出现。

## 本博客目前的结构和配置文件情况

### 配置文件**`mkdocs.yml`**

```
site_name: Joker's Blog          //配置项目名称，也就是文档显示名称

pages:                           //配置页面的显示层级结构
    - 'Profile': 'index.md'      //['显示名称':'页面文件路径']
    - 'Me':                      //多级目录结构：me下面包含多个页面
        - 'me/English Personal Resume.md'  //如果省略配置显示名称则按文件名称显示
        - 'me/My Plan for finding Job.md'
        - 'me/Personal Pre-Work Record.md'
        - 'me/My Financial Planning.md'
        - 'me/How I create this blog.md'
    - 'Tech': 
        - 'tech/Network Simulator 2 Installation Guide for Ubuntu.md'
        - 'tech/Learn STL In 30 Minutes.md'
        - 'tech/Installation of Ubuntu 16.04 On UDisk.md'
        - 'tech/Configure Git Server With Ubuntn and Apache 2.md'
        - 'tech/Add Watermark on Video with OpenCV and FFmpeg.md'
        - 'tech/Develop DLNA Using Platinum Library.md'
        - 'tech/FFmpeg and SDL tutorial 1.md'
        - 'tech/FFmpeg compiled on MacOS.md'
        - 'tech/FFmpeg version 3.1.4 example code.md'
        - 'tech/Fmpeg 2.8.6 example code - transcoding.md'
        - 'tech/Nmap Basics.md'
        - 'tech/Use GDB.md'
        - 'tech/User OpenCV to add watermark on a video.md'
        - 'tech/Wireshark Basics.md'
    - 'life':
        - 'Ali Fu': 'life/alipay-scan-fu-icon.md'

theme: readthedocs   //配置文档使用的模板样式
```

### 目录结构

```
.
├── LICENSE    //遵守的许可证文件
├── README.md  //项目说明
├── docs       //文档页面源文件目录
│   ├── assets //包括一些多媒体资源
│   │   ├── Resume
│   │   ├── excels
│   │   ├── ffmpeg-code
│   │   ├── pdfs
│   │   └── pictures
│   ├── index.md
│   ├── life
│   │   └── alipay-scan-fu-icon.md
│   ├── me
│   │   ├── English\ Personal\ Resume.md
│   │   ├── How\ I\ create\ this\ blog.md
│   │   ├── My\ Financial\ Planning.md
│   │   ├── My\ Plan\ for\ finding\ Job.md
│   │   └── Personal\ Pre-Work\ Record.md
│   └── tech
│       ├── Add\ Watermark\ on\ Video\ with\ OpenCV\ and\ FFmpeg.md
│       ├── Configure\ Git\ Server\ With\ Ubuntn\ and\ Apache\ 2.md
│       ├── Develop\ DLNA\ Using\ Platinum\ Library.md
│       ├── FFmpeg\ and\ SDL\ tutorial\ 1.md
│       ├── FFmpeg\ compiled\ on\ MacOS.md
│       ├── FFmpeg\ version\ 3.1.4\ example\ code.md
│       ├── Fmpeg\ 2.8.6\ example\ code\ -\ transcoding.md
│       ├── Installation\ of\ Ubuntu\ 16.04\ On\ UDisk.md
│       ├── Learn\ STL\ In\ 30\ Minutes.md
│       ├── Network\ Simulator\ 2\ Installation\ Guide\ for\ Ubuntu.md
│       ├── Nmap\ Basics.md
│       ├── Use\ GDB.md
│       ├── User\ OpenCV\ to\ add\ watermark\ on\ a\ video.md
│       └── Wireshark\ Basics.md
└── mkdocs.yml   //文档的配置文件
```

# 调试方法

如果觉得一边用`vim`写文档，一边还得在写完后手动运行一次`mkdocs serve`来开启调试服务器查看效果有些麻烦，这里有方法可以简化这些操作:

## 1. 使用shell后台命令运行

```
mkdocs serve &
```

这样运行，shell不会阻塞，还可以继续进行编辑活动。需要回到前台运行时，使用`fg`命令，`Ctrl+C`就可以结束调试服务器了。

## 2. 使用`screen`工具

如果维护过服务器，那么ssh下一定用过`screen`这个工具，系统默认是不会安装的，需要手动安装:`sudo apt-get install -y screen`

使用`screen`启动调试服务器：

```
screen mkdocs serve
```

之后按下`Ctrl+A+D`就可以使调试服务器不阻塞shell，这样就可以继续编辑文档了。浏览器在每次保存文档后会自动触发一次页面刷新来更新显示内容。

如果要结束调试服务器，使用命令:`screen -r`，并使用`Ctrl+C`来结束。

## 手机页面调试

如果觉得在一个显示器屏幕内来回切换浏览器和编辑器有点麻烦，也可以用手机做为效果预览器，但这需要做一些额外的配置。

如果手机和电脑在同一个局域网内部，可以把电脑作为手机的http代理服务器来访问http服务，并在电脑的`hosts`文件中配置如下的域名解析：

```
127.0.0.1 doc.com
```

在文档调试服务器运行的情况下，手机上访问<http://doc.com:8000>就可以实时预览文档效果，而且每次文档保存后会自动触发手机浏览器页面刷新。

**那么剩下的就是如何配置手机通过电脑来访问Http服务了**

在当前的WiFi连接中配置一下`http代理`，电脑上需要有代理软件安装，例如`Charles`或者`Fiddler`

例如,Mac下使用`Charles`代理软件，手机可设置如下：

![http代理](/assets/pictures/http_proxy.png)

然后手机输入<http://doc.com:8000>浏览到文档效果如下：

![doc](/assets/pictures/blog_home.png)

# 在线托管

本地编辑的差不多了，可以发布到网络上，这就涉及到托管服务。源代码可以通过`GitHub`仓库服务托管，文档自动生成和浏览可以通过`Read The Docs`服务来托管，并且当配置了`GitHub`对`Read The Docs`的`Web Hook`后，`GitHub`仓库的每次提交都会自动触发`Read The Docs`上的文档重新生成,以便保持最新状态，很方便。

前面已经注册了这两个托管服务的帐号。下面动手来发布文档到网络上，让更多的人可以看到。


1. 登录`GitHub`并创建一个托管仓库
![create a repo](/assets/pictures/createRepo.gif)

2. 给仓库添加`Read The Docs`的`WebHook`
![repo add the webhook](/assets/pictures/readthedocswebhook.gif)

3. 登录`Read The Docs`并导入文档项目仓库
![import repo to Red the Docs](/assets/pictures/deployTheDemoBlog.gif)

4. 使用`git`命令初始化文档项目为`git` 仓库, 创建首次提交并上传到`GitHub`的仓库中，触发`Read The Docs`自动构建服务
```
//初始化git仓库并创建首次提交记录
git init && g add * && g c -m 'a demo blog'
```
```
//这里的https://github.com/wangzhizhou/demo.git路径应该是你自己创建的仓库路径
git remote add origin https://github.com/wangzhizhou/demo.git
```
```
//推送到GitHub仓库中
git push -u origin master
```

5. 在线浏览文档

![read the demo blog](/assets/pictures/readthedemoblog.png)

# 我创建的几个文档示例

- **[北上见面会](http://bsmeeting.readthedocs.io/zh/latest/)**

- **[Joker手扎](http://km.readthedocs.io/zh/latest/)**



