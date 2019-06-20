内存：https://juejin.im/post/5abe543bf265da23784064dd

runtime：https://juejin.im/post/5ac0a6116fb9a028de44d717

http&s：https://juejin.im/post/5af557a3f265da0b9265a498

runloop：https://juejin.im/post/5aca2b0a6fb9a028d700e1f8

kvo&kvc：https://juejin.im/post/5aef18b76fb9a07aa34a28e6

多线程：https://juejin.im/post/5ab4a4466fb9a028d14107ff

autorelease:https://juejin.im/post/5a66e28c6fb9a01cbf387da1

内存管理掘金：https://juejin.im/post/5a43a48451882525ab7c0fac

block循环引用：https://juejin.im/post/5a44ddd36fb9a045031065b2

多线程掘金gcd和operation：https://juejin.im/entry/57dcc1cc0bd1d00057e97dc7

gcd掘金：https://juejin.im/post/5a90de68f265da4e9b592b40

operation掘金：https://juejin.im/post/5a90de68f265da4e9b592b40


# MRC和ARC下的属性和getter/setter写法

### MRC

```
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *name;

@end

@implementation ViewController

@synthesize name = _name;

-(void)setName:(NSString *)name {
    if(_name != name){
        [_name release];
        _name = [name retain];
    }
}

-(NSString *)name{
    return _name;
}
@end
```

### ARC

```
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *name;

@end

@implementation ViewController

@synthesize name = _name;

-(void)setName:(NSString *)name {
    _name = name;
}

-(NSString *)name{
    return _name;
}

@end
```

# 属性列表和成员变量


# KVC

<https://www.cnblogs.com/Jusive/p/5084250.html>

KVC本质上是操作方法列表以及在内存中查找实例变量，可以用来访问私用变量
利用反射:NSStringFromSelector(@selector())可以减少KVC字符串写错

# KVO

主要三个方法:
- addObserver
- removeObserver
- observeValueForKeyPath
主要添加和移除，不要重复添加，及时移除

类被第一观察时，会产生一个子类，子类种重写属性的setter方法，并把isa指针指向该子类。重写的setter方法实现通知机制

![kvo theory](/iOS/images/kvo_theory.png)

# Notification

post和转发在同一个线程中进行，与注册观察者所在的线程无关，必要时需要转发到不同线程


# Runtime

Class 被定义为一个指向objc_class的结构体指针，表示一个类的类结构。

Method是Runtime内部定义的方法,Class中定义有一个objc_method_list,链表都是objc_method类型的

SEL标示方法的名字/签名

IMP 是一个函数指针，这个被指向的函数包含一个接收消息的对象id, 调用方法的选标 SEL，以及不定个数的方法参数，并返回一个id。也就是说IMP是消息最终调用的执行代码，是方法真正的实现代码 。我们可以像在Ｃ语言里面一样使用这个函数指针。

+load先于main()被调用, dyld加载镜像时调用所有类的+load方法，+initialize是懒加载的，只有类被使用时才会被调用。

<https://www.jianshu.com/p/eac6ed137e06>


# 内存管理

<http://www.cocoachina.com/ios/20160303/15498.html>

# 深浅拷贝

<http://www.jb51.net/article/89676.htm>


![shallow deep copy](/iOS/images/shallow_deep_copy.png)

- 深拷贝中复制一层
- 完全复制需要使用归档和接档

# OC对象内存布局

<http://blog.csdn.net/xiaolinyeyi/article/details/51393383>

# 消息转发

<https://juejin.im/post/5a55c8956fb9a01c9405bd82>

![msg-send](/iOS/images/review_msg_send.png)

# 类和元类的区别

<https://www.jianshu.com/p/249b705d4fbb>

![class and metaclass](/iOS/images/objc_class_metaclass.png)

# JS与Native交互

- 使用webView:shouldStartLoadWithRequest方法对请求进行拦截并分情况调用NativeCode，需要不断拦截过滤
- 使用JS框架如javascriptcore,比较灵活
- stringByEvaluatingJavaScriptFromString应该在主线程中执行

# 索引的缺点

    1. 需要空间储存索引
    2. 创建和维护索引需要耗费时间
    3. 当删除，插入和更新数据是，索引也需要进行更新，这样降低了写数据的速度。

# NSString 

常量的字符串直接存在常量里，且内容相等的都指向同一块常量区

用另一个字符串生成的NSString与源字符串同地址

用copy是为了安全,防止NSMutableString赋值给NSString时,前者修改引起后者值变化而用的

# GCD

<https://www.jianshu.com/p/77c5051aede2>

<http://www.cocoachina.com/cms/wap.php?action=article&id=22573>
<http://www.cocoachina.com/ios/20160804/17291.html>

# pthread、NSThread、NSOperationQueue

- NSOperationQueue可以往里面添加Operation任务，可以限制最大并发个数

# 信号量

- dispatch_semaphore_create(Init Count)/dispatch_semaphore_wait(-1)/dispatch_semaphore_signal(+1)
- 信号量为0时，线程阻塞直到信号量大于0

# 锁机制

# weak置nil原理

Runtime维护着一个Weak表，用于存储指向某个对象的所有Weak指针

Weak表是Hash表，Key是所指对象的地址，Value是Weak指针地址的数组

在对象被回收的时候，经过层层调用，会最终触发下面的方法将所有Weak指针的值设为nil。* runtime源码，objc-weak.m 的 arr_clear_deallocating 函数

weak指针的使用涉及到Hash表的增删改查，有一定的性能开销.

#事件、响应链、事件传递、事件拦截

