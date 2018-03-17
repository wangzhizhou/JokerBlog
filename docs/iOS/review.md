
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

# Timer

NSTimer不精确，会被线程阻塞影响，主程的RunLoop默认开启，其它线程的runLoop需要手动开启使Timer工作，哪里开启，哪里结束。
循环引用问题

# 内存管理
<http://www.cocoachina.com/ios/20160303/15498.html>

# 深浅拷贝

copy/mutableCopy/NSCopying/NSMutableCopying 

# OC对象内存布局

<http://blog.csdn.net/xiaolinyeyi/article/details/51393383>

# 运行时和消息转发

<https://www.jianshu.com/p/ea61895be31f>

# JS与Native交互

- 使用webView:shouldStartLoadWithRequest方法对请求进行拦截并分情况调用NativeCode，需要不断拦截过滤
- 使用JS框架如javascriptcore,比较灵活
- stringByEvaluatingJavaScriptFromString应该在主线程中执行

# 索引的缺点

    1. 需要空间储存索引
    2. 创建和维护索引需要耗费时间
    3. 当删除，插入和更新数据是，索引也需要进行更新，这样降低了写数据的速度。

# pthread、NSThread、GCD、NSOperationQueue

# 锁机制

#事件、响应链、事件传递、事件拦截

# KVC、KVO与runtime

# 线程安全

# Runloop机制
 
# 设计模式

## MVC

## MVVM

ViewModel是輸入輸出的转换,与绑定机制联合威力更大, 兼容MVC，便于测试。OSX+CocoaBinding, iOS + ReactiveCocoa/RxSwift

## VIPER

View/Interactor/Presenter/Entity/Router

易测试、理解、维护，可与CoreData联合使用


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
所以，并发时，调用不当，会多次调用[_target release]造成多次释放，进而崩溃。改成atomic属性。

# 知乎