# Develop DLNA Using Platinum Library

这几天公司的应用(iOS端)上要加一个`dlna`的功能，就是局域网内设备投屏控制的一个功能，并提供移动端控制。因为三方库Platinum是使用C++写的，所以我被分配去做库的Objective-C封装的工作。第一次接手这种事，对一个非计算机专业的学生来说还是蛮有挑战性的。组长说要先写一个接口设计文档来描述将要封装的接口和调用方式。只能网上查看各种资料喽！

这里是我一顿狂搜、看各种博客后搜集到的有用资料，列表如下：

|链接|描述|
|:---:|:---:|
|[Open Connectivity Foundation (OCF)官网](https://openconnectivity.org)|这里有UPnP相关的文档和各家公司开发的SDK，例如：[Plutinosoft](http://www.plutinosoft.com/platinum)开发的[Platinum库](https://github.com/plutinosoft/Platinum.git)也可以从这里了顺藤摸瓜找到|
|[dlna官网](https://www.dlna.org)|这里有对dlna协议描述的文档下载，可以说要全面的学习dlna，这里的文档是不可或缺的，当然，实际中我们也没有必要学太深，不过知道这个资源，学习时就有底了;-)|
|[一个关于dlan介绍的博客](http://ticktick.blog.51cto.com/823160/1637257)|上面两个网站就是通过阅读这个博客《DLNA&UPnP开发笔记》系列共四篇文章后找到的，值的阅读|  

<br/>
好了，有了以上的几个资源，我们就可以开动了。我工作中使用了Platinum库进行dlna的媒体控制器(`DMC`)开发,所以也没有对dlna有太全面的了解，一切是从对Platinum库所提供的示例程序和项目README文件进行编译库和相关开发学习的。

那么，第一步就是，拉下项目进行编译和运行示例了。

# 编译Platinum库

首先，使用git拉下项目最近一次的提交

```
git clone --depth=1 https://github.com/plutinosoft/Platinum.git
```

因为Platinum的编译需要依赖一个名为`Neptune`的C++跨平台运行环境，当然这个项目里已经有解决方法，不需要我们另外下载或编译`Neptune`库，我们只需要通过`Carthage`工具，将`Neptune`的framework下载到Platinum的项目目录下。具体过程如下：

你要先进行Platinum项目目录下，发现其中有着名为`Cartfile`或`Cartfile.resolved`这样的文件，文件中指明了`Carthage`这个工具软件所要下载的framework名称和版本，其实`carthage`这个工具类似于`CocoaPods`这个工具。不过你的Mac上很可能并没有安装`carthage`，所以你其实可以通过先在Mac上安装[homebrew](http://brew.sh)这个工具，然后使用`homebrew`来安装`carghage`。如下:

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  # 安装homebrew

brew install carthage  # homebrew 安装成功后，安装carthage

cd Platinum/  # 进入Platinum项目目录下

carthage update  # 运行carthage 让其下载 Carthfile文件中指定的framework

```

当以上过程完成后，你会发现在`Platinum/Carthage`这个目录下面，已经存在`Neptune`这个C++跨平台运行环境的分别针对Mac和iOS的framework了，你只要确保以上的命令运行成功，并最终得到Neptune的FrameWork就可以编译Platinum的针对iOS的项目和示例程序了。

使用XCode打开`/Platinum/Build/Targets/universal-apple-macosx/Platinum.xcodeproj`项目文件，然后分别运行各`Target`，就可以生成相关的framework和示例运行程序了。

# 生成同时支持真机和模拟机的framework动态链接库

选择`Platinum-iOS`编译方案(Scheme),在编辑方案(Edit Scheme...)对话框,运行(Run)分类中的信息(Info)选项卡下，选择编译配置(Build Configuration)为`Release`。设置好编译方案后，选择任一模拟器(e.g: iphone SE)编译一次，再选择通用iOS设备(Generic iOS Device)编译一次，这两次编译，分别得到对应于`i386 x86_64`架构的模拟器framework和对应于真机`armv7 arm64`架构的framework，我们把这两个对应于不同架构的framework合并成一个framework就完成了同时满足真机调试和模拟器调试的framework了。

生成的两个针对不同架构的framework所在的目录如下，你也可以通过右键`Show in Finder`的方式找到它们的位置, 这两个目录路径动态变化，不完全与我的一致。

```
#这个目录对应于真机的 armv7 arm64 架构
/Users/JokerAtBaoFeng/Library/Developer/Xcode/DerivedData/Platinum-bawuiqxkhqixgybjjufqgvmduavh/Build/Products/Release-iphoneos 

#这个目录对应于模拟器的 i386 x86_64 架构
/Users/JokerAtBaoFeng/Library/Developer/Xcode/DerivedData/Platinum-bawuiqxkhqixgybjjufqgvmduavh/Build/Products/Release-iphonesimulator
```

你可以分别使用下面的命令来查看framework中的文件支持的架构，如下：

```
lipo -info Release-iphoneos/Platinum.framework/Platinum 
```
输出：

**Architectures in the fat file: Release-iphoneos/Platinum.framework/Platinum are: armv7 arm64**

```
lipo -info Release-iphonesimulator/Platinum.framework/Platinum 
```

输出：

**Architectures in the fat file: Release-iphonesimulator/Platinum.framework/Platinum are: i386 x86_64**

利用下面的命令将两个framework合并, 并替换`Release-iphoneos/Platinum.framework/Platinum`文件，这个文件就是合并之后的文件：

```
lipo -create Release-iphoneos/Platinum.framework/Platinum Release-iphonesimulator/Platinum.framework/Platinum -output Release-iphoneos/Platinum.framework/Platinum
```
这时你就可以使用`Release-iphoneos/Platinum.framework`导入你要用到的项目中去了。哦，对了，由于Platinum.framework运行需要依赖`Neptune.framework`，所以导入自己的项目时，记得把carthage下载的`Neptune.framework`一并导入。

再次查看合并后的framework所支持的架构：

```
lipo -info Release-iphoneos/Platinum.framework/Platinum
```
输出：
**Architectures in the fat file: Release-iphoneos/Platinum.framework/Platinum are: i386 x86_64 armv7 arm64**

可以看到，它已经同时支持`i386 x86_64 armv7 arm64`了。

# Platinum.framework和Neptune.framework的使用

你可以直接把这两个framework文件直接拖入项目中，并在提示时选择`Copy Items if needed`，然后点击finished完成导入。

然后到项目对应Target下的`Build Phases`\|`Link Binary With Libraries`下确保`Platinum`和`Neptune`两个framework都在列表中。

由于iOS新版本支持了动态链接库，而我们上述过程默认生成的也是动态的framework, 所以还需要在Target的`General` \| `Embedded Binaries` 中同样的添加上述的两个framework,以使我们在安装应用的同时，也将对应的动态库拷贝到机器中去，否则会由于机器上缺少对应framework而报错。

在项目中使用framework的头文件，需要使用尖括号`<header.h>`而非双引号`"header.h"`。

这样，你就可以使用自己编译好的framework了。

# 对库的熟悉过程

首先是对三方库的使用，来理解接口调用方式。还好库里提供了几个例子程序，先慢慢看了三天。移植了其中一个关于媒体控制器的示例到项目中，仅仅实现了查找附近设备的功能。但这是个好的开头，对我来说有相当的鼓励作用。开发过程中主要是参照`MicroMediaController`的代码进行的。

我发现对于优质C++库的学习，真是一种赏心悦目的体验，当然看懂C++的细节还是相当痛苦的。

这个Platinum库应该是遵循dlna协议编写的，相关的文档很少，项目属于自注释型的，也就是说，代码中的注释就是文档的大部分，不过要学习这个库，dlan协议还是有必要详细看看的，否则即使通过修改程序，达到了最初设定的功能目标，想要扩展一些功能，却是会边参数都不会传递的，因为这些参数是在协议是规定的。

在接口封闭的过程中，发现参考别人的封闭方法实在能够学习很多，比例我在用Objective-C封C++接口的过程中，就参考了Platinum项目目录下`Platinum/Source/Extras/ObjectiveC/`对`MediaServer`的封装方法。

**未完，待续...**

# \#issue1
在识别小米盒子的时候，总是识别不到，修改了Platinum中的部分代码,并重新编译后导入项目，得以正常识别：

### 修改前
*PltCtrlPoint.cpp* 
```cpp
class PLT_DeviceReadyIterator
{
public:
    PLT_DeviceReadyIterator() {}
    NPT_Result operator()(PLT_DeviceDataReference& device) const {
        NPT_Result res = device->m_Services.ApplyUntil(
            PLT_ServiceReadyIterator(), 
            NPT_UntilResultNotEquals(NPT_SUCCESS));
        if (NPT_FAILED(res)) return res;

        res = device->m_EmbeddedDevices.ApplyUntil(
            PLT_DeviceReadyIterator(),
            NPT_UntilResultNotEquals(NPT_SUCCESS));
        if (NPT_FAILED(res)) return res;
        
        // a device must have at least one service or embedded device 
        // otherwise it's not ready
        if (device->m_Services.GetItemCount() == 0 &&
            device->m_EmbeddedDevices.GetItemCount() == 0) {
            return NPT_FAILURE;
        }
        
        return NPT_SUCCESS;
    }
};
```

### 修改后
*PltCtrlPoint.cpp* 
```cpp
class PLT_DeviceReadyIterator
{
public:
    PLT_DeviceReadyIterator() {}
    NPT_Result operator()(PLT_DeviceDataReference& device) const {
        NPT_Result res = device->m_Services.ApplyUntil(
            PLT_ServiceReadyIterator(), 
            NPT_UntilResultNotEquals(NPT_SUCCESS));
//        if (NPT_FAILED(res)) return res;

        res = device->m_EmbeddedDevices.ApplyUntil(
            PLT_DeviceReadyIterator(),
            NPT_UntilResultNotEquals(NPT_SUCCESS));
//        if (NPT_FAILED(res)) return res;
        
        
        if(NPT_FAILED(res) && NPT_FAILED(res))  return res;

        // a device must have at least one service or embedded device 
        // otherwise it's not ready
        if (device->m_Services.GetItemCount() == 0 &&
            device->m_EmbeddedDevices.GetItemCount() == 0) {
            return NPT_FAILURE;
        }
        
        return NPT_SUCCESS;
    }
};
```

### 修改原因

我发现对于搜索到的小米盒子，代码过不了下面这个函数的第`53`行：

*PltCtrlPoint.cpp*
```cpp
NPT_Result
PLT_CtrlPoint::ProcessGetSCPDResponse(NPT_Result                    res, 
                                      const NPT_HttpRequest&        request,
                                      const NPT_HttpRequestContext& context,
                                      NPT_HttpResponse*             response,
                                      PLT_DeviceDataReference&      device)
{
    NPT_COMPILER_UNUSED(context);

    NPT_AutoLock lock(m_Lock);
    
    PLT_DeviceReadyIterator device_tester;
    NPT_String              scpd;
    PLT_DeviceDataReference root_device;
    PLT_Service*            service;

    NPT_String prefix = NPT_String::Format("PLT_CtrlPoint::ProcessGetSCPDResponse for a service of device \"%s\" 
    @ %s (result = %d, status = %d)", 
    (const char*)device->GetFriendlyName(), 
    (const char*)request.GetUrl().ToString(),
    res,
    response?response->GetStatusCode():0);

    // verify response was ok
    NPT_CHECK_LABEL_FATAL(res, bad_response);
    NPT_CHECK_POINTER_LABEL_FATAL(response, bad_response);

    PLT_LOG_HTTP_RESPONSE(NPT_LOG_LEVEL_FINER, prefix, response);

    // make sure root device hasn't disappeared
    NPT_CHECK_LABEL_WARNING(FindDevice(device->GetUUID(), root_device, true),
                            bad_response);

    res = device->FindServiceBySCPDURL(request.GetUrl().ToRequestString(), service);
    NPT_CHECK_LABEL_SEVERE(res, bad_response);

    // get response body
    res = PLT_HttpHelper::GetBody(*response, scpd);
    NPT_CHECK_LABEL_FATAL(res, bad_response);
    
    // DIAL support
    if (root_device->GetType().Compare("urn:dial-multiscreen-org:device:dial:1") == 0) {
        AddDevice(root_device);
        return NPT_SUCCESS;
    }

    // set the service scpd
    res = service->SetSCPDXML(scpd);
    NPT_CHECK_LABEL_SEVERE(res, bad_response);
    
    // if root device is ready, notify listeners about it and embedded devices
    if (NPT_SUCCEEDED(device_tester(root_device))) {
        AddDevice(root_device);  //第53行
    }
    
    return NPT_SUCCESS;

bad_response:
    NPT_LOG_SEVERE_2("Bad SCPD response for device \"%s\":%s", 
        (const char*)device->GetFriendlyName(),
        (const char*)scpd);

    if (!root_device.IsNull()) RemoveDevice(root_device);
    return res;
}
```

# \#issue2

个人发现小米盒子对于dlan协议实现部分的静音控制命令似乎有些出入，我使用示例程序发送静音命令到小米盒子，发现只能使设备静音，却不能使设备恢复声音，这个问题有待进一步确认。