- 消息首先会顺着继承结构响应
- 继承结构中没有被响应会进入resolveInstanceMethod方法，从动态添加的方法里响应
- 以上都没有响应使用forwardingTargetForSelector，转交响应目标
- 还不行调用methodSignatureForSelector获得方法签名，调用forwardInvocation

关于生成签名的类型"v@:"解释一下。每一个方法会默认隐藏两个参数，self、_cmd，self代表方法调用者，_cmd代表这个方法的SEL，签名类型就是用来描述这个方法的返回值、参数的，v代表返回值为void，@表示self，:表示_cmd。


# 响应链

<https://www.cnblogs.com/Xylophone/p/7148037.html>

接收到手势点击后，响应UIWindows的hitTest，找到点击发生在具体哪一个子视图上。

```
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
     for (UIView *view in self.subviews) {
          if([view pointInside:point withEvent:event]){
              UIView *hitTestView = [view hitTest:point withEvent:event];
             if(nil == hitTestView){
                  return view;
              }
          }
      }
     return nil;
 }
```

找到点击发生的具体视图时，逆向按下图的顺序逐级寻找处理函数。

![response chain](/iOS/images/response_chain.png)

# 变量类型

###程序内存模型

![memeory_layout](/iOS/images/memory_layout.png)

- 自动变量
- 函数参数
- 静态变量
- 静态全局变量
- 全局变量

block里可以直接修改的是静态变量、静态全局变量和全局变量，默认对自动变量仅捕获其值， 所以不能直接修改，静态变量是以地址被捕获，所以可以修改，静态全局变量是因为在公共区，所以可以被block直接访问

block 有三种，全局block，栈block和堆block，只有堆block会持有对象

# 循环引用问题

<https://www.cnblogs.com/wengzilin/p/4347974.html>

# KVC、KVO与runtime

# 线程安全

### 方式

- **@synchronized(lock) 互斥锁用于线程同步(图方便)**
- NSLock有trylock/lock和unlock这几个操作
- NSRecursiveLock实际上定义的是一个递归锁，这个锁可以被同一线程多次请求，而不会引起死锁。这主要是用在循环或递归操作中。
- NSConditionLock条件锁lock、unlock、lockWhenCondition、unlockWhenCondition
- **dispatch_semaphore就是信号量create\wait\signal(优先选择)**
- NSCondition同时具备互斥锁和信号量的功能lock/unlock/wait/signal
- pthread_mutex是C语言锁接口，不太容易使用
- OSSpinLock

# NSTimer

<https://blog.csdn.net/a2331046/article/details/50240635>

NSTimer不精确，会被线程阻塞影响，主程的RunLoop默认开启，其它线程的runLoop需要手动开启使Timer工作，哪里开启，哪里结束。
循环引用问题

### 相关问题

- timer会retain指定timer回调方法的接收者，也就是target对象，以此保证定时任务能够完成
- 一次性timer在任务执行完成后会自动invalidate,而无限重复性的timer由于一直有效，所以需要手动调用invalidate
- dealloc中调用[timer invalidate]不行，因为timer没有失效前，target对象引用计数不为0， dealloc不会被调动
- timer不是实时的，延迟程序与当前线程的执行情况相关，如果上一次定时任务被延迟，可能会和之后的定时事件合并为一个
- timer要添加到runloop中才会生效，自己alloc和init的timer需要加到runloop里面，同时启动runloop才能生效(还要注意runloop的运行模式是否正确)。所有的source都要加入到runloop中才能使用，timer是一种source

# Runloop机制
 
# 设计模式

## MVC

## MVP

模型和视图完全隔离开，逻辑都放在Presenter里面

## MVVM

ViewModel是輸入輸出的转换,与绑定机制联合威力更大, 兼容MVC，便于测试。OSX+CocoaBinding, iOS + ReactiveCocoa/RxSwift

## VIPER

View/Interactor/Presenter/Entity/Router

易测试、理解、维护，可与CoreData联合使用


# DLNA协议 

- UPnP协议发现网络中的设备(服务、设备(UUID设备标识)、控制点)
    - 自动获取IP
    - 自动公布自己可以提供的服务
    - 自动感知其他设备是否存在并获取它们所能提供的服务
- UPnP DA 设备架构: 规定了如果获取IP、如何发现其它设备、发现后用什么方法了解设备功能、设备间如何发送控制消息和事件。
    - Device
    - Services
    - Controller Point
- UPnP AV 音视频架构:
    - Controller Point
    - Media Server
    - Media Renderer

# 组件化方式

<https://www.jianshu.com/p/59c2d2c4b737>

<https://casatwy.com/modulization_in_action.html>

# category 和 runtime

- category 和 主类中都有+load方法时，会先调用主类的+load后调用category的+load，多个category之间是按照编译顺序调用+load
- category 中不能添加实例变量，只能添中方法
- category 中动态添加关联对象是放在一个全局哈希表中，以关联内存地址为键，对象销毁时会检查自己有没有关联对象，有就除去哈希表中的条目

# 性能优化

- 使用ARC
- View尽量不透明
- 避免在UIImageView中调整图片大小(本地图片)，图络图片背景线程调整大小
- 懒加载
- 缓存数据
- 适当使用autoreleasepool
- 尽量避免时期格式转换，创建`NSDateFormatter`很费时间

## 算法相关

<https://www.zhihu.com/question/24964987>

- topK 问题

## 崩溃率标准

![crash rate](/iOS/images/crash_rate.jpg)

# 线程安全

 - atomic所说的线程安全只是保证了getter和setter存取方法的线程安全，并不能保证整个对象是线程安全的