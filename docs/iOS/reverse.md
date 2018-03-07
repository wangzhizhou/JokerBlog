# 苹果逆向工程

苹果平台上逆向需要关闭系统完整性保护(SIP):

恢复模式(`Command + R`)下命令行键入：

```
csrutil disable; reboot
```

# LLDB相关命令

指定要高度的文件的路径

```
(lldb) file /Applications/Xcode.app/Contents/MacOS/Xcode

或

$ lldb -f /Applications/Xcode.app/Contents/MacOS/Xcode
```


启动要调试并指定标准错误(stderr)输出为`/dev/ttys027`

```
(lldb) process launch -e /dev/ttys027 -- 
```

计算switf表达式

```
(lldb) ex -l swift -- import Foundation 
(lldb) ex -l swift -- import AppKit
```

贴上进程

```
$ lldb -n Finder //通过名称
$ lldb -p `pgrep -x Finder` //通过PID
```

下次启动lldb时挂载

```
lldb -n Finder -w
```


格式化打印

```
(lldb) p/x 10           //十六进制显示
(lldb) p/t 10           //二进制显示 
(lldb) p/d 0010         //十进制显示
(lldb) p/c 1430672467   //字符显示
(lldb) p/u -10          //无符号十进制显示
(lldb) p/o              //八进制显示
(lldb) p/a              //按地址显示
(lldb) p/f 1            //按浮点数显示 
(lldb) p/s              //按字符串显示
```

重新运行调试程序 

```
(lldb) run 
```

|调试方式|lldb对应命令|
|:---|:---|
|Step Over | next   |
|Step in   |  step  |
|Step Out  | finish |

查看调用栈信息

```
(lldb)frame info
(lldb)frame variable
```


列出所有模块

```
(lldb)image list
```

 

# LLDB 快键

`Command + K` 清屏

`Ctrl + D` 退出


# LLDB常用命令

- breakpoint
- continue
- script
- po(print object)
- p(print value)
- expression
- image lookup -rvn 
- help 
- apropos
- target
- settings
- thread backtrace
- frame info
- frame select


