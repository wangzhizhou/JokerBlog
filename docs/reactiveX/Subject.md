`Subject`是一种桥梁或者代理，在一些针对`ReactiveX`的实现中，它可既是观察者也是可观察对象。作为观察者，它可以订阅一个或多个可观察对象。作为可观察对象，它也可以重复发出事件，也可以发出新事件。

因为`Subject`订阅了一个可观察对象，它在订阅后就会触发可观察对象开始发出事件。这可以让一个原本是冷可观察对象变成一个热可观察对象。

# 参考资料

- [To Use or Not to Use Subject](http://davesexton.com/blog/post/To-Use-Subject-Or-Not-To-Use-Subject.aspx) from Dave Sexton’s blog
- [Introduction to Rx: Subject](http://www.introtorx.com/Content/v1.0.10621.0/02_KeyTypes.html#Subject)
- [101 Rx Samples: ISubject<T> and ISubject<T1,T2>](http://rxwiki.wikidot.com/101samples#toc44)
- [Advanced RxJava: Subject](http://akarnokd.blogspot.hu/2015/06/subjects-part-1.html) by Dávid Karnok
- [Using Subjects](http://xgrommx.github.io/rx-book/content/getting_started_with_rxjs/subjects.html) by Dennis Stoyanov

# Subject的变体

有四种变体，应用于某些特殊情况下。但不是所有的实现中都使用了它们。某些实现中使用的名称可能有些不同，例如在`RxScala`中，`Subject`被称为`PublicSubject`。


# AsyncSubject

![AsyncSubject](/reactiveX/images/asyncSubject.png)


一个`AsyncSubject`在源可观察对象发出完成通知后才发出源可观察对象的最后一个事件和它的完成通知。如果源可观察对象没有发出任何事件，`AsyncSubject`不发出任何事件，但会发出完成或者错误通知。

![AsyncSubject](/reactiveX/images/asyncSubjectWithError.png)


### 参考

- [Introduction to Rx: AsyncSubject](http://www.introtorx.com/Content/v1.0.10621.0/02_KeyTypes.html#AsyncSubject)


# BehaviorSubject

![behaviorSubject](/reactiveX/images/behaviorSubject.png)

当一个观察者订阅了一个`BehaviorSubject`后，它会收到订阅前源可观察对象发出的最近一个事件，以及订阅后的所有事件。

![behaviorSubjectWithError](/reactiveX/images/behaviorSubjectWithError.png)

###  参考

- [Introduction to Rx: BehaviorSubject](http://www.introtorx.com/Content/v1.0.10621.0/02_KeyTypes.html#BehaviorSubject)

# PublishSubject

![PublishSubject](/reactiveX/images/publishSubject.png)


观察者如果订阅了`PublishSubject`，它可接收到自订阅之后发生的所有事件。

![PublishSubjectWithError](/reactiveX/images/publishSubjectWithError.png)

如果你不想漏掉订阅之前的那些事件，可以选择创建一个冷可观察对象或者使用`ReplaySubject`


# ReplaySubject

![replaySubject](/reactiveX/images/replaySubject.png)

`ReplaySubject`向订阅它的所有观察者发送所有它所发出的事件，不管观察者是从什么时候开始订阅它。

使用`ReplaySubject`作为观察者时，不要从多个线程中调用它的`onNext`和`on`方法，因为这样产生的不一致会违反可观察对象的条约规定，对先重发事件还是先重发通知产生二义性。

### 参考

- [Introduction to Rx: ReplaySubject](http://www.introtorx.com/Content/v1.0.10621.0/02_KeyTypes.html#ReplaySubject)


