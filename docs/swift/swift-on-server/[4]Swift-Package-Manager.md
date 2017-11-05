# Swift 包管理(Swift 3.x)

重复造轮子很浪费时间和精力。如果使用一个其它开发者已经开发出来并且久经考验的库来实现自己应用的功能，会节省很多时间。Swift进化速度很快，会有很多相似的库被设计出来用于解决同一个问题，如果你的项目使用`Swift`，你可以在`GitHub`或者`IBM Swift Package Catalog`上找到很多Swift包, 这些包可以通过`Swift Package Manager(SwiftPM)`方便的集成进自己的项目中。无论是你要存数据到数据库、解析JSON或者使用`Reactive`编程模式，你都可以通过`Swift`包管理来进行。

作为开发者，你可以使用`SwiftPM`来集成一些库到项目中。如果你已经使用过一些其它的包管理工具，如：`Rust`的`Cargo`、`NodeJS`的`npm`、`Java`的`Maven`或者`Ruby`的`Gem`，那么你不会对`swiftPM`感到陌生，它们的功能是相似的：通过下载匹配版本的源并执行编译。`SwiftPM`可以在多平台下工作，你可能使用Shell命令来执行编译、测试或获取依赖项目，还可以用来生成`XCode`项目。

## 包版本匹配

当`SwiftPM`获取包时，会进行版本匹配。每个包都对应一个三级版本号：`主版本号`-`副版本号`-`补丁版本号`。

`主版本号` - 包的API有重要变化并影响依赖它的其它项目时变更。

`副版本号` - 不影响老版本的情况下增加新特性时变更。

`补丁版本号` - 在bug修复并不影响后向兼容性的情况下变更。


`SwiftPM`只会获取那些由开发者打了tag标志点的依赖源版本，但不能获取依赖源的最新提交，这样可以让那些依赖项目不至于被正在开发的依赖源中所做的一些变更影响到。保证依赖项目一直是使用比较稳定的依赖源。

## 创建应用

下面使用`SwiftPM`来创建新工程，获取一个依赖源集成进项目中并编译。

```
$ mkdir MyProject
$ cd MyProject/
$ swift package init --type executable
Creating executable package: MyProject
Creating Package.swift
Creating .gitignore
Creating Sources/
Creating Sources/main.swift
Creating Tests/
```
所有excutable项目或者Targets都会在`Sources`目录下包含一个名为`main.swift`的main入口文件。

```
$ cat Sources/main.swift 
print("Hello, world!")
```

`.gitignore`文件内指定了不加入git版本控制的文件或类型或目录。

```
$ cat .gitignore 
.DS_Store
/.build
/Packages
/*.xcodeproj
```

`Package.swift`文件是项目的信息组织文件，里面包含包名和一些依赖源信息。

```
$ cat Package.swift 
// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "MyProject"
)

```

下面我们来编译这个新生成的原始项目:

```
$ swift build
Compile Swift Module 'MyProject' (1 sources)
Linking ./.build/debug/MyProject
```

`swift build`命令读取`Package.swift`文件，检查被获取指定的依赖源，然后使用`swiftc`编译每一个`.swift`文件，把它们转化成为模块。最后使用链接器把编译的各个`.swiftmodule`模块文件链接成一个可执行文件，并存放在目录`.build/debug/`目录下面。下面我们运行一下生成的可执行文件：

```
$ .build/debug/MyProject
Hello, world!
```

上面的编译过程我们使用的`Debug`模式，这是默认行为。当然，我们也可以使用`Release`模式来进行编译，优化可执行文件的执行性能：

```
$ swift build --configuration release
Compile Swift Module 'MyProject' (1 sources)
Linking ./.build/release/MyProject
```

`Package.swift`文件描述了整个项目以及怎么构建它。注意，这里并不有像`Gradle`一样使用另一种语言来描述编译过程，而是统一使用`swift`来描述。你还可以使用`if`语句来根据不同的平台获取不同的依赖源：

```
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif
```

系统的环境变量也会影响到编译过程，例如，你可以在执行代码块前先检查现有的环境变量：

```
import Foundation
let env = ProcessInfo.processInfo.environment
if env["MY_SYSTEM_ENV"] == "true" { ... }
```

## 给项目导入库

