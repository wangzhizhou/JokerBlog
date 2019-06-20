# 整个招聘流程

<http://www.woshipm.com/zhichang/526302.html>

## 面试前

![before review](/iOS/images/before_review.jpg)

## 面试中

![on review](/iOS/images/on_review.jpg)

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

- **周五 2019.06.21 10:00 北京市海淀区西小口路66号东升科技园C7号楼202室**

## 字节跳动

- **周三 2019.06.26 10:30:00 北京海淀区海淀大街27号中关村天使大厦5层 纪伟芳 15506012902**

