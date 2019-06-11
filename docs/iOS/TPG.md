# 线程编程指南
```
- (void)launchThread 
{
    NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadMainMethod:) object:nil];
    [myThread setStackSize: 4 * 4 * 1024]; // set thread stack size, must be multiple of 4KB
    [myThread setThreadPriority: 0.5]; // set thread priority,[0.0, 1.0]
    [myThread start];  // Actually create the thread
}

- (void)myThreadMainMethod: 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // Top-level pool
 
    // Do thread work here. 可以是线性执行任务，也可以是事件驱动任务，事件驱动任务使用RunLoop
    
    BOOL moreWorkToDo = YES;
    BOOL exitNow = NO;
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
 
    // Add the exitNow BOOL to the thread dictionary.
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    [threadDict setValue:[NSNumber numberWithBool:exitNow] forKey:@"ThreadShouldExitNow"];
 
    // Install an input source.
    [self myInstallCustomInputSource];
 
    while (moreWorkToDo && !exitNow)
    {
        // Do one chunk of a larger body of work here.
        // Change the value of the moreWorkToDo Boolean when done.
 
        // Run the run loop but timeout immediately if the input source isn't waiting to fire.
        [runLoop runUntilDate:[NSDate date]];
 
        // Check to see if an input source handler changed the exitNow value.
        exitNow = [[threadDict valueForKey:@"ThreadShouldExitNow"] boolValue];
    }

    [pool release];  // Release the objects in the pool.
}
```

## RunLoop探索

RunLoop输入源处理异步事件，定时器源处理同步事件，注册RunLoop通知来获取RunLoop本身的运行状态。

RunLoop模式是一组输入源、定时任务和要通知RunLoop运行状态的注册通知订阅者的集合。每次运行RunLoop前必须指定好这一集合。通过字符串名称来指定RunLoop模式。模式必须对应至少一种输入源或者定时任务。

使用RunLoop的时机是在创建线程时。主线程的RunLoop是自动创建并运行的。二级线程不是非要使用RunLoop，视情况而定。当我们需要使用输入源来和其它线程通信、在线程中使用定时器、执行performSelector方法或者周期性的在线程中执行任务时可以使用RunLoop, 最好不要强制退出线程，因为资源可能没有释放干净会导致内存泄露。

- [RunLoop官方文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html#//apple_ref/doc/uid/10000057i-CH16-SW1)


## 线程同步工具

- 原子操作，不影响计算线程。一般应用于简单数据类型的操作
- 内存障碍(OSMemoryBarrier)和不稳定变量(volatile)
    - 内存障碍强制处理器完成在它之前的所有操作后才能进行它之后的操作
    - 不稳定变量编译器在变量每次被使用时都从内存中载入，而不是使用已载入寄存器内的变量值。保持对变量值读取的有效性。
- 锁(Lock)保护临界区代码(critical section)
    - 互斥锁(mutually exclusive lock, mutex), 一种信号量，一次只授权一个线程访问，未获取授权的被阻塞
    - 递归锁(Recursive lock), 互斥锁的变种，允许一个线程在释放该锁之前对它重复获取多次。释放的次数和获取的次数相等时才能将递归锁真正释放。
    - 读写锁(Read-write lock), 也叫作共享互斥锁(shared-exclusive lock), 用于频繁读取，很少写入的情况。
    所以读取者释放该锁后才能进行写操作，当进行写操作时，无法进行读取。
    - 分布锁(Distributed lock), 提供进程级别的手动互斥访问，它只会报告自己目前是否处理互斥访问状态，但不会阻塞进程运行，将处理细节交给进程自己决定。
    - 自旋锁(Spin lock), 如果它已经被其它单元获取，新的请求会不断的轮询这个锁是否可用。与互斥锁的不同之处在于，当请求不到时不会导致请求者阻塞。因为自旋特性对性能有影响，系统不提供
    - 双重检查锁(Double-checked lock), 再获取锁之前提求检查锁是否可以被获取，因为有潜在问题，系统不提供。
- 条件(Conditions), 是另一种信号量，线程检查条件是否正确，如果不正确则被阻塞，直到其它线程改变条件为正确。与互斥锁不同之处在于，条件可以被多个线程同时访问。

## 线程安全

- 尽量不使用线程同步机制，将并发任务尽量隔离，解耦合。数据私有化。

### 一个不错的面试题

```
NSLock* arrayLock = GetArrayLock();
NSMutableArray* myArray = GetSharedArray();
id anObject;
 
[arrayLock lock];
anObject = [myArray objectAtIndex:0];
[arrayLock unlock];
 
[anObject doSomething];
```
锁释放后，如果在最后一句代码执行物前，其它线程操作数据，删除数据所有元素。则会出现问题。

```
NSLock* arrayLock = GetArrayLock();
NSMutableArray* myArray = GetSharedArray();
id anObject;

[arrayLock lock];
anObject = [myArray objectAtIndex:0];
[anObject doSomething];
[arrayLock unlock];
```

如果把`[anObject doSomething];`移入临界区，当操作比较耗时时，会带来性能总是

```
NSLock* arrayLock = GetArrayLock();
NSMutableArray* myArray = GetSharedArray();
id anObject;
 
[arrayLock lock];
anObject = [myArray objectAtIndex:0];
[anObject retain];
[arrayLock unlock];
 
[anObject doSomething];
[anObject release];
```

这样的解法，即保证了代码正确性，又兼顾了性能问题。

## 死锁和活锁

- 死锁： 两方分别拥有互斥资源不释放的同时，又互相索要对方的互斥资源
- 活锁： 两方同时索要同一互斥资源，发生了冲突后又同时索要另一个互斥资源，第次都是索要同一个互斥资源，导致冲突后的避让策略无法满足双方要求，一直冲突一直避让的动态过程。活锁产生是因为冲突后的避让策略一直无效。
- 饥饿: 因优先级低，一直得不到调度执行，等到天荒地老

避免死锁和活锁的最好方案时，同一时刻只能分配一个锁。


## 同步工具

- @synchronized(obj)可以方便的创建互斥锁，也会异常处理机制。
- NSLock 基础互斥锁
- NSRecursiveLock 递归锁
- NSConditionLock 条件锁，不同于条件信号量机制，可以用于生产者-消费者模型
- NSDistributedLock
- NSCondition 这个对应于条件信号量机制

## 参考文章

- [并发编程指南](https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008091)
-[性能](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/PerformanceOverview/Introduction/Introduction.html#//apple_ref/doc/uid/TP40001410)