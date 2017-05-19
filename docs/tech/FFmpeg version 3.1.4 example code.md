# FFmpeg version 3.1.4 example code

这段时间学习FFmpeg编解码，由于安装的是当前最新版的库(`3.1.4`)，按着官网给的示例程序学习，却总是发现编译时提示API被弃用的问题，导致学习的热情受到打击。所以就想着在自己改写并使用最新API调用时，尽量也给官网的示例代码更新一下，放在自己的博客上，或者之后有机会的话，推到官网上。

下面所列个表格：

FFmpeg 3.1.4 适配 | 官网提供的示例代码
:---|---:
[avio_reading.c](/assets/ffmpeg-code/example-3.1.4/avio_reading.c)| [avio_reading.c](https://ffmpeg.org/doxygen/trunk/avio_reading_8c-example.html)


编译脚本[build.sh](/assets/ffmpeg-code/example-3.1.4/build.sh)内容如下：

``` 
# !/usr/bin/env bash
# -*- coding: utf-8 -*-

gcc $1 -I/usr/local/inclue -L/usr/local/lib -lavformat -lavutil -lavcodec -lavfilter -lswscale
```

编译示例：

```
./build avio_reading.c
```

生成默认文件名为：`a.out`

编译前要确保安装了FFmpeg开发库，本文撰写时，头文件安装在`/usr/local/include`下，库文件安装在`/usr/local/lib`下。

