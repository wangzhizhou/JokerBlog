# 并发编程指南

[Concurrency Programming Guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008091-CH1-SW1)

并发：多个事情同一时刻发生。

并发可以提高程序的响应度和系统执行效率，但也有额外的开销，并且会增加代码复杂程度，不利用调试和编写逻辑。

OperationQueue和QispatchQueue类似，帮助处理线程管理线程和调度任务，开发者不需要关注线程问题。只关注任务本身。

## DispatchQueue

- 串行队列：一次执行一个任务，执行完成后，才出队执行新任务
- 并发队列：不需要等待任务是否执行完成，一次可以执行当前CPU可承受的最大数目的任务。只要CPU可以承受，就会不断的出队新任务进行执行。
- 主队列： 与应用的RunLoop配合使用，也是个串行队列，在主线程执行任务。

### Dispatch groups

用来监听一组block操作是否完成

系统为每一个应用提供四个优先级的合局并发队列。它们之前只是优先级有所差异：低、默认、高、背景

串行的队列并须自己创建(除主队列)

在队列执行的任务中不要使用dispatch_sync, 如果队列是串行队列，那么一定会发生死锁，如果是并发队列，虽然不一会发生死锁，但这样的操作也尽量避免使用。

```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
 
// Add a task to the group
dispatch_group_async(group, queue, ^{
   // Some asynchronous work
});
 
// Do some other work while the tasks execute.
 
// When you cannot make any more forward progress,
// wait on the group to block the current thread.
dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
 
// Release the group when it is no longer needed.
dispatch_release(group);
```
### Dispatch semaphores

更高效的信号量，当线程没有获取信号量时，会直接调进内核阻塞线程执行。

使用互斥资源总数初始化信号量
使用资源的地方使用wait操作获取资源，使用完成后signal资源

```
// Create the semaphore, specifying the initial pool size
dispatch_semaphore_t fd_sema = dispatch_semaphore_create(getdtablesize() / 2);
 
// Wait for a free file descriptor
dispatch_semaphore_wait(fd_sema, DISPATCH_TIME_FOREVER);
fd = open("/etc/services", O_RDONLY);
 
// Release the file descriptor when done
close(fd);
dispatch_semaphore_signal(fd_sema);
```

### Dispatch sources

用来生成通知响应特定的系统事件。

## DispatchSource

异步处理特定类型的系统事件

## OperationQueue

是封闭了的concurrent dipatchQueue, 增加了任务调度顺序控制依赖功能。NSOperationQueue只接受NSOperation封装的任务。

NSOperation默认是同步执行任务，

### NSInvocationOperation

使用现有的对象、方法、数据创建任务

```
@implementation MyCustomClass
- (NSOperation*)taskWithData:(id)data {
    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                    selector:@selector(myTaskMethod:) object:data];
 
   return theOp;
}
 
// This is the method that does the actual work of the task.
- (void)myTaskMethod:(id)data {
    // Perform the task.
}
@end
```

### NSBlockOperation

多个块任务并发执行，全部完成后，才标志NSBlockOperation执行完成

```
NSBlockOperation* theOp = [NSBlockOperation blockOperationWithBlock: ^{
      NSLog(@"Beginning operation.\n");
      // Do some work.
   }];

//  addExecutionBlock: 可以用来添加更多块任务
```

### 自定义NSOperation

```
@interface MyNonConcurrentOperation : NSOperation
@property id (strong) myData;
-(id)initWithData:(id)data;
@end
 
@implementation MyNonConcurrentOperation
- (id)initWithData:(id)data {
   if (self = [super init])
      myData = data;
   return self;
}
 
-(void)main {
   @try {
        // Do some work on myData and report the results.
        BOOL isDone = NO;
 
        while (![self isCancelled] && !isDone) {
            // Do some work and set isDone to YES when finished
        }
   }
   @catch(...) {
      // Do not rethrow exceptions.
   }
}
@end
```

## OpenCL计算

只要完全独立的计算涉及数据量比较大的任务适合使用OpenCL传到显卡计算，从而获得性能提升

## 注意点

- 引入并发改造应用前后一定要有指标做对比，方便评估和调优。
- 尽量不要自己处理线程，除非以上这些并发处理技术无法胜任时才使用。