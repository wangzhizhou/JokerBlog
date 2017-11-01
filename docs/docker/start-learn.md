
# 将Docker最新文档拉到本地阅读

- [Docker官网](https://www.docker.com)
- [Docker Hub](https://hub.docker.com)
	- emh1bG9uZ3lpeGlhbjpXdzU0Mzg1OTIzMAo=

```
$ docker run -ti -p 4000:4000 docs/docker.github.io:latest
```

在**<http://localhost:4000>**上查看文档。


欢迎使用`Docker`！在这个六步教程中，你将会学到:

1. 建立基本概念
2. 构建并运行你的第一个应用
3. 把你的应用转换成可扩展服务
4. 把你的服务扩展到多个机器上
5. 添加访客计数
6. 部署集群到生产环境

教程中的应用程序本身不复杂，这样你就不用分心在太多编码细节上。毕竟`Docker`的作用是构建、装载和运行应用程序，不需要关心应用程序具体干什么。


# 基本要求

在我们定义一些概念前，最好我们已经理解了`Docker是什么`以及`为什么我们要使用Docker`。

并且我们需要对一些基础概念有所掌握：
 
 - IP地址和商品
 - 虚拟机
 - 编辑配置文件
 - 熟悉代码依赖和构建
 - 了解机器资源相关的一些术语，像CPU占用率、RAM占用量等

### Docker是什么

`Docker`是世界领先的软件容器平台。

- 开发者使用`Docker`可以避免与其它人合作时碰到机器设备环境配置不同的问题。

- 运维人员使用`Docker`可以整齐的安排各种应用，并且可以通过容器技术做到互相独立、互不影响，从而更好的利用有限的计算资源。

- 企业使用`Docker`可以构建敏捷软件分发管道，将应用新特性更快、更安全的展现给客户，并且不受服务器类型约束。

### 为什么要用Docker


现在的应用平台基于`Docker`和`容器`构建。`Docker`可以作为统一的平台来服务于商业应用、作坊应用或者是微服务。这些应用如果被`Docker`化后，可以变得更敏捷、更安全、更灵活、支持云服务并且可以优化资源消耗。`Docker`可以加速应用从开发者桌面开发环境到生产环境部署这一过程。


 

# Docker加速

由于某些未知原因，你可能需要使用`Docker`加速才能在天朝正常使用相关功能。这可以通过配置`Docker`国内镜像地址。

注册`DaoCloud`帐号，登录后在用户中心使用`Docker`加速器，会有`linux/MacOS/Windows`平台的相应地址。

![DaoCloud](/docker/image/daocloud.png)


复制`Docker`加速镜像地址，并在`Docker Daemon`中进行设置，并重启后就可以加速`docker`服务了


![Docker Daemon](/docker/image/dockerdaemon.png)

