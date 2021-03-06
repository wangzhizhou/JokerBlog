`Jenkins`是一个开源独立的自动化服务器，它可以用来完成诸如软件构建、软件测试和软件部署在内的各种类型任务的自动化。可以通过本机系统包或Docker的方式安装，也可以独立运行于所有安装了Java运行环境的机器中。

 这份导览使用独立版本的`Jenkins`，最低需要`java 7`并且系统至少要有`512MB`的内存。
 
 1. [下载`Jenkins`](http://mirrors.jenkins.io/war-stable/latest/jenkins.war)
 2. 打开终端并进入下载文件所在的目录，运行命令`java -jar jenkins.war`
 3. 浏览器进入`http://localhost:8080`按照提示完成安装。
 4. 一些管道使用的示例要求同时安装`Jenkins`和`Docker`。

 安装完成后，准备开始使用`Jenkins`并创建管道。
 
 `Jenkins`的管道是一套插件，它们支持在`Jenkins`内部实现和整合连续交付流程。管道是一个有扩展性的工具集，用来把简单/复杂的交付流程以代码的方式建模出来。
 
`Jenkinsfile`文件中包含`Jenkins`管道定义，并被加入到版本控制中。它是管道代码化的基础，像其它代码一样，我们可以把持续交付流程看作是应用的一部分来进行版本控制和审查。创建`Jenkinsfile`有很多好处：

* 为所有分支和`pull`请求自动创建管道
* 在管道上进行代码审查和迭代
* 为管道进行审计跟踪
* 统一的可信任源代码方便多个项目成员之间共同编辑。

通过`web UI`或者`Jenkinsfile`都可以以相同的语法定义管道。通常以`Jenkinsfile`的方式定义管道并加入到版本控制中是最好的方式。

