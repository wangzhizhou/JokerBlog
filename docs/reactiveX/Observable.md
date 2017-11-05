在`ReactiveX`中，一个观察者可以订阅一个可观察对象。之后观察者就可以对被观察对象发出的一个或一系列事件作出响应。这种模式使并发操作更容易实现，因为观察者在等待被观察对象发出事件的同时不会阻断程序的执行，而是相当于以观察者的方式创建了一个哨兵专门负责响应被观察对象产生的事件。

这一篇就是来说明什么时响应模式、被观察对象和观察者是什么以及观察者怎么订阅被观察对象。其它的篇幅用来展示怎样使用多种被观察对象运算符来链接多个被观察对象并且改变它们的行为。

这个文档使用大理石图来解释相关的概念知识，下面的大理石图用来表示可观察对象及其变换:

![marble-diagram.png](/reactiveX/images/marble-diagram.png)

# 背景知识

在一些编程任务中，我们会希望我们所写的指令立马执行并且马上完成，一次一条，按着我们的书写顺序执行。但在`ReactiveX`中，某些指令可以并行执行，并且它们的执行结果会被观察者捕获，并且指令执行结果与指令执行的顺序无关。你以可观察对象的方式定义一种获取或者变换数据的机制，然后让观察者来订阅它，只要被观察对象按照预定义的机制抛出事件，并且观察者已经作好了响应事件的准备就行。

这种方式的一个优点是，当你有大量相互独立的任务需要完成时，可以让这些任务同时执行，而不是等一个任务完成后再去执行下一个任务。所有这些任务完成的时间，以耗时最长的任务计算。

这里有一些术语用来描述这个异步编程模型：

- 一个观察者订阅了一个被观察对象
- 一个被观察对象可以通过调用其观察者的方法来抛出一个事件或者发送一个通知给它的观察者。

在其它的一些文档和环境下，我们这里所说的`观察者`有时也被叫作`订阅者`、`监视者`或者`响应者`。这种编程模型通常被称为`响应模式`。

# 建立观察者

本文使用类`Groovy`的伪代码来写示例，当然也可以使用其它的编程语言来实现。

一般的方法调用(不像在`ReactiveX`中的异步/并行调用)流程如下：

1. 调用一个方法
2. 把从这个方法中返中的值存入变量
3. 使用这个赋予新值的变量去作一些事情

用伪代码表示就是：

```
//make the call, assign its return value to `returnVal`
returnVal = someMethod(itsParameters);
// so something useful with returnVal
```

而在异步编程模型中，流程如下：

1. 定义一个处理异步调用返回值的方法，这个方法属于观察者
2. 把异步调用定义为一个可观察对象
3. 让观察者去订阅这个定义的可观察对象，这同时也会让可观察对象开始起作用
4. 之后，你就可以处理业务逻辑了，每当异步调用返回值时，观察者就会用自己的方法来处理这个从可观察对象返回的值

用伪代码表示如下：

```
// defines, but does not invoke, the Subscriber's onNext handler
// (in this example, the observer is very simple and has only an onNext handler)
def myOnNext = { it -> do something useful with it };
def myObservable = someObservable(itsParameters);
myObservable.subscribe(myOnNext);
// go on about my business
```

# onNext, onCompleted 和 onError

`Subscribe`方法可以把观察者和可观察对象连接在一起。观察者应该实现下面方法的子集：

* `onNext` - 可观察对象每发出一个事件，就会调用一次这个方法，并把发出的事件作为这个方法的参数

* `onError` - 可观察对象通过调用这个方法来表明它无法生成期望的数据或者碰到了一些其它的错误。这个方法被调用之后，可观察对象就不会再调用`onNext`和`onCompleted`方法了。同时，`onError`方法被调用时会把错误信息封装成它的参数，告诉观察者发生了什么类型的错误

* `onCompleted` - 当一个可观察对象调用完最后一次`onNext`方法后如果没有出现任何错误，便会调用`OnCompleted`方法

根据可观察对象的不同协议类型，`onNext`方法可能会被调用多次，也可能完全不会被调用，但`onCompleted`和`onError`方法一定是可观察对象最后调用的方法，并且它们是互斥的，不会作为最后的方法被同时调用。通常，我们把`onNext`方法调用称为`事件发送`,而`onCompleted`和`onError`方法调用称为`通知`。


一个更加完整的订阅调用示例如下：

```
def myOnNext = { item -> /* do something useful with item */ };
def myOnError = { throwable -> /* react sensible to a failed call */ };
def myOnCompleted = { /* clean up after the final response */ };
def myObservable = someMethod(itsParameters);
myObservable.subscribe(myOnNext, myOnError, myOnCompleted);
// go on about my bussiness
```

# 取消订阅

在一些`ReactiveX`的实现中，有一种特殊的观察者接口，叫作`订阅者`，它实现了一个`unsubscribe`方法。你可以通过调用这个`unsubscribe`方法来表明你对当前订阅的可观察对象不再感兴趣。如果这个可观察对象没有被其它的观察者订阅，它就可以停止发送新的事件。

