# 苹果逆向工程

苹果平台上逆向需要关闭系统完整性保护(SIP):

恢复模式(`Command + R`)下命令行键入：

```
csrutil disable; reboot
```

# LLDB相关命令

- `file`指定调试文件路径

- `process launch -e /dev/ttys027 --` 
