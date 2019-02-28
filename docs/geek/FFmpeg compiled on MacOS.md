# FFmpeg compiled on MacOS

最近好像对音视频编解码来了兴趣，就来学习一波吧。在[FFmpeg官网](https://ffmpeg.org/documentation.html)上找到一篇入门教程[An FFmpeg and SDL Tutorial](http://dranger.com/ffmpeg/)，打算先照着这个学习，完成一个简单的视频播放器，并在学习的过程中，将实践的一些细节整理成博客，顺便培养一下技术情怀;-)

那么首先就要搭建开发环境了，需要编译FFmpeg源码。本文参照FFmpeg[官方Wiki](https://trac.ffmpeg.org/wiki/CompilationGuide)提供的编译文档进行。因为是在Mac上进行，所以参照[针对MacOS的教程](https://trac.ffmpeg.org/wiki/CompilationGuide/MacOSX)的说明使用`Homebrew`进行自动编译安装.

可以使用`brew info ffmpeg`来查看用哪些相关的选项。

可以使用 `sudo chown -R whoami <dir>`来获得一些目录的访问权限

我们使用下面的命令来快速安装:

```
brew install ffmpeg --with-fdk-aac --with-sdl --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265
```
安装后可能提示信息：`Warning: ffmpeg-3.1.4 already installed, it's just not linked`，这说明软件安装了，但还没有为其创建目录链接，所以输入命令，系统可能会搜索不到。

通过运行下面的命令，重建brew对所安装软件的链接：`brew link --overwrite ffmpeg`

安装完成后，使用下面的命令来测试是否成功：

``` 
 ffplay -f lavfi -i testsrc
```