取消订阅的结果就是让观察者订阅可观察对象的运算链上每一个事件通道都关闭。这个不会立即生效，即使可观察对象已经没有被任何观察者订阅，它也可能会持续一段时间向外发送事件。

# 命名公约

具体语言在各自实现`ReactiveX`时，都有各自的命名风格，没有什么规范标准，但不同的实现有一些共同之处。

一些命名在某些场合下显的很难理解，甚至有点古怪。

例如像`onEvent`的命名方式(onNext、onCompleted、onError)。在其它一些场合下，这样的命名指明哪一个事件处理函数被注册，但在`ReactiveX`中，这种命名表示的是事件处理函数本身。

# 热可观察对象和冷可观察对象

什么时候可观察对象会对外发出事件呢？这就要看具体的可观察对象是什么类型的了。热可观察对像在创建之后立马就向外发出事件，任何在它创建之后订阅它的观察者都只能获得所有发出事件的一部分。冷可观察者在向外发送事件之前，必须至少有一个观察者订阅了它才行，所以第一个观察者可以从头到尾获得所有的事件。

#  通过可观察对象运算来组合可观察对象

可观察对象和观察者只是`ReactiveX`的基础，它们仅仅是对标准观察者设计模式的扩展，可以更好的适用于一系列的事件回调，而不是针对单个回调。

`ReactiveX`通过扩展运算来变换、组合、操作一系列可观察对象发出的事件，从而发挥真正的威力。

这些扩展运算可以把异步序列结合在一起，以一种简单明了的方式展现出来，充分发挥了回调的优点，避免了回调在传统异步编程中存在的多级嵌套的缺点。


本文档在下面汇总了很多这些扩展运算和相应的用法:

## 创建可观察对象的操作

`Create`、`Defer`、`Empty`/`Never`/`Throw`、`From`、`Interval`、`Just`、`Range`、`Repeat`、`Start`和`Timer`

## 变换可观察对象的操作

`Buffer`、`FlatMap`、`GroupBy`、`Map`、`Scan`和`Window`

## 过虑可观察对象的操作

`Debounce`、`Distinct`、`ElementAt`、`Filter`、`First`、`IgnoreElements`、`Last`、	`Sample`、`Skip`、`SkipLast`、`Take`和`TakeLast`

## 组合可观察对象的操作

`And`/`Then`/`When`、`CombineLatest`、`Join`、`Merge`、`StartWith`、`Switch`和`Zip`

## 错误处理可观察对象的操作

`Catch`和`Retry`

## 辅助操作

`Delay`、`Do`、`Materialize`/`Dematerialize`、`ObserveOn`、`Serialize`、`Subscribe`、`SubscribeOn`、`Timeout`、`Timestamp`和`Using`

## 条件布尔操作

`All`、`Amb`、`Contains`、`DefaultIfEmpty`、`SequenceEqual`、`SkipUntil`、`SkipWhile`、`TakeUntil`和`TakeWhile`

## 数学和聚合操作

`Average`、`Concat`、`Count`、`Max`、`Min`、`Reduce`和`Sum`

## 转换操作

`To`

## 连接可观察对象操作

`Connect`、`Publish`、`RefCount`和`Replay`

## 背压操作

增强流控制策略的多种运算


**上面的这些运算包含了一些并不是`ReactiveX`核心运算的部分，但它们在一些特殊语言的实现和可选模块中有应用。**


# 链式运算

大部分运算基于可观察对象，并且返回值也是可观察对象，这种方式让你能够以链式进行运算。在链式运算的过程中，每一个运算符都作用于前一个运算处理完成后返回的可观察对象上。

这儿产生了另一个问题，在创造模式中，链式方法调用的顺序对结果没有影响，但在`ReactiveX`的可观察对象上进行的链式运算的顺序对结果有影响。

可观察对象上的链式运算不是独立的作用在原始可观察对象上的，每一个运算都基于前一个运算返回的结果，所以顺序就显的很重要了。

# 参考文章 
- [Single](http://reactivex.io/documentation/single.html) — a specialized version of an Observable that emits only a single item
- [Rx Workshop: Introduction](http://channel9.msdn.com/Series/Rx-Workshop/Rx-Workshop-Introduction)
- [Introduction to Rx: IObservable](http://www.introtorx.com/Content/v1.0.10621.0/02_KeyTypes.html#IObservable)
- [Mastering observables](http://docs.couchbase.com/developer/java-2.0/observables.html) (from the Couchbase Server documentation)
- [2 minute introduction to Rx](https://medium.com/@andrestaltz/2-minute-introduction-to-rx-24c8ca793877) by Andre Staltz (“Think of an Observable as an asynchronous immutable array.”)
- [Introducing the Observable](https://egghead.io/lessons/javascript-introducing-the-observable) by Jafar Husain (JavaScript Video Tutorial)
- [Observable object](http://xgrommx.github.io/rx-book/content/observable/index.html) (RxJS) by Dennis Stoyanov
- [Turning a callback into an Rx Observable](https://afterecho.uk/blog/turning-a-callback-into-an-rx-observable.html) by @afterecho


