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


定义快捷命令

```
command alias -H "Yal Autolayout" -h "quick help text" -- Yay_Autolayout expression -l objc -O -- [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] recursiveDescription]
```

高级快捷命令定义

```
command regex -- tv 's/(.+)/expression -l objc -O -- @import QuartzCore; [%1 setHidden:!(BOOL)[%1 isHidden]]; (void)[CATransaction flush];/'

usage:
    (lldb) tv [[[UIApp keyWindow] rootViewController] view]
```
 
使用脚本桥接


# LLDB 快键

`Command + K` 清屏

`Ctrl + D` 退出

# 汇编相关

两种主流汇编：Intel和AT&T(Apple)
两种主要架构：X86_64(PC)和ARM64(iphone)(uname - m 查看机器硬件名)

iphone 5是最后的32位设备，不支持iOS11
apple watch 前两代是32位设备

##寄存器调用规范

### X86_64

X64架构16个通用寄存器： RAX、RBX、RCX、RDX、RDI、RSI、RSP、RBP、R8~R15
函数前6个参数对应:[RDI,RSI,RDX,RCX,R8,R9],超过的参数放在栈中
rax是存放返回值

列出iPhone X  相关的模拟器

```
$ xcrun simctl list | grep "iPhone X"
```

运行模拟踌躇

```
$ open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/ --args -CurrentDeviceUDID 25A1CE2B-F904-4FE7-A3DE-8EF5A8D49DA7
```

调试模拟器的主页管理器

```
$ lldb -n SpringBoard
```

在断点执行时添加相关的命令

```
breakpoint command add
```

Objective-c环境下才可以访问寄存器，swift下不行



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
- command alias -- 在.lldbinit中定义快捷命令
- command regex
- register read -f d 以10进制格式显示寄存器内容

