# MRC - 手动引用计数(属于Foundation Framework NSObject)

- 创建并持有(alloc/new/copy/mutableCopy)（1）
- 持有(retain)（+1）
- 放弃持有(release)（-1）
- 处理(dealloc)(0)

- 方法返回内部持有的对象时，会把所有权传递给调用者(这类方法名称要注意定义到alloc/new/copy/mutableCopy组中)
- 方法返回内部不持有的对象时，可以使用autorelease延迟释放(方法名称也要注意不要定义到alloc/new/copy/mutableCopy组中)

- NSZone是为了解决内存碎片问题，不过现在新的内存管理只够高效已经不需要NSZone了
- malloc()分配指定大小的内存不初始, calloc()分配指定数量指定大小的内存并初始化

**使用LLDB来调试一下ARC的执行过程当作逆向训练**

- 所有对象的引用计数被放在一张以对象内存地址为键，计数值为值的哈希表中，这有利用调试

- C语言的自动变量是那种离开作用域就会被释放的变更, NSAutorelasePool变量就像自动变量一样

- 在NSAutoreleasePool对象上调用autorelease方法会导致应用终止，因为NSAutoreleasePoot重写了自己的autorelease方法，在里面终止了

# ARC - 自动引用计数(-fobjc-arc)

- `id` 和 `void*` 等价，每一个对象指针都必须指定修饰词(__strong/__weak/__unsafe_unretained/__autoreleasing)中一个，默认为`__strong`

- 使用`__strong`会产生循环引用的问题，所以有了`__weak`和`__unsafe_unretained`
- `__weak`修饰的指针在引用的变量释放后会自动置为nil,对引用的变量不持有
- `__unsafe_unretained`修饰的变量是不安全的，相关的内存管理不受编译器支持，不持有变量，引用的变量释放后不会自动置nil,有可能会造成指针悬挂(指向曾经存在的对象的指针，而野指针是指未被初始化的指针)
- `__autoreleasing`: 包含在`@autoreleaspeool{}`块中的变量
- 任何的向`id`和`对象类型`的指针都被自动修饰为`__autoreleasing`

## 使用ARC的规则

1. 不使用`retain`、`release`、`retainCount`、`autorelease`因为这些编译器会自动完成
2. 不使用`NSAllocateObject`、`NSDeallocateObject`
3. 遵循对象创建相关的方法命名规则:(alloc/new/copy/mutableCopy)
4. 不使用`dealloc`
5. 使用`@autoreleasepool`而不是`NSAutoreleasePool`
6. 不使用`NSZone`
7. OC的对象类型变量不能成为C语言结构体和联合体中的成员
8. `id`和`void*`相关转换时必须显示转换，使用`__bridge`、`__bridge_retained`、`__bridge_transfer`

## 属性修饰

|属性修饰|所有权修饰|
|:-----:|-------:|
|assign|__unsafe_unretained|
|copy|__strong|
|retain|__strong|
|strong|__strong|
|unsafe_unretained|__unsafe_unretained|
|weak|__weak|

# ARC实现

`__weak`修饰的变量不要过多，会影响性能，只在需要解决循环引用的时候使用


# Block(匿名函数/lambda/闭包)

## 语法 

`^` `return type` `(arguments list)` `{ expressions }`
 - 可以省略`return type`，会从return 语句返回值类型推断
 - 无参数时，参数列表也可以省略

## block变量声明

`return type` `(^var)` `(arguments list)`

定义示例：`typedef int (^blk_t)(int)` 

块内拷贝外部自动变量，叫作变量捕获(只读)

以`__block`修饰的外部自动变量在块内可以被修改

c数组不能被块捕获，需要使用指针

## block的实现

clang使用`-rewrite-objc`编译选项可以将包含块语法的代码转换成标准C++源代码

内在段布局：一个应用对应的内存布局是 `.text区`用来存放代码， `.data`区用来存放和代码相关的数据，`heap`区动态使用内存空间，`stack`区，从低地址到高地址

在数据区的block(全局定义的block)， 在栈中的block和在堆中的block*(函数返回的块会被拷到堆上)

block作为函数参数时，在传递时会被拷贝

block会造成循环引用问题：解决方式有两种：使用`__block`来发生循环引用后手动解除或使用`__weak`预防

# GCD

- performSelectorInBackground:withObject
- performSelectorOnMainThread

## 常见用法：

```
dispatch_async(queue_for_background_threads, ^{

    //background task 

    dispatch_async(dispatch_get_main_queue(), ^{
        //use the task result on main thread
    })

})
```

一个线程就是CPU的一个执行路径，多线程编程中易遇到的问题是：竟争和死锁

多线程编程是为了应用可以高响应


## GCD APIs

两种分发队列： 串行队列和并发队列。队列里面只是存放执行任务，然后分发给对应的线程。

### 获取分发队列

#### 串行队列：多个串行队列也可以并发运行，系统为第一个串行队列创建一个线程与之对应。

串行对列可用来解决多线程编程中的竟争问题，但一个串行队列对应一个线程，所以不要创建过多的串行队列。

```
dispatch_queue_t serialDispatchQueue = dispatch_queue_create("com.joker.serialQueue", NULL);
//中间步骤
dispatch_release(serialDispatchQueue);
```

#### 并发队列

```
dispatch_queue_t concurrentDispatchQueue = dispatch_queue_create("com.joker.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
//中间使用
dispatch_release(concurrentDispatchQueue);
```

一般不要单独创建并发队列，使用系统的全局队列就好，全局队列有四个优先级: 高、默认、低和后台

```
dispatch_queue_t mainDispatchQueue = dispatch_get_main_queue();
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
```

#### 设置对列优先级

优先级设置为与目标队列一致，源队列不能是系统队列，同时也可以设置队列层级
```
dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.example.gcd.MySerialDispatchQueue", NULL);
dispatch_queue_t globalDispatchQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
dispatch_set_target_queue(mySerialDispatchQueue, globalDispatchQueueBackground);
```

#### dispatch_after 延时分发任务

```
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC); dispatch_after(time, dispatch_get_main_queue(), ^{
    NSLog(@"waited at least three seconds."); 
});
```

- dispatch_time用来创建相对时间
- dispatch_walltime用来创建绝对时间

#### dispatch_group 创建队列组为单位的任务 

```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, queue, ^{NSLog(@"blk0");}); dispatch_group_async(group, queue, ^{NSLog(@"blk1");}); dispatch_group_async(group, queue, ^{NSLog(@"blk2");});
dispatch_group_notify(group, dispatch_get_main_queue(), ^{NSLog(@"done");});
dispatch_release(group);
```

#### dispatch_group_wait

```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, queue, ^{NSLog(@"blk0");}); dispatch_group_async(group, queue, ^{NSLog(@"blk1");}); dispatch_group_async(group, queue, ^{NSLog(@"blk2");});
dispatch_group_wait(group, DISPATCH_TIME_FOREVER); dispatch_release(group);
```













































