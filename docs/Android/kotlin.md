## 安装最新JDK

根据不同平台安装最新JDK: [下载JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

配置环境JDK变量:

- Linux: `~/.bashrc`中添加下面的环境变量配置
- MacOS: `~/.bash_profile`中添加下面的环境变量配置

```bash
export JAVA_HOME=<JDK Dir>
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:JAVA_HOME/lib/dt.jar:JAVA_HOME/lib/tools.jar
```

保存后，使环境变量配置生效

```bash
source ~/.bashrc   # Linux
```

## Kotlin 安装脚本(Unix/Linux), 并测试是否安装成功

```bash
# !/usr/bin/env bash
# 参考: https://kotlinlang.org/docs/tutorials/command-line.html
# 最求: JDK安装最新版

sudo apt-get install -y zip
curl -s https://get.sdkman.io | bash
source ~/.sdkman/bin/sdkman-init.sh
sdk install kotlin
source ~/.bashrc
echo "fun main(args: Array<String>) { println(\"Hello, World!\") }" > hello.kt
kotlinc hello.kt -include-runtime -d hello.jar
java -jar hello.jar
```

## Kotlin语言基础

```kotlin
fun main() {
    println("Hello World")
}
```

### 变量

```kotlin
fun main() {
    val name: String = "" // 常量，只赋值一次
    name = "" // 改变值会报错
}
```

```kotlin
fun main() {
    var name: String = "" // 变量
    name = "" // 改变值不会报错

    println(name)
}
```

```kotlin

var global_var: String = "global variable"
val global_const: String = "global variable"
var global_optional_var: String? = "global_optional_var"

fun main() {
    global_optional_var = null

    println(global_var)
    println(global_const)
    println(global_optional_var)

    // 三元运算等价语法1
    when(greeting) {
        null -> println("Hi")
        else -> println(greeting)
    }

    // 三元运算等价语法2
    val greetingToPrint = if (greetint != null) greeting else "Hi"
}
```

### 基本函数

```kotlin

fun getGreeting(): String {
    return "Hello Kotlin"
}

// Unit，表示函数没有返回值
fun sayHello(): Unit {
    println(getGreeting())
}

fun singleExpressionFunc():String = "single expression function"

func sayHello(itemToGreet: String) {
    val msg = "Hello " + itemToGreet
    println(msg)
}

fun sayHello2(itemToGreet: String) = println("Hello " + $itemToGreet)

fun main() {
    println("Hello, world!")
    println(getGreeting())
    sayHello()
    singleExpressionFunc()
    sayHello(itemToGreet: "Joker")
    sayHello2(itemToGreet: "Alice")
}
```

### 集合类型

```kotlin
fun main() {
    val interestingThings = arrayOf("Kotlin","Programming", "Comic Books")

    println(interestingThings.size)
    println(interestingThings[0])
    println(interestingThings.get(0))

    for(interestingThing in interestingThings) {
        println(interestingThing)
    }

    interestingThings.forEach { it ->
        println(it)
    }

    interestingThings.forEachIndexed { index, intersetingThing ->
        println("$intersetingThing is at index $index")
    }
}
```

```kotlin
fun main() {
    val interestingThings = listOf("Kotlin","Programming", "Comic Books")

    val map = mapOf(1 to "a", 2 to "b", 3 to "c")
    map.forEach { key, value ->
        println("$key -> $value")
    }
}
```

Kotlin集合类型默认是不可变的。需要可变时，要显式指定。

```kotlin
fun main() {
    val interestingThings = mutableListOf("Kotlin","Programming", "Comic Books")

    interestingThings.add("Dogs")

    val map = mutableMapOf(1 to "a", 2 to "b", 3 to "c")

    map.put(4, "d")

    map.forEach { key, value ->
        println("$key -> $value")
    }
}
```

### 函数可变参数

```kotlin

fun sayHello(greeting: String, vararg itemsToGreet: String) {
    itemsToGreet.forEach { itemToGreet ->
        println("$greeting $itemToGreet")
    }
}

fun greetPerson(greeting: String = "Hello", name: String = "Kotlin") = println("$greeting $name")

fun main() {
    val interestingThings = listOf("Kotlin", "Programming", "Comic Books")

    sayHello(greeting: "Hi", itemsToGreet: "Kotlin", "Programming", "Comic Books")

    sayHello(greeting: "Hi", itemsToGreet: *interestingThings)

    greetPerson(greeting: "hi", name: "Nate")

    sayHello(greeting: "Hi", *interestingThings)
}
```

### 类

```kotlin
class Person1 constructor() {
}

class Person2(_firstName: String, _lastName: String) {
    val firstName: String
    val lastName: String

    init {
        firstName = _firstName
        lastName = _lastName
    }
}

class Person3(_firstName: String, _lastName: String) {
    val firstName: String = _firstName
    val lastName: String = _lastName
}

class Person4(val firstName: String, val lastName: String) {

    init {
        println("init 1")
    }

    constructor(): this("Peter", "Parker") {
        println("secondary constructor")
    }

    init {
        pritnln("init 2")
    }
}

fun main() {
    val person = Person3(_fristName = "Wang", _lastName = "zhizhou")

    println(person.firstName)
    println(person.lastName)
}
```

```kotlin
class Person(val firstName: String = "Perter", val lastName: String = "Parker") {
    var nickName: String? = null
        set(value) {
            field = value
            println("the new nick name is: $value")
        }
        get() {
            println("the returen value is $field")
        }
    fun printInfo() {
        var nickNameToPrint = if(nickName != null) nickName else "no nickName"
        // or 
        // nickNameToPrint = nickName ?: "no nickName"
        println("$firstName ($nickNameToPrint) $lastName")
    }
}

fun main() {
    val person = Person()

    person.nickName = "Wang"
    println(person.nickName)

    person.printInfo()
}
```

四个访问修饰符, 可用来修饰类、成员、成员方法:

- `protected` - 在本类和子类内部可见
- `public` - 默认修饰符，可以不添加
- `intrnal` - 模块内部可访问
- `private` -  文件内部可访问

### 接口

```kotlin
interface PersonInfoProvider {
    fun printInfo(persion: Person) {
        println("basicInfoProvider")
        person.printInfo()
    }
    val providerInfo: String = "Default"
}

interface SessionInfoProvider {
    fun getSessionId(): String
}


class BasicInfoProvider: PersonInfoProvider, SessionInfoProvider {
    override val providerInfo: String
        get() = "BasicInfoProvider"

    override fun printInfo(persion: Person) {
        super.printInfo(person)

        println("additional print statement")
    }
    override fun getSessionId(): String {
        return "Session Id"
    }
}


fun main() {
    val provider = BasicInfoProvider()
    provider.printInfo(Person())
    provider.getSessionId()

    checkTypes(provider)
}

fun checkTypes(infoProvider: PersonInfoProvider) {
    if (infoProvider !is SessionInfoProvider) {
        println("not a session info provider")
    } else {
        (infoProvider as SessionInfoProvider).getSessionId()
        // or
        // infoProvider.getSessionId()
    }
}
```


### 继承

```kotlin
open class BasicInfoProvider {
    val providerInfo: String
}

class FancyInfoProvider: BasicInfoProvider {
    override val providerInfo: String
        get() = "Fancy Info Provider"
}

fun main() {
    val provider = FancyInfoProvider()
}
```

默认类是不能被扩展的，得加上`open`修饰

### 对象表达式

```kotlin
fun main() {
    val provider = object: PersonInfoProvider {
        overrider val providerInfo: String
            get() = "New Info Provider"

        fun getSessionId() = "id"
    }
}
```

不用创建新类的继承实例化

### 合作对象

```kotlin
interface IdProvider {
    func getId(): String
}

class Entity private constructor(val id: String){
    companion object Factory: IdProvider {

        override func getId(): String {
            return "123"
        }

        const val id = "id"
        fun create() = Entity(getId())
    }
}

fun main() {
    val entity = Entity.Factory.create()
    Entity.id
}
```

### 对象声明

```kotlin
object EntityFactory {
    fun create() = Entity("id")
}

class Entity(val id: String, val name:String) {
    override fun toString(): String {
        return "id: $id name: $name"
    }
}

fun main() {
    val entity = EntityFactory.create()
    println(entity)
}
```

### 枚举

```kotlin
enum class EntityType {
    EASY, MEIDUM, HARD

    fun getFormattedName() = name.toLowerCase().capitalize()
}

object EntityFactory {
    fun create(type: EntityType): Entity {
        val id = UUID.rndomUUID().toString()
        val name = when(type) {
            EntityType.EASY -> type.name
            EntityType.MEDIUM -> type.getFormattedName()
            EntityType.HARD -> "Hard"
        }
        return Entity(id, name)
    }
}

class Entity(val id: String, val name:String) {
    override fun toString(): String {
        return "id: $id name: $name"
    }
}

fun main() {
    val entity = EntityFactory.create()
    println(entity)
}
```

### 封装类,不可被继续继承

```kotlin
sealed class Entity() {
    data class Easy(val id: String, val name: String): Entity()
    data class Medium(val id: String, val name: String): Entity()
    data class Hard(val id: String, val name: String): Entity()
}
```

有点没太明白这块儿，有待进一步学习

### 数据类

```kotlin

```

### 比较

```kotlin

```

### 表达式函数和属性

```kotlin

```

### 高级函数

函数式编程
