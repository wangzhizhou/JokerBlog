# 苹果逆向工程

苹果平台上逆向需要关闭系统完整性保护(SIP):

重启进入恢复模式(`Command + R`)下命令行键入：

```bash
csrutil disable; reboot
```

`csrutil` - Configure System Rule utility, 也就是配置系统规则的工具, 主要用来配置系统完整性保护规则。

## LLDB相关命令

调试`Finder`

```bash
$ lldb -n Finder
(lldb) process attach --name "Finder"
Process 390 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = signal SIGSTOP
    frame #0: 0x00007fff69b9d25a libsystem_kernel.dylib`mach_msg_trap + 10
libsystem_kernel.dylib`mach_msg_trap:
->  0x7fff69b9d25a <+10>: retq   
    0x7fff69b9d25b <+11>: nop    

libsystem_kernel.dylib`mach_msg_overwrite_trap:
    0x7fff69b9d25c <+0>:  movq   %rcx, %r10
    0x7fff69b9d25f <+3>:  movl   $0x1000020, %eax          ; imm = 0x1000020 
Target 0: (Finder) stopped.

Executable module set to "/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder".
Architecture set to: x86_64h-apple-macosx-.
(lldb) quit
```

指定要调试的文件的路径

```bash
(lldb) file /Applications/Xcode.app/Contents/MacOS/Xcode

或

$ lldb -f /Applications/Xcode.app/Contents/MacOS/Xcode
```

启动要调试并指定标准错误(stderr)输出为`/dev/ttys027`, `e`就是`stderr`

```bash
(lldb) process launch -e /dev/ttys027 --
```

计算switf表达式

```bash
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
(lldb) p/i              //按汇编指令显示
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

## Intel 风格汇编

```
opcode destination source
```

## AT&T 风格汇编

`$`表求常量， `%`表示寄存器引用

```
opcode source destination
```

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

Objective-c环境下才可以访问寄存器，swift下不支持寄存器


使用x86 Intel风格的汇编

```
settings set target.x86-disassembly-flavor intel
```

不省略函数开场

```
settings set target.skip-prologue false
```

以指令形式读取指定位置的一条指令

```
(lldb) memory read -fi -c1 0x100008900
```

读指定位置指令，指定每次读的大小(size)和读多少个(count)大小

```
(lldb) memory read -s1 -c20 -fx 0x10000882c
```


查看寄存器指向的地址的内容

```
(lldb) x/gx $rsp
```

查看系统调用的个数估计

```
$ sudo dtrace -ln 'syscall:::entry' | wc -l
```

查看共享库

```
$ otool -L program
$ otool -l program //显示库加载命令 LC_LOAD_DYLIB对应必要库，LC_LOAD_WEAK_DYLIB对应可选库
```

重新载入`.lldbinit`

```
(lldb) command source ~/.lldbinit
```



### 寄存器

`RDX` 64位、`EDX` 低32位、`DX` 低16位、 `DL` 低8位、 `DH DL`组成`DX`16位

`R8-R15`只在64位机器上，以`R9`为例： `R9` 64位、 `R9D` 低32位、`R9W` 低16位、`R9L`低8位

`RIP` 是指令指针寄存器 64位

`RSP` 栈指针

`RBP`栈基指针，用来存放偏移数据用的参考位置


XCode选项: `Debug/Debug Flow/Always show Disassembly`，总是以汇编的形式调试


### 大端和小端

`x64`和`ARM`体系结构都使用小端，即低地址对应低字节, 两种架构对应的栈都是向下生长的

### 反调试技术

- `ptrace(PT_DENY_ATTACH, 0, nil, 0)`
- `sysctl`

### 动态库和静态库

动态库的好处是，可以被多个程序共用，而不需要第一个程序保留一份，也方便库的升级和更新
动态库是在程序运行时加载的，通过`dyld`，即`dynamic loader`

动态库又分为：必要动态库和可选动态库，必要动态库加载失败会退出程序，可选动态库对程序来说可有可无，不会造成退出


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
- thread step-inst

