Go语言是Google创建，健壮并且静态类型，社区比较先进，它的特点：

1. 比较简单
2. 编译比较快
3. 垃圾回收，不需要管理内存
4. 内建的并发机制
5. 可编译为独立二进制

与其它语言的对比：

- Python好学，但运行慢
- Java类型越来越复杂
- C/C++类型系统复杂，编译太慢

- [Go官网包管理](https://golang.org/pkg/)
- [Go官网文档](https://golang.org/doc/)
- [Go官网](https://golang.org/#)
- [Go语言在线练习](https://play.golang.com)

## 设置Go语言开发环境

// TODO:

### 变量

```go
package main

import {
    "fmt"
    "strconv"
}

var i int = 42

var {
    actorName string = "Elisabeth Sladen"
    companion string = "Sarah Jane Smith"
    doctorNumber int = 3
    season int = 11
}

func main() {
    var i int
    i = 42
    i = 27

    fmt.Println(i)

    j := 42
    fmt.Println(j)

    k := 99.
    fmt.Printf("%v, %T", j, i)

    var seasonNumber int = 11
    fmt.Println(i)

    var j float32
    j = float32(i)
    fmt.Printlf("%v, %T\n", j, j)

    vvar j string
    j = strconv.Itoa(i)
    fmt.Printf("%v, %T\n", j, j)
}
```

所有变量都必须使用，可见性第一个字母小写是在包范围内可见，第一个字符大写是导出包外，没有私有范围可见

### 基础类型

```go
package main
import {
    "fmt"
}

func main() {
    var n bool = false
    fmt.Printf("%v, %T\n", n, n)

    m := 1 == 1
    k := 1 == 2
    fmt.Printf("%v, %T\n", m, m)
    fmt.Printf("%v, %T\n", k, k)

    var j uint16 = 42
    fmt.Printf("%v, %T\n", j, j)

    a := 10 // 1010
    b := 3  // 0011 ^b 1100
    fmt.Println(a + b)
    fmt.Println(a - b)
    fmt.Println(a * b)
    fmt.Println(a / b)
    fmt.Println(a % b)
    fmt.Println(a & b) // 0010
    fmt.Println(a | b) // 1011
    fmt.Println(a ^ b) // 1001
    fmt.Println(a &^ b)// 1000
    fmt.Println(a << 3)
    fmt.Println(a >> 3)

    var n float32 = 3.14
    // n = 13.7e72
    n = 2.1E14
    fmt.Printf("%v, %T", n, n)

    var n complex64 = 1 + 2i
    n = complex(5, 12)
    fmt.Printf("%v, %T\n", n, n)
    fmt.Printf("%v, %T\n", real(n), real(n))
    fmt.Printf("%v, %T\n", imag(n), imag(n))

    s := "this is a string"
    fmt.Printf("%v, %T\n", string(s[2]), s[2])

    b := []byte(s)
    fmt.Printf("%v, %T\n", b, b)

    r := 'a'
    fmt.Printf("%v, %T\n", r, r)
}
```

go语言中的二元操作要类型一致。

- `&^`这个是按位清空运算符：`a &^ b`等价于 `a AND (NOT b)`
- 字符串不可变，可被转成字符数组
