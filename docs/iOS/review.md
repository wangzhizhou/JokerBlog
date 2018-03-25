# 整个招聘流程

<http://www.woshipm.com/zhichang/526302.html>

## 面试前

![before review](/iOS/images/before_review.jpg)

## 面试中

![on review](/iOS/images/on_review.jpg)


# 属性列表和成员变量

# KVC

KVC本质上是操作方法列表以及在内存中查找实例变量，可以用来访问私用变量
利用反射:NSStringFromSelector(@selector())可以减少KVC字符串写错

# KVO

主要三个方法:
- addObserver
- removeObserver
- observeValueForKeyPath
主要添加和移除，不要重复添加，及时移除

类被第一观察时，会产生一个子类，子类种重写属性的setter方法，并把isa指针指向该子类。重写的setter方法实现通知机制

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

# 运行时和消息转发

<https://www.jianshu.com/p/ea61895be31f>

# 类和元类的区别

<https://www.jianshu.com/p/249b705d4fbb>

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

# pthread、NSThread、NSOperationQueue

- NSOperationQueue可以往里面添加Operation任务，可以限制最大并发个数

# 信号量

- dispatch_semaphore_create(Init Count)/dispatch_semaphore_wait(-1)/dispatch_semaphore_signal(+1)
- 信号量为0时，线程阻塞直到信号量大于0

# 锁机制



#事件、响应链、事件传递、事件拦截

- 消息首先会顺着继承结构响应
- 继承结构中没有被响应会进入resolveInstanceMethod方法，从动态添加的方法里响应
- 以上都没有响应使用forwardingTargetForSelector，转交响应目标
- 还不行调用methodSignatureForSelector获得方法签名，调用forwardInvocation

关于生成签名的类型"v@:"解释一下。每一个方法会默认隐藏两个参数，self、_cmd，self代表方法调用者，_cmd代表这个方法的SEL，签名类型就是用来描述这个方法的返回值、参数的，v代表返回值为void，@表示self，:表示_cmd。

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
- 

# 组件化方式

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

# 腾讯面试

准备资料: <http://www.cocoachina.com/bbs/read.php?tid=460991>

- **周六 2018.03.17   17:30 知春路希格玛大厦B1篮球场 叶女士 17801077277   腾讯**

![review tencent](/iOS/images/review_tencent.jpg)

##面试题

问下面这段代码有什么问题？应该怎么修改？

*ViewController.h*

```
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@end
```

*ViewController.m*

```
#import "ViewController.h"

@interface ViewController ()
//will crash if not set to atomic, because the setter will be called in concurrent thread, and member will be release incorrect
@property (nonatomic, strong) NSString *target;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_queue_t queue = dispatch_queue_create("com.joker.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    for(int i = 0; i < 100000; i++)
    {
        dispatch_async(queue, ^{
            self.target = [NSString stringWithFormat:@"A Mock String"];
        });
    }
}
@end
```
所以，并发时，调用不当，会多次调用target属性setter方法中的[_target release]，造成多次释放，进而崩溃。改成atomic属性。

### 总结

- DLNA的协议没有深刻理解
- 播放器去耦合部分介绍有点苍白
- 版本展现统计介绍有点笼统
- 答题时表现的不够沉稳

# 知乎

准备资料：

- **周一 2018.03.19   10:00 海淀区学院路甲 5 号 768 创意园 A 座西区二通道 1002 室   王慧 17611252710   知乎**

![review zhihu](/iOS/images/review_zhihu.jpg)

## 准备资料 - 用递归和非递归逆序单向链表

- 递归

```cpp
node* reverseList(node *head, node** h) {
    if(head->next == NULL){
        *h = head;
        return head;
    }
    node *end = reverseList(head->next, h);
    end->next = head;
    head->next = NULL;
    return head;
}


void reverseList(node **head) {
    node *h = NULL;
    node *subListEnd =  reverseList((*head)->next, &h);
    subListEnd-> next = *head;
    (*head)->next = NULL;
    *head = h;
}
```

- 非递归

```cpp
void reverseNocur(node **head) {
    node *pre = *head;
    node *cur = (*head)->next;
    if(cur == NULL){
      *head = pre;
    } else {
        (*head)->next = NULL;
    }
    
    node *next = cur->next;
    cur->next = pre;
    
    while(next != NULL) {
        pre = cur;
        cur = next;
        next = cur->next;
        cur->next = pre;
    }
    
    *head = cur;
}
```

### 总结

- 问了很多项目的事情，都是顺着项目考查基础知识点，问了组件化，初始化组件应该怎么实现。
- 如何判断多个并发任务全部完成，及实现原理
- swift的Optional原理
- MVC、MVVM、MVP、VIPER
- 怎样测试一个Model


# 阿里文学

- **周二 2018.03.20  10:30 五道口优盛大厦D座16层A 王月琦  15732636310   阿里文学**

![review ali](/iOS/images/review_ali_literature.png)

## 准备资料

写了一个求二叉树最大深度的算法，递归调用

# 今日头条

![review daily](/iOS/images/review_daily.jpg)

## 面试问题

- 全局断点就是异常抛出断点

- 画项目结构图
- 给定一个视图，视图上有若干UIImageView,写一个统计所有UImageView个数的算法(递归写完了再用循环实现)
- 快速排序的原理和时间复杂度
- ARC时，属性delegate用什么关键词修饰(nonatomic,weak)，weak会自动置nil, 及自动置nil的工作原理
- 如果查找内存泄露，instrument工具leaks
- ARC下，如何处理循环引用问题(block 捕获了self的情况)
- block变量捕获的原理是什么？
- [NSArray addObject:nil]会崩溃吗，为什么？
- [nil message]这种调用方式会崩溃吗？为什么？
- 消息调用的原理是怎样的，或者[obj message]这个调用的整个过程是怎样的？
- 信号量机制使用
- 哈希表生成原理
- dispatch_group多个任务同步，每个任务也是异步时怎么处理(开始结束时使用dispatch_group_enter()和dispatch_group_leave()成对，表示一个任务的起止)，group是在线程中
- 有没有看过第三方库,说说原理
- SDWebImageCache同时下载两个相同的URl时会重复下载吗？不会，会在Operations中查找是否已经有相同的下载操作了


# 爱奇艺

![review aqiyi](/iOS/images/review_aqiyi.jpg)

## 过程

- 一个找字符串中第一个只出现过一次的字符(哈希表+两次遍历)
- 一个业务场景，说明实现思路
- 问一些性能优化方面的东西
- 启动时长优化
- 崩溃率合理区间

# 陌陌

![review momo](/iOS/images/review_momo.jpg)

## 面试内容

- dispatch_sync/dispatch_async和同步队列、异步队列的不同组合时，系统分配线程的各种情况
- NSTimer的机制和释放时机，如果被retain会怎样
- dispatch_barrier/dispatch_group的应用方式

# 滴滴





