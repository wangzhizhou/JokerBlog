在前面的几节中，我们注意到每个示例中都有`agent`指令，这个`agent`指令告诉`Jenkins`执行管道的位置和时机。所有的管道都必须有`agent`指令。

`agent`这个指令会做下面几件事：

- 块中的所有步骤都被`Jenkins`加入队列，串行执行。只要执行器可用，就开始按步骤一步步执行

- 会创建一个工作空间，用来存放从版本控制仓库中取出的用于管道执行的相关文件 

有很多种方式为管道定义`agent`，但在这个指导中，我们仅使用`Docker`作为`agent`。

管道被设计为可以很方便的在内部使用`Docker`镜像和容器，这使的管道不需要手动配置额外的系统工具和相关依赖就可以定义所需的环境和工具。以这种方式你可以使用打包在`Docker`容器中的任何工具。例如：

```
pipeline {
    agent {
        docker { image 'node:7-alpine' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'node --version'
            }
        }
    }
}
```
当管道执行时，`Jenkins`可以自动的启动`Docker`容器并在容器中执行定义好的步骤, 像下面这样：

```
[Pipeline] {
[Pipeline] stage
[Pipeline] { (node test)
[Pipeline] sh
[My_Pipeline_master-KX7XBL63CQEDQTNZKBOYFV6X2NHL6Y56ZLRMSX6DZ3WJX6IDTRWA] Running shell script
+ node --version
v7.10.1
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
$ docker stop --time=1 6cb12d574c725716c8a556db17883e17a758dd54290fdf5fd7251a8a770ef73c
$ docker rm -f 6cb12d574c725716c8a556db17883e17a758dd54290fdf5fd7251a8a770ef73c
[Pipeline] // withDockerContainer
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS 
```

将`agent`和`Docker`容器进行不同的搭配，可以让管道的执行变的非常的灵活。

