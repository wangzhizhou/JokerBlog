# 整个招聘流程

<http://www.woshipm.com/zhichang/526302.html>

## 面试前

![before review](/iOS/images/before_review.jpg)

## 面试中

![on review](/iOS/images/on_review.jpg)

## 面试中技术无关的高频问题

- 离职的原因
- 对自己的未来规划
- 横向对比，自己有哪些优势

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

- **周三 2018.03.21   18:45 北京市海淀区知春路63号中国卫星通信大厦A座7层 张轩悦  18708100119     今日头条**

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

- **周四 2018.03.22  14:00 中关村鼎好大厦A座7层  面试联系人：刘欧云（HRBP），电话：18511988412    爱奇艺**

![review aqiyi](/iOS/images/review_aqiyi.jpg)

## 过程

- 一个找字符串中第一个只出现过一次的字符(哈希表+两次遍历)
- 一个业务场景，说明实现思路
- 问一些性能优化方面的东西
- 启动时长优化
- 崩溃率合理区间

# 陌陌

- **周五 2018.03.23  10:00 北京市朝阳区阜通东大街1号望京soho T2 B座20层  Amy 15210035422 陌陌**

![review momo](/iOS/images/review_momo.jpg)

## 面试内容

- dispatch_sync/dispatch_async和同步队列、异步队列的不同组合时，系统分配线程的各种情况
- NSTimer的机制和释放时机，如果被retain会怎样
- dispatch_barrier/dispatch_group的应用方式

# 滴滴

- **周一 2018.03.26   10:00 北京市海淀区西北旺路文思海辉   沈悦 15094656466    滴滴**

![review didi](/iOS/images/review_didi.jpg)

### 面试经过 

 - KVO怎样保证addObserver和removeObserver成对儿调用(使用方法中的context参数作为标识，防止重复添加和重复移除)<https://blog.csdn.net/klabcxy36897/article/details/51680423>

 - 常用的集合类对象NSArray/NSDictionary/NSSet/NSCountSet/NSOrderSet

![foundation 1](/iOS/images/foundation_1.jpg)

![foundation 2](/iOS/images/foundation_2.jpg)

![foundation 3](/iOS/images/foundation_3.jpg)

![UIKit](/iOS/images/uikit.jpg)

 - KVC使用在什么情况下

 - 如何让一个runloop一直保持运行而不空闲

 - associated对象是个什么情况，strong和weak引用会不会出问题

```
 objc_setAssociatedObject()
 objc_getAssociatedObject()
 objc_removeAssociatedObjects() //释放所有的关联对象
```

 - 实现替换放在+load里还是+initialize中

```
 +(void)initialize(当类第一次被调用的时候就会调用该方法,整个程序运行中只会调用一次)
 +(void)load(当程序启动的时候就会调用该方法,换句话说,只要程序一启动就会调用load方法,整个程序运行中只会调用一次)

1. 在加载阶段，如果类实现了load方法，系统就会调用它，load方法不参与覆写机制
2. 在首次使用某个类之前，系统会向其发送initialize消息，通常应该在里面判断当前要初始化的类，防止子类未覆写initialize的情况下调用两次
3. load与initialize方法都应该实现得精简一些，有助于保持应用程序的响应能力，也能减少引入“依赖环”（interdependency cycle）的几率
4. 无法在编译期设定的全局常量，可以放在initialize方法里初始化
```

 - Notification中post和receive是在同一个现程中发生的

# 蜻蜓FM

- **周二 2018.03.27   15:00  北京市 朝阳区 朝外SOHO，D座，1122室 常夕露  18610363605    蜻蜓FM**

![review qinting](/iOS/images/review_qinting.jpg)

### 过程

- 问了一下项目
- 写一个旋转数组查找算法
- 写quickSort、BFS、DFS, 
- 递归转循环<https://www.cnblogs.com/coderkian/p/3758068.html>

# 新浪微博

- **周三 2018.03.28   14:00 北京市海淀区西北旺东路10号院西区8号楼新浪总部大厦北门 王楚 18813016799 新浪微博**

