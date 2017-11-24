# Swift 4 语言笔记

## 快速开始

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



## 语言细节

- `keyword`使用swift关键字同名的名字命名变量

- `//`单行注释

- `/* */`多行注释， 可以嵌套多行注释

- 句尾分号可以省略

- `0b`、`0o`、`0x`表示二进制、八进制、十六进制

- 指数表示：`1e3 = 10 * 10 * 10`、`1p2 = 2 * 2`

- 易读数字格式：`1_000_000 = 1000000`

- `typealias NewTypeName = existedTypeName`类型别名定义

- 元组`(name: ele1, ele2, _)`,元组可以通过下标或元素来访问单个元素，不适合复杂数据结构

- `Optionals`类型的变量可以有值也可以没有值，统一可以表示各种类型变量没有值的情况

- `nil`不能给非`optionals`变量赋值，OC中的nil是指向一个不存在对象的指针，只对对象类型有效，而swift中的nil不是一个指针，它只是表示一种不存在值的状态，对所有类型有效。

- `!`强制解包，如果一个`Optional`变更确定有值， 就可以使用`!`来使用其值

- `Optionals 绑定`，用于从`Optional`变量中提取值并赋于局部变量使用，在单个if语句中可以使用多个Optional绑定，只要有一个为假，则整个判断为假

- 隐式解绑`Optional！`，确保它声明后一直有值且不为nil, 但它本身还是一个`Optional`，只是在访问时会自动解包

- 函数能抛出错误用`throws`指明，当调用一个可以抛出错误的函数时，前面要加上`try`

- `Assertions`只在调试期间起作用，`precondition`可调试和生产环境中都起作用。`Assertions`在单元测试中经常用到,如果编译器开了`-Ounchecked`选项，`precondition`会被一直认为成功。

```
assert(exp, msg) 失败时显示msg，成功时继续执行

assertionFailure(msg)直接表示失败时的msg显示

precondition(exp, msg)调试和生产环境都起作用
preconditionFailure(:file:line)
fatalError(_:file:line:)严重错误，不会被编译器优化
```

- swfit的`=`赋值不会有返回值，数值默认不允许溢出，但可以明确指定可以溢出

- 一元运算符紧挨运算子，没有空格：`-a, b!`,二元运算:`a + b`，三元运算:`a ? b : c`

- 赋值运算的右边如果是元组，可以自动解析为多个元素赋给左边的变量

- `%`运算的原理：`a = (b x some multiplier ) + remainder`, 不考虑`b`的符号

- 混合赋值运算也不会返回值，这一点和赋值一致

- 全等运算`===`,不全等`!==`，用来判断两个引用是否指向同一个对象

- 如果两个元组有相同的类型和元素个数，它们也可以进行比较，从左到右依次比较，直到发现两个元素不相等时停止比较后面的元素，只有所有元素都支持同一比较运算时才可以比较两个元组，最高能比较有六个元素的无组，再多元素的比较需要自己实现

- 三元运算符不要嵌套使用，使程序更加可读

- `a ?? b`，如果a有值就返回，如果a为nil，则返回b

- 闭区间`a...b`，半开区间:`a..<b`
单端区间在数组上的应用`[a...]`用在数组索引，表示从a开始及其后的所有元素，还有`[...a]`，表示从头开始到a索引

- `"""`多行字符串中也可以使用`\`来转义换行符来续行，在闭合的`"""`前面的空格指名多行字符要忽略的缩进

- `String`是值类型

- 字符串是字符的集合，可以被枚举，元素的类型是`Character`

- `\()`字符串插入可以用于多行字符串

- `\u{n}`1～8位的Unicode字符标量

- `Character`每一个实例都是一个扩展图像簇，每一个扩展图像簇都可以包含多个Unicode标量，用来生成单个可读字符，可以用来显示一些组合字符，使用`count`发生获取字符串长度，也是由于这个原因，swift的字符串中的字符不能使用索引来直接引用，`endIndex`不是一个有效的字符索引，String的`indices`是所有字符元素的索引数组

- 子字符串类型`Substring`, 只是临时使用

- `Character`有`utf8`、`utf16`和`unicodeScalars`三种Unicode兼容的编码数组

- 集合类型：`Array`、`Set`、`Dictionary`

- `Array(repeating:count:)`可以在定义时初始化，

- `enumerated()`方法会返回以(index, emelemt)为元素的数组 

- 集合中元素的类型必须是能hash的，以确保唯一性，集合没有简短写法，声明集合必须显式指明类型，不能类型推断

- switch中的case 后面可以跟`where`

- 控制转移关键字: `continue`、`break`、`fallthrough`、`return`、`throw`

- 语句标签`label: `可以和`break`、`continue`一起使用，可以实现与C语言中goto相同的效果 

- `guard - else`如果guard的条件不成立，就执行else块儿的语句

- `#available(iOS 10, macOS 10.12, *)`API有效性判断

- 函数有`参数标签`和`参数名`，默认参数标签和参数名一样，也可以分别指定，可以使用`_`忽略参数标签

- 可变参数类型`Double...`，一个函数最多只能有一个可变参数，可变参数要放在参数列表的最后


- 函数的参数默认是常量，`inout`修改参数可以在函数体内修改参数值，只能把变量传给inout类型的参数，并且传参时要在前面加一个`&`号，以表示这个参数可以被修改


- 函数就是命名的闭包，嵌套函数可以捕获外层的变量，可以推断变量，单表达式闭包默认会返回值，还有`Trailing Closure`语法

- 闭包的语法： `{(parameters) -> return type in statements }`, 闭包中参数的简写：`$0`

- 如果闭包被赋给类的成员变量，并且闭包本身又引用了类的成员，就会造成循环引用，Swfit使用捕获列表来解决这种循环引用问题

- 闭包是引用类型

- `escaping`闭包：当一个闭包被当作参数传入一个函数，却在该函数返回后被调用。关键字`@escaping`

- 自动闭包：自动创建来包裹表达式并传给其它函数，关键字：`@autoclosure`

























