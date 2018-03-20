
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


# pthread、NSThread、GCD、NSOperationQueue

# 锁机制

#事件、响应链、事件传递、事件拦截

- 消息首先会顺着继承结构响应
- 继承结构中没有被响应会进入resolveInstanceMethod方法，从动态添加的方法里响应
- 以上都没有响应使用forwardingTargetForSelector，转交响应目标
- 还不行调用methodSignatureForSelector获得方法签名，调用forwardInvocation

关于生成签名的类型"v@:"解释一下。每一个方法会默认隐藏两个参数，self、_cmd，self代表方法调用者，_cmd代表这个方法的SEL，签名类型就是用来描述这个方法的返回值、参数的，v代表返回值为void，@表示self，:表示_cmd。

# KVC、KVO与runtime

# 线程安全

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

![review ali]()

## 准备资料

