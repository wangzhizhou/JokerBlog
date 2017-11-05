`RxJava`及它派生的`RxGroovy`和`RxScala`发展了一种可观察对象的变体`单事件可观察对象`。


单事件可观察对象也是一种可观察对象，不同之处在于，它不是发送一系列值，而是要么发出`一个值`，要么发出`一个错误通知`，没有其它的情况。


由于单事件可观察对象的特殊性，我们在订阅它时不使用三个方法(`onNext`、`onError`、`onCompleted`)，只需要两个(`onSuccess`和`onError`)就可以了。

- `onSuccess` - 单可观察对象所发出的唯一值时调用的方法，并把唯一值作为这个方法的参数传入。
- `onError` - 单可观察对象发生错误时，将一个可抛出错误信息作为参数传给这个方法。

这两个方法中只有一个会被调用并且只调用一次，一旦有一个方法被调用了，那么这个单可观察对象就失效了，整个订阅过程也就终止了。

# 组合单事件可观察对象

与可观察对象一样，单事件可观察对象也可以通过各种运算来操作。其中的一些运算允许可观察对象和单事件可观察对象之间进行交互操作，这样我们可以混合使用这两种对象。


运算符|返回值|描述
---|---|---
compose|单事件可观察对象|创建一个可配置的运算符
concat和concatWith|可观察对象|把多个单事件可观察对象发出的事件连接在一起作为可观察对象的事件参数
create|单事件可观察对象|显式调用订阅者方法来创建一个原始的单事件可观察对象
delay|单事件可观察对象|延迟单事件可观察对象发送事件的时刻
doOnError|单事件可观察对象|返回一个在调用onError方法时也会同时调用doOnError所指定方法的单事件可观察对象
doOnSuccess|单事件可观察对象|返回一个在调用onSuccess方法时也会同时调用doOnSuccess所指定方法的单事件可观察对象
error|单事件可观察对象|返回一个立即通知订阅者发生了错误的单事件可观察对象
flatMap|单事件可观察对象|返回一个已经被函数处理过单事件可观察对象发出事件的单事件可观察对象
flatMapObservable|可观察对象|返加一个已经被函数处理过单事件可观察对象发出事件的可观察对象
from|单事件可观察对象|把一个对象转化成一个单事件可观察对象
just|单事件可观察对象|返回一个只发出特定事件的单事件可观察对象
map|单事件可观察对象|返回一个已经被函数处理过原来单事件可观察对象发出事件的单事件可观察对象
merge|单事件可观察对象|返回一个把另一个单事件可观察对象发出事件作为事件发出的单事件可观察对象
merge和mergeWith|可观察对象|返回一个把其它几个单事件可观察对象发出事件当作自己的事件发出的可观察对象
observeOn|单事件可观察对象|指示一个单事件可观察对象去调用一个在特定调度器下的订阅者方法
onErrorReturn|单事件可观察对象|把一个发出错误信号的单事件可观察对象转化成为一个发出指定事件的单事件可观察对象
subscribeOn|单事件可观察对象|指示单事件可观察对象在指定的调度器上操作
timeout|单事件可观察对象|如果原始单事件可观察对象在指定时间内没有发送任何事件，就返回一个发出错误信息的单事件可观察对象
toSingle|单事件可观察对象|把一个发出单个事件的可观察对象转化成一个单事件可观察对象
toObservable|可观察对象|把一个单事件可观察对象转化成一个只发出一个事件和一个完成通知的可观察对象
zip和zipWith|单事件可观察对象|返回一个单事件可观察对象，这个单事件可观察对象发出的事件是以一个函数处理完其它几个单事件可观察对象发出事件的结果为参数传递的

**下面的部分使用大理石图来说明上面那些操作的用法：**

### 单事件可观察对象用大理石图表示现来

![Single](/reactiveX/images/Single.png)

### compose

### concat 

![concat](/reactiveX/images/concat.png)

###concatWith

![concatWith](/reactiveX/images/concatWith.png)

### create

![create](/reactiveX/images/create.png)

### delay

![delay](/reactiveX/images/delay.png)

#### delay on scheduler

![delay on scheduler](/reactiveX/images/delay-on-schedular.png)

### doOnError

![doOnError](/reactiveX/images/doOnError.png)

### doOnSucces

![doOnSuccess](/reactiveX/images/doOnSuccess.png)

### error

![error](/reactiveX/images/error.png)

### flatMap

![flatMap](/reactiveX/images/flatMap.png)

### flatMapObservable

![flatMapObservable](/reactiveX/images/flatMapObservable.png)


### from

![from](/reactiveX/images/from.png)

#### from take a scheduler

![from with scheduler](/reactiveX/images/from-with-scheduler.png)

### just

![just](/reactiveX/images/just.png)

### map

![map](/reactiveX/images/map.png)

### merge 

**version 1 - merge one**

![merge](/reactiveX/images/merge.png)


**version 2 - merge multiple**

![merge](/reactiveX/images/merge-multiple.png)

### oberveOn

![observeOn](/reactiveX/images/observeOn.png)

### onErrorReturn

![onErrorReturn](/reactiveX/images/onErrorReturn.png)

### subscribeOn

![subscribeOn](/reactiveX/images/subscribeOn.png)

### timeout

**version 1 - timeout within duration**

![timeout-duration](/reactiveX/images/timeout-duration.png)

**version 2 - timeout within duration on scheduler**

![timeout-duration-scheduler](/reactiveX/images/timeout-duration-scheduler.png)

**version 3 - timeout within duration with backup single**

![timeout-duration-backup](/reactiveX/images/timeout-duration-backup.png)

**version 4 - timeout within duration with backup single on scheduler**

![timeout-duration-backup-scheduler](/reactiveX/images/timeout-duration-backup-scheduler.png)


### toObservable

![toObservable](/reactiveX/images/toObservable.png)


### zip和zipWith

![zip-zipWith](/reactiveX/images/zip-zipWith.png)


