# 开发

这篇介绍使用`Swfit`语言构建一个简单的`Web`服务，它在数据库中存放待办事项，客户端可以通过`RESTful`接口访问。

这里使用`IBM Kitura`Web开发框架，它与已有的Web框架如：Ruby的Sinatra、Python的Flask以及NodeJS的Express.js很类似。

Kitura包含一个HTTP服务器，可以用来侦听来自客户端的请求，并把这些请求路由给合适的处理程序处理。

要想处理客户请求，我们的项目在使用`SwiftPM`导入`Kitura`模块后，需要先创建一个`Router`, 用来接收客户请求并路由到指定的处理程序中。

```
import Kitura

let router = Router()
```

但是在我们可以处理客户请求之前，需要先启动一个HTTP服务器来侦听客户请求，这里我们启动了一个在TCP端口8000上侦听客户请求的HTTP服务器，并把它注册给上面我们创建的`router`：

```
Kitura.addHTTPServer(onPort:8000, with: router)

Kitura.run()
```

**注意** - 
`Kitura`运行时支持同时开启多个HTTP服务器，它们可以在不同的端口上侦听客户请求，当然为了安全的话，也可以创建HTTPS服务器来代替HTTP服务器。

当服务器接到一个客户请求后，`Kitura`会创建一个线程用来执行针对这个客户请求的处理程序。

请求处理程序可以用一个闭包来定义，它有三个类型分别为：`RouterRequest`、`RouterResponse`和 `() -> Void`的参数。

- `RouterRequest`包含客户端请求的相关信息，其中可能有包含用户身份认证的请求头信息或者包含其它相关数据。
- `RouterResponse`包含服务端要返回给客户端的相关信息。
- `() -> Void`是服务端用于处理指定客户请求的处理程序，它也是一个闭包，可以自定义名称。

下面就创建一个可以处理来自主机路径`/hello`的GET请求，并返回`Hello, World`给客户的路由：

```
router.get("/hello"){ request, response, callNextHandler in 
    response.status(.OK).send("Hello, World!")
    callNextHandler()
}
```

**注意** -
路径`/hello`中也可以指定正则表达式，用来匹配一系列指定的用户请求，其中以`:`开始的标识符可以做为参数传递给请求处理程序，例如：路径`/user/:name`可以匹配一个`user/robert`这样的用户请求，`:name`这个标识符就匹配了具体的`robert`，在请求处理程序中，可以通过`request.parameters["name"]`来获得`:name`匹配的具体值。



一个请求处理程序在处理完用户讲求时必须调用`callNextHandler()`或者`response.end()`来表示请求处理完成，否则客户端会一直等待服务端响应。


以上就是最简单的一个Web服务，全部代码如下：

```
import Kitura

let router = Router()

router.get("/hello"){ request, response, callNextHandler in 
    response.status(.OK).send("Hello, World!\n")
    callNextHandler()
}

Kitura.addHTTPServer(onPort:8000, with: router)

Kitura.run()
```

运行后，使用命令行工具`curl`来模拟客户请求测试服务是否正确：

```
$ curl localhost:8000/hello
Hello, World!
```

# 布署

开发完成的Web服务可以通过`Docker`来布署，也可以使用`IBM Cloud Tools for Swift`来布署到`IBM Bluemix`上。

因为服务器一般需要命令行操作，所以这里介绍使用服务行部署服务的过程，这里将使用[`IBM Bluemix`](https://www.ibm.com/cloud-computing/bluemix/zh)云服务, 它可以试用30天，需要注册一个帐号并且需要开通`CloudFoundry`应用程序服务。

![ibm-bluemix](/iOS/swift-on-server/images/ibm-bluemix.png)

![ibm-bluemix-cloundFoundry](/iOS/swift-on-server/images/ibm-bluemix-cloudFoundry.png)

可以在相关界面下载CLI命令行工具用来布署应用。

![ibm-bluemix-cli](/iOS/swift-on-server/images/ibm-bluemix-cli.png)


下载并完成`Bluemix-CLI`的安装。


布署前需要创建几个文件，用来指定服务在部署的一些运行参数和信息。


## 创建`manifest.yml`文件

*manifest.yml*
```
applications:
 - name: todolist
   memory: 256M
   instances: 1
   random-route: true
   buildpack: https://github.com/IBM-Swift/Swift-buildpack.git
```

## 创建`Procfile`文件

*Procfile*
```
web: Server
```

## 项目代码中包含部署相关的代码

`Package.swift`文件中添加`Swift-cfenv`包

*Package.swift*
```
// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "todolist",
    dependencies: [
    .Package(url: "https://github.com/IBM-Swift/Kitura", majorVersion: 1, minor: 7),
    .Package(url: "https://github.com/IBM-Swift/Swift-cfenv", majorVersion: 4, minor: 0),
    ]
)
``` 
并在项目代码中包含下面代码： 

```
import CloudFoundryEnv
do { 
	let appEnv = try CloudFoundryEnv.getAppEnv()
	let port: Int = appEnv.port
	Kitura.addHTTPServer(onPort: port, with: router)
} catch CloudFoundryEnvError.InvalidValue {
	print("Oops, something went wrong... Server did not start!")
}
```

# 参考资料

详情请参考IBM出口书籍及相关代码: 

- [Extending Swift Values to the Server](/iOS/swift-on-server/books/KUM12369USEN.pdf)
- [相关代码下载](https://github.com/oreillymedia/extending_swift_values_to_the_server)


