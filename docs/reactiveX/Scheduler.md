如果你想在你的可观察对象运算瀑布流中引入多线程，你可以指定这些运算或可观察对象在特定的调度器上运行。


`ReactiveX`中的一些运算有一些可以接受调度器作为参数的变体，这种变体就是指定这个运算在指定的调度器上做部分或者全部工作。

可观察对象及其运算默认是在`Subscribe`方法被调用时所在的线程上工作的。`SubscribeOn`方法为可观察对象指定另一个调度器，以使它的工作在其上进行。`ObserveOn`为可观察对象指定一个调度器，使它在发送通知给观察者时在这个调度器上执行。

就像下图所示，`SubscribeOn`指定开始时可观察对象在哪个线程上运行，不管这个操作放在运算链中的哪个位置，作用都一样，与位置无关。而`ObserveOn`方法会作用于可观察对象即将使用的线程上。所以你可能会在链式运算中多次调用`ObserveOn`方法来改变它所作用的线程。

![scheduler](/reactiveX/images/scheduler.png)

# 参考资料

- [Introduction to Rx: Scheduling and Threading](http://www.introtorx.com/Content/v1.0.10621.0/15_SchedulingAndThreading.html)
- [Rx Workshop: Schedulers](http://channel9.msdn.com/Series/Rx-Workshop/Rx-Workshop-Schedulers)
- [Using Schedulers](http://xgrommx.github.io/rx-book/content/getting_started_with_rxjs/scheduling_and_concurrency.html) by Dennis Stoyanov



