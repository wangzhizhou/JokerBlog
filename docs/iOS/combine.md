
# Apple官方异步事件处理框架

合并已有的异步框架:

1. NotificationCenter: 通知中心
2. delegate: 代理模式
3. Grand Central Dispatch
4. Closure: 闭包
5. Timer: 定时器
6. Operatins

苹果已经把`Comgine`框架集成在基础开发框架中了，很容易和现有的异步机制一块使用或者完全替代，还可以与最新的`SwiftUI`框架联合一起使用。


```
        SwiftUI
           ^
           |

Foundation   CoreData
           ^
           |

        Combine
```

`Microsoft`在2012年开源了`Rx.NET`，之后一些其它的语言实现了相同的概念，例如: `RxJS`、`RxKotlin`、`RxScala`、`RxPHP`、`RxSwfit`、`ReactiveSwift`

`Combine`也是一种类似于Rx的实现，但实现的细节有些不同。

在声明式编程中有三个重要的概念:

1. publisher: 发布者
2. operator: 操作者
3. subscriber: 订阅者


## Publisher 发布者

发布者是一种可以随时间推移发出事件的类型

1. 通用Output类型的事件
2. 事件发送完成的事件
3. 事件发送失败的事件

- Just: 给订阅者发送一个事件后就发送完成事件

```swift
publish protocol Publisher {
    associatedtype Output
    associatedtype Failure: Error

    func receive<S>(subscriber: S)
        where S: Subscriber, 
        Self.Failure == S.Failure,
        Self.Output == S.Input
}

extension Publisher {
    public func subscribe<S>(_ subscriber: S)
        where S: Subscriber,
        Self.Failure == S.Failure,
        Self.Output == S.Input
}
```

Combine中Publisher是一个范型，需要指定元素类型和失败类型，例如: Publisher<Int, Never>

## Operator 操作者

操作者作用于发布者，返回原来的发布者或者一个新的发布者，这样的返回值可以使操作者被链式的调用。操作者的调用顺序很重要。

操作者的输入输出分别叫作上游(upstream)和下游(downstream), 操作者就是接收到上游给到的数据，经过自己的处理后提供给下游的其它操作者。中间不会有其它角色修改被处理的数据。

## Subscriber 订阅者

Combine提供了两个内置的订阅者:

1. sink: 提供闭包来处理接收到的数据

2. assign: 允许把接收到的数据通过`keypath`绑定赋值给数据模型或UI控件

```swift 
public protocol Subscriber: CustomCombineidentifierConvertible {
    associatedtype Input
    associatedtype Failure: Error

    func receive(subscription: Subscription)

    func receive(_ input: Self.Input) -> Subscribers.Demand

    func receive(completion: Subscribers.Completion<Self.Failure>)
}
```


## 订阅关系

```swift
public protocol Subscription: Cancellable, CustomCombineIdentifierConvertible {
    func request(_ demand: Subscribers.Demand)
}

```

没有订阅者的时候，发布者不会发出任何事件，系统提供的订阅者都遵守`Cancellable`协议，也就是整个订阅流程最终都会返回一个`Cancellalbe`对象，当这个`Cancellable`被释放时，最个订阅关系所涉及的所有内存都会被释放，简化了内存管理的问题。`Cancellable`对象可以调用`cancel`方法手动释放

`Combine`的使用不会对应用的架构产生影响，它只是处理异步数据事件，并且统一了对象间的通信规范。

当把`Combine`和`SwiftUI`结合使用时，`MVC`的设计模式就可以把`C`这一部分去掉了。


