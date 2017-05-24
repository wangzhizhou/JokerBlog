# 前提准备

- 熟悉`Markdown`文档书写的

- 熟悉`Git`的基本用法

- 在`GitHub`上创建一个帐号

- 至少看过一次`MkDocs`的使用文档

- 在`Read the Docs`上开通一个帐号

# 环境搭建

本机安装有`python`环境和`pip`包管理器。然后执行下面命令：

```
pip install mkdocs
```

# 写作过程

## 创建默认文档

``` 
mkdocs new demo
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

用浏览器打开<http://127.0.0.1:8000>, 就可以查看文档了。如果在服务开启的情况下修改项目文件，服务会自动检测到更新并重新生成项目，实时获得预览效果。

这样你就可以在`docs`文件夹下面创建其它文件，并修改`mkdocs.yml`配置文件，使新增加的文件在文档目录结构中出现。

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


# 在线托管


# 几个示例

- **[北上见面会](http://bsmeeting.readthedocs.io/zh/latest/)**

- **[Joker手扎](http://km.readthedocs.io/zh/latest/)**