![review sina](/iOS/images/review_sina.jpg)

### 过程

- 先作笔试题
- NSRunloop保活,给runloop添加一下NSMachPort<AFNetwork>
- TableView优化的方法:缓存高度、异步绘制、按需加载图片
- 如何提前加载图片
- 判断图片类型，图片数据的第一个字节会标识出这个图片的类型
- imageName和imageWithContentOfFile、imageWithData的区别: imageName加载的图片会在内存中缓存，后两者不会缓存
- 海量数据处理，内存大小限制时的总题
- topK问题
- crash收集
![crash collect](/iOS/images/crash_collection.png)
- NSOperation自定义子类<https://www.jianshu.com/p/4b1d77054b35>

# 美团

- **周四 2018.03.29   10:30 北京市朝阳区望京东路6号望京国际研发园FG座  杨喆   15600243362   自带简历  美团**

### 三面问题准备

- topK问题
- 红绿灯路口优化问题
- O(1)时间复杂度删链表节点
- 和最大子数组
- KVO派生子类后，原对象还能判断类型相等吗
- 类簇模式、构建者模式、工厂模式
- 排序算法哪些是稳定的哪些是不稳定的，算法复杂度，稳定排序有什么用
- 整理一下项目中的关键技术点
- <https://blog.csdn.net/u010742414/article/details/78260938>
- NSOperation的main方法调用后Operation会被移除，start方法在调用后，operation需要手动管理其释放


# 百度视频

- **周四 2018.03.29   14:00 海淀区西北旺东路 文思海辉大厦 -百度视频办公区  魏博  13891924500   百度视频**

百度视频给Offer不打算去了

# 探探

