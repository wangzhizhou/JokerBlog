# Swift 4 语言笔记

- 版本判断

```
#if swift(>=3.2)
    print(">=3.2")
#else
    print("<3")
#endif
```

- 常量`let`声明： 显式/隐式，类型转换必须显式
- 变量`var`声明

- 字符串格式化模板：`"I have \(apples + oranges) pieces of fruit."`

- 多行字符串使用`"""`：

```
let quotation = """
I am joker.

And She is a girl.

We are family.
"""

print(quotation)
```

- 数组和字符允许最后一个元素带`,`号，如果类型信息能推断，可能使用`[]`、`[:]`来定义空数组和字典，否则使用初始化器: `[String]()`、`[String:String]()`

- `if`、`switch`、`for-in`、`while`、`repeat-while`的条件部分可以不带括号，但执行体必须用花括号包住

- 正常类型后面跟个`?`号就是`Optional`类型，使用`if let local = optional {}`是使用`optional`类型的一种常用方式, `local`变量只在`if - let`执行体内部有效

- `??`是给`Optional`类型变量取默认值的方法

- `switch`支持各种类型, `case`默认不需要加`break`，使用`fallthrough`可以漏到下一个`case`

```
let v = "raff"
switch v {
case "red":
    print("red")
case let x where x.hasPrefix("r"):
    print("r prefix")
    fallthrough
case let "r":
    print("fallthrough")
default:
    print("default")
}
```

- 字典枚举时是无序的: `for (key, value) in dict {}`

- 循环：
```
var n = 2
while n < 100 {
    n *= 2
}
print(n)
```

- 最少执行一次的循环
```
var m = 2
repeat {
    m *= 2
}while m < 100
print(m)
```

- `..<`和`...`可以生成一个序列，右边界不同

- 定义函数`func`, `->`指明返回值类型, 默认参数标签和参数名相同
```
func greet(person: String, day: String) -> String {
    return "Hello, \(person), today is \(day)."
}
greet(person: "joker", day: "Thursday")
```

- 可以使用`tuple`来返回多值，可根据位置索引取`tuple`各元素值，也可以命名可元素标签

- 函数可以嵌套，可访问外层变量

- 闭包`{  参数及返回会 in 体 }`， `$0`，闭包的第一个参数， 闭包作为函数的最后一个参数时可以放在最后，即`trailing closure`

- `class`声明类，`:`表示继承，`init`、`deinit`初始化和反初始化器

- `override` 覆盖父类方法必须是显式指定


- getter和setter, `newValue`和
```
var Name: Type {

    get {

    }

    willSet {

    }
    set(newValue) {

    }
}
```

- 链式操作中经常使用`?`符号

- `enum`定义枚举，`rawValue`可以指定，不仅限定于Int

- `struct`定义结构体，和类的主要区别是结构体是值类型

- `protocol`定义协议，类、结构体和枚举都可以使用协议，`mutating`修饰结构体和枚举中的协议方法实现，可以修改值类型成员

-  可以使用扩展`extension`来使用协议，可以把协议名作为一种类型来调用所有遵循该协议类型对象，只限于协议定义的内容

- `throw`可以抛出一个异常，`throws`指明一个函数可以抛出异常，使用`do-try[?]-catch...`来处理异常, `try?`把结果转化为`Optional`类型，抛出错误时返回nil, 否则返回包含结果的`Optional`

- `defer`描述的代码块会在函数返回前一刻执行，不论函数执行是否抛出错误

- 泛型`<TypeName:TypeProtocol>` `where TypeRequirement`在执行体前面使用：`<T: Equatable>`和`<T> ... where T: Equatable`等价