一些`Swift`项目的样板建立之后，就可以往里面添加一些新的依赖了。例如添加一个运算符(`|>`)支持，这可以在[`IBM Swift Package Catalog`](https://packagecatalog.com)上去查找。

![IBM-Swift-Package-Catalog](/swift/swift-on-server/images/ibm-swift-package-catalog.png)


编辑后的`Package.swift`文件内容如下:

```
// swift-tools-version:3.1

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

import PackageDescription

let package = Package(
    name: "MyProject",
    dependencies: [
    .Package(url: "https://github.com/IBM-Swift/Pipes", majorVersion: 0, minor: 1),
    ]
)

import Foundation
let env = ProcessInfo.processInfo.environment
if env["MY_SYSTEM_ENV"] == "true" { }
```

编译后：
```
$ swift build
Fetching https://github.com/IBM-Swift/Pipes
Cloning https://github.com/IBM-Swift/Pipes
Resolving https://github.com/IBM-Swift/Pipes at 0.1.2
Compile Swift Module 'Pipes' (1 sources)
Compile Swift Module 'MyProject' (1 sources)
Linking ./.build/x86_64-apple-macosx10.10/debug/MyProject
```

可以看到，依赖源已经被下载并能正常参加编译过程。

`Package.swift`的依赖定义可以使用任何Git仓库，可以是本地仓库、私有仓库或者GitHub上托管的仓库。可以使用`file`、`https`或者`ssh`协议来指定仓库链接。

版本号的指定也有多种方式可选，整理如下：

指定版本方式|代码
:----------|-----------
版本范围| Version(0, 1, 0) ..< Version(0, 2, 0)
只指定主版本号| majorVersion: 0
主副版本号| majorVersion: 0,  minor: 1
指定三级版本号| Version(0, 1, 0)
版本字符串| 0.1.0

在项目开发中，建议锁定依赖源的主副版本号，虽然，理论上讲，副版本号不同，并不会影响到编译，但为了确保编译，还是不要只锁定主版本号。

既然已经成功添加了依赖，我们就可以写代码使用它了。修改`main.swift`:

```
import Pipes
func sayHello(str: String) -> String {
    print("Hello, \(str)")
    return ("Hello, \(str)")
}

"Alice" |> sayHello
```
```
$ swift build
$ .build/debug/MyProject
Hello, Alice
```

关于包管理的其它有用命令:

  命令 | 作用   
---|---
swift package fetch | 只获取包依赖
swift package update | 只更新包依赖



## 用XCode开发

当然你可以使用喜欢的编辑器在Shell下进行Swift开发，但在macOS上，还是使用XCode进行开发比较舒服。

可以使用命令生成XCode工程，然后使用XCode打开：

```
$ swift package generate-xcodeproj
generated: ./MyProject.xcodeproj
$ open -a Xcode MyProject.xcodeproj/
```

**注意**

使用命令生成的xcode工程文件，在下次重新生成时，所有对工程文件作过的手动修改都不会被保留。

在XCode中运行前，要修改一下运行方案：

![run-in-xcode](/swift/swift-on-server/images/run-in-xcode.png)

![run-in-xcode-result](/swift/swift-on-server/images/run-in-xcode-result.png)

## 创建自己的库

```
$ mkdir Pipes
$ cd Pipes/
$ swift package init --type library
Creating library package: Pipes
Creating Package.swift
Creating README.md
Creating .gitignore
Creating Sources/
Creating Sources/Pipes/Pipes.swift
Creating Tests/
Creating Tests/LinuxMain.swift
Creating Tests/PipesTests/
Creating Tests/PipesTests/PipesTests.swift
$ tree .
.
├── Package.swift
├── README.md
├── Sources
│   └── Pipes
│       └── Pipes.swift
└── Tests
    ├── LinuxMain.swift
    └── PipesTests
        └── PipesTests.swift

4 directories, 5 files
```

这次，它没有生成`main.swift`文件，而是生在了`Pipes.swift`文件作为模块。这次生成的`Tests/`目录下面有一些基本的测试用例。

修改`Sources/Pipes/Pipes.swift`文件如下：

```
precedencegroup LeftFunctionalApply {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

// pipe val into monadic fn
infix operator |> : LeftFunctionalApply

// pipe val into monadic fn
@discardableResult
public func |>  <A, B> ( x: A, f: (A) throws -> B ) rethrows  -> B {
    return try f(x)
}
```


没有经过测试的库是合格的，所以我们添加一些测试代码，修改文件`Tests/PipesTests/PipesTests.swift`:

```
import XCTest
@testable import Pipes

func double(a: Int) -> Int { return 2 * a } 

class PipesTests: XCTestCase {
    
    func testDouble() { XCTAssertEqual( 6 |> double, 12) }

    static var allTests = [ 
        ("testDouble", testDouble),
    ]   
}
```

这里的`allTests`变更在XCode中执行测试时是不需要的，但使用命令行执行测试时是必需的。

我们使用命令行来执行测试:

```
$ swift build
$ swift test
Test Suite 'All tests' started at 2017-09-07 15:46:37.139
Test Suite 'PipesPackageTests.xctest' started at 2017-09-07 15:46:37.139
Test Suite 'PipesTests' started at 2017-09-07 15:46:37.139
Test Case '-[PipesTests.PipesTests testDouble]' started.
Test Case '-[PipesTests.PipesTests testDouble]' passed (0.086 seconds).
Test Suite 'PipesTests' passed at 2017-09-07 15:46:37.226.
	 Executed 1 test, with 0 failures (0 unexpected) in 0.086 (0.087) seconds
Test Suite 'PipesPackageTests.xctest' passed at 2017-09-07 15:46:37.226.
	 Executed 1 test, with 0 failures (0 unexpected) in 0.086 (0.087) seconds
Test Suite 'All tests' passed at 2017-09-07 15:46:37.226.
	 Executed 1 test, with 0 failures (0 unexpected) in 0.086 (0.087) seconds
```

这只是一个例子，现在我们已经有了自己的库，但是我们只是可以在自己的电脑上使用，如何分享给其它人用呢？

## 共享你的库给swift社区

现在你已经创建了一个库，并做了必要的测试，下一步就是创建一个git仓库并把它托管。可以使用`GitHub`的服务

先初始化本地仓库

```
$ git init
Initialized empty Git repository in /Users/JokerAtBaoFeng/Desktop/playgound/Pipes/.git/
```

并创建首次提交：

```
$ git add .
$ git commit -m 'Init release'
[master (root-commit) fc2df1d] Init release
 6 files changed, 68 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 Package.swift
 create mode 100644 README.md
 create mode 100644 Sources/Pipes/Pipes.swift
 create mode 100644 Tests/LinuxMain.swift
 create mode 100644 Tests/PipesTests/PipesTests.swift
```

添加本地仓库和远程仓库的联系，这一步需要你自己先在GitHub上申请帐号并创建一个空仓库：

```
$ git remote add origin https://github.com/<your-account>/Pipes.git
```

下一步就打一个tag版本，让其它人使用版本号在它们项目的`Package.swift`中指定依赖源：

```
$ git tag 0.1.0
```


最后把本地的仓库推到远程托管的仓库中供别人使用：

```
$ git push -u origin master --tags
```

分享自己的库时，记得在库中包含一些许可证文件，源文件头部可以包含一些版权声明，还要包含一个`README.md`文件，用来说明库的使用方式和注意事项。

**注意**

当一个项目中添加了同一个依赖源的不同版本时，会造成依赖冲突并使链接器失败。


## 生成更加复杂的项目

复杂的`Swift`项目通常包含多个模块，每个模块都可以包含在`Sources`目录下的不同子目录中，由于模块内部还可以依赖其它的模块，编译过程必须按照一定的逻辑顺序进行。如果A依赖B，那么B就需要先被编译，`SwiftPM`会计算这些编译顺序，但依赖关系需要我们自己指定。

这个过程和Linux上的`Makefile`中的指定依赖的方式有点类似，假设你的`Sources`目录下包含下面的模块：

模块|依赖
---|---
Sources/A/main.swift| 依赖B
Sources/B/WebController.swift| 依赖C
Sources/C/DatabaseConnector.swift|


这种关系在`Package.swift`文件中表示为:

```
import PackageDescription

let package = Package(
	name: "MyWebApp",
	targets: [
		Target(name: "A", dependencies: [.Target(name: "B")]),
		Target(name: "B", dependencies: [.Target(name: "C")]),
		Target(name: "C")
	]
)
```

有了这些依赖描述信息，`SwiftPM`就会确保模块C被最先编译，然后编译B，最后编译A。

现在我们一个项目里包含多个模块，如果这些模块可以被其它人复用，就把它们提出来单独建仓库。


## 使用C动态库

`Swift`包可以使用现存的C语言库。使用C库前需要创建`system module`包来绑定C语言动态库。

```
$ mkdir cdylib
$ cd cdylib
$ swift package init --type system-module
Creating system-module package: cdylib
Creating Package.swift
Creating README.md
Creating .gitignore
Creating module.modulemap
```


在生成的`module.modulemap`文件中我们可以指定要使用的C语言库的头文件和动态库文件路径。头文件路径必须是绝对路径。链接参数是动态库的名字。

例如：

```
module CSQLite [system] {
	header "/usr/local/opt/sqlite/include/sqlite3.h"
	link sqlite3
	export *
}
```

当把这个系统模块包含进项目中后，`Swift`会自己读取指定的头文件，并自动生成必要的代码，用来在`Swift`中调用C语言代码。

`SwiftPM`不会自动安装C语言库，因为这种操作需要超级用户权限。当前`SwiftPM`仅支持`Homebrew`和`APT`这两类包管理指定。如下：

```
let package = Package { 
	name: "CSQlite",
	providers: [
		.Brew("sqlite"),
		.Apt("libsqlite3.dev")	
	]
}
```