- **周五 2018.03.30   14:30 朝阳区光华路SOHO二期D座5-11 (1号线永安里地铁站B出口）cherry 18600536159 探探**

### 过程

- 写一个LRUCache

# 快手

- **周二 2018.04.03   14:00 北京市 海淀区 清华同方科技大厦B座12层   快手**

- 字符串旋转(左/右)

```
#include <iostream>
#include <vector>
#include <cstring>

using namespace std;


string rotateString(string &input, int index) {
    
    reverse(input.begin(),input.begin() + index);
    reverse(input.begin()+index, input.end());
    reverse(input.begin(),input.end());
    
    return input;
}

int main(int argc, const char * argv[]) {
    // insert code here...

    string input = "abcdefg";
    
    cout<<rotateString(input, 2)<<endl;
    
    return 0;
}
```
- 求集合的所有子集，集合本身元素没有重复的，所有元素放在数组中

```

```
- 求两个有序数组的公共元素

# 猿辅导

- 旋转打印矩阵
```c++
class Solution {
    public:
    vector<int> printMatrix(vector<vector<int> > matrix) {
        vector<int> ret = vector<int>();
        int m = min(matrix.size(), matrix[0].size());         
        for(int i = 0; i <= m / 2; i++) {
            help(i,matrix[0].size() - 2 * i, matrix.size() - 2 * i, matrix, ret);
        }
        return ret;
    }

    void help(int index, int w, int h, vector<vector<int> >&m, vector<int> &ret) {

        if(w<=0 || h <=0) return;

        int count = 0;
        while(count < w) {
            ret.push_back(m[index][index + count]);
            count++;
        }

        count = 1;
        while(count < h) {
            ret.push_back(m[index + count][index + w - 1]);
            count++;
        }

        count = w - 1;
        while(h > 1 && count > 0){
            ret.push_back(m[index + h - 1][index + count - 1]);
            count--;
        }

        count = h - 2;
        while(w > 1 && count > 0) {
            ret.push_back(m[index + count][index]);
            count--;
        }
    }
};
```
- 找一个链表的中间结点
    - 思路: 设置两个指针，一个每次走一步，另一个每次走两步，当每次走两步的指针到达尾部时，每次走一步的指针就到达中间结点。

- 一个整型数组，相邻两个元素不能同时取出，求所有子序列和的最大值
- 拆分奇偶数双向链表结点为两个子链表

#百度多模搜索部

- **周一 2018.04.09 14:00 百度科技园1号楼(北京海淀区西北旺百度科技园1号楼) 侯世杰 18600393412**

# 快看漫画

- **周二 2018.08.10 14:30 北京市朝阳区望京融科中心B座703  王燕飞  15010353996**


# 2019年面试过程

## 探探网上笔试，牛客网

找出字符串中第一个不重复字符的下标，找不到返回`-1`。例如："aabbcab", 返回`4`

<https://blog.csdn.net/chuncanl/article/details/57952208>

## 快陪练

![快陪练](/iOS/images/review_kuaipeilian.png)

- **周三 2019.06.19 15:00 北京市朝阳区望京福码大厦B座9层(地铁14号线东段望京站H口出，走550米左右)**

- 介绍最近做了哪些项目，从项目涉及的技术点切入问问题
- atomic关键字的作用是什么？
- assign、weak用来修饰什么样的成员
- weak关键字修饰的成员是如何在所指向对象释放时自动置nil的，说一下原理。
- GCD多线程问题: 有三个任务t1,t2,t3, 要求t1、t2异步并发执行完成后，t3才开始执行，如何实现？有几种方法？如果t1在执行过程中依赖了t2中的某些计算结果，如何处理这种线程依赖关系？使用什么方式？
- 如何检查是否存在内存泄露
- 视图绘制的整个过程，以及异步视图绘制的原理: AsyncDisplayKit
- 编程实现n的阶乘

## 乐信圣文

![乐信圣文](/iOS/images/review_lxsw.png)

- **周五 2019.06.21 10:00 北京市海淀区西小口路66号东升科技园C7号楼202室**

- 类成员定义时会有多个关键词修饰，说一下你知道的关键词和它们所起的作用。atomic/nonatomic/strong/weak/assign/readonly/write/getter/setter/copy
- weak和assign关键字都不会增加成员的引用计数，它们之前有什么区别
- delegate/block/notification这三种通信机制分别适合使用在什么场景
- 介绍一下所做的项目，有没有独立负责过一个项目或者功能模块，画一下项目或者模块结构图。
- 有鸽子、马、飞机、火车四类实体，鸽子和飞机可以飞行，马和火车可以运输货物，鸽子和马都是动物，火车和飞机都是交通工具，使用面向对象的方式设计它们的类结构图
- 工厂模式的作用是什么？
- 应用内存结构：栈区、数据区、文本代码区、堆区
- 觉得和同级别工程师比较，优势体现在哪里？
- 对自己之后的规划是什么？想要如何成长？
- 算法题：写一个阶乘的算法，使用递归。然后说说递归算法会有什么问题。会有栈溢出问题。
- 上机题: 编写一个支持两个整数进行加、减、乘、除运算的计算器，考虑可扩展性。UI只需要一个表达式输入框和一个点击计算按钮，输入表达式后，点击计算按钮显示计算结果，不需要考虑错误处理，只需要实现基本功能，保证可扩展性。

## 字节跳动-F线(房产方向)

![今日头条F线](/iOS/images/review_bytedance_f.jpg)

- **周三 2019.06.26 10:30:00 北京海淀区海淀大街27号中关村天使大厦5层 纪伟芳 15506012902**

- delegate/block/notificatin这三种方式分别在什么场景下使用
- objc调用一个方法的具体过程：objc_msgSend, 继承链方法查找后的三次兜底
- 关联对象原理，如何定义关联对象，以及关联对象在什么时机被释放，怎么释放。
- 使用分类扩展已经有类功能的原理
- https的工作原理
- charles抓包实际操作时过程，如果防止应用被抓包
- git工作流中的常用一些基本指令操作是什么？git rebase的原理、代码回滚怎么操作、功能分支入主分支合并过程中的进行的操作
- 有一个开发任务：下载四张图片，并把四张图片拼成一张大图后进行展示，如何实现？使用GCD多线程并发时，因为并发的任务中下载图片也是一个异步操作，如何处理这块. <https://www.jianshu.com/p/c35fa87905b6>
- 算法题：如何获取链表的倒数第K个结点
- mansory中 make_constrains、update_contrains以及remake_contrains分别怎么使用。
- 衡量一个App的用户体验好坏的指标有哪些？
- 如果要给一个页面做优化，你会从哪些方面着手？
- block的工作原理，加不加__block用什么区别。在函数中声明的block是存储在栈区还是堆区。block类型的成员一般使用copy修饰，为什么要使用copy修饰，使用assign修饰会有什么问题。<https://www.jianshu.com/p/64125b5617a4>
- 算法：一个整数数组内只有一个数字出现了一次，其它数字都出现两次，找到这个只出现一次的数字。
- block在什么情况下会造成循环引用，一般为了避免循环引用，代码怎么处理？
- 分情况说一下面两个函数执行时打印结果：

```
- (void) testGCDASync {
    NSLog(@"A");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"B");
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"C");
}

- (void) testGCDSync {
    NSLog(@"A");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"B");
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"C");
}
```

## 探探

- **周四 2019.06.27 14:00:00 北京市 朝阳区 光华路SOHO二期D座508室（5楼）李玥 15810075436**

- MRC和ARC的区别
- 内存管理的原则是什么? 谁申请谁释放，谁使用谁管理
- 使用alloc/init/new创建的对象和使用类方法创建的对象在内存管理方面有什么不同之处？
- MRC中autorelease会在什么情况下使用？
- 除main函数中的@autoreleasepool外，你觉得还有什么场景可以使用@autoreleasepool这种方式管理内存？
- 什么是自旋锁？使用场景
    - 获取自旋锁的线程在未获得前会一直处于查询状态，因而不会休眠
- 什么是递归锁？使用场景
- 什么是互斥锁？使用场景
- 信号量和互斥锁有什么区别？
    - 信号量不仅可以当作互斥锁来使用，还可以作为资源计数器来使用
- frame和bounds有什么区别
    - frame是相对于父视图坐标系所定义的原点位置和大小
    - bounds是视图内部自己的坐标系
    - setbounds定义视图左上角在本地坐标系的位置
- frame.size和bounds.size一定一样大么？
- gcd串行队列、并发队列、同步分发、异步分发的概念
- @synchronized是否可以嵌套? 内部使用的是recursive_mutex_lock，也就是递归锁, 所以可以嵌套
- 设计题: LRUCache设计实现

# 猿辅导

**周一 2019.07.01 10:30 北京市 朝阳区 望京广顺南大街8号院 利星行中心A座F区6层 姚家言 18610495373**

- ARC是做什么的，与MRC有什么区别
- 如何可以实现全屏蒙层上的按钮正常点击，其它蒙层位置的点击透传到下面的视图上响应
    - 重写hitTest方法中，把需要响应事件的视图作为返回值返回
- 如何给图片做圆角, 有几种方法
    - https://www.jianshu.com/p/82e68984711f
- 在ScrollView中如何使用自动布局。
- 自动布局：两个标签间距为8，并整体水平居中在容器里，当第一个标签的文本过长时，如何做到第一个标签向左延伸，第二个标签不变。
- 如果知道一个实例的私有方法的字符串名称，如果调用这个实例的私用方法。
    - https://blog.csdn.net/nb_token/article/details/81224912
- NSTimer怎样解决循环引用的情况
    - https://www.jianshu.com/p/aaf7b13864d9
- 编程题： 有一个链表存储着整型数字，输入一个整型参数n, 要求把链表调整为左边的都比n小，右边的都比n大。
    - 声明两个列表头，把小于n和不大于n的结束分别连接起来，再把两个表的首尾连接起来。

# 洋钱罐

**周三 2019.07.03 15:00 北京市朝阳区东三环北路19号中青大厦19层 李胜英 13693083396**