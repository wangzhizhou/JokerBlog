在上一章学会了建立`Swarm`集群，即运行着`Docker`的一簇机器。

这一章中，我们会在最高的层次上：`应用栈`。栈是一组相互关联并共享依赖的服务，可以编制在一起。一个单栈就可以定义和操作整个应用的功能，但是有些复杂的应用会使用多栈。

从第三章我们就使用过栈，那时我们使用了`docker stack deploy`。但那是一个运行在单主机上的单服务栈，不是生产环境中的一般情况。在这章中，你要把多个服务关联起来，并运行在多个机器上。

# 添加一个新服务并重新部署

在`docker-compose.yml`中添加服务是很容易的事，首先我们添加一个免费的可视化服务，这样我们就可以看到我们的`Swarm`机群中的容器的调度情况了。

### 第一步

 编辑器打开`docker-compose.yml`文件，修改内容如下：
 
```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: zhulongyixian/hello:v1.0
    deploy:
      replicas: 5
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
    ports:
      - "80:80"
    networks:
      - webnet
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - webnet
networks:
  webnet:
```
唯一的改动就是和`web`服务并列，多加了一个`visualizer`服务，你会看到两个新的东西：`volumes`，允许服务访问主机的`socket`文件。`placement`确保服务只在`swarm`机群的管理节点上运行。这个新添加的服务是`docker`开发的开源项目，用来以图形的方式显示`Docker`服务的运行情况。

### 第二步

把新修改的`docker-compose.yml`文件复制到我们的`swarm`管理节点上，即`myvm1`：

```
docker-machine scp docker-comopose.yml myvm1:~
```

### 第三步

重新在管理节点上运行`docker stack deploy`命令，来更新更新的服务：

```
$ docker-machine ssh myvm1 "docker stack deploy -c docker-compose.yml hello"
```
### 第四步

查看这个新添加的可视化服务

```
$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
myvm1   -        virtualbox   Running   tcp://192.168.99.100:2376           v17.06.0-ce   
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v17.06.0-ce
```

然后浏览器访问: <http://192.168.99.100:8080>或者<http://192.168.99.101:8080>

![visualizer](/docker/image/visualizer.png)


从图中看出这个`visualizer`运行在管理节点上，其它五个`web`服务的实例分布在`swarm`机群的机器上面。可以通过运行指令来确认:

```
$ docker-machine ssh myvm1 "docker stack ps hello"
```

`visualizer`是一个独立的服务，它可以运行在任何其他的应用栈中。它不依赖于其它东西。现在我们来创建一个有`Redis`依赖的服务，用来提访客计数功能。


# 固化数据

我们再过一遍流程，这种我们添加`Redis`数据库来存储应用数据。

### 第一步

修改`docker-compose.yml`文件，这次添加`redis`服务

```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: username/repo:tag
    deploy:
      replicas: 5
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
    ports:
      - "80:80"
    networks:
      - webnet
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - webnet
  redis:
    image: redis
    ports:
      - "6379:6379"
    volumes:
      - ./data:/data
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - webnet
networks:
  webnet:
```
`Redis`有一个官方`docker`镜像，使用`image: redis`键值对指定，所以这里没有`username/repo:tag`这样的行出现。`Redis`端口是`6379`，已经被预先配置为容器端口暴露给主机。

最重要的是，后面的配置中有一些`redis`相关的指定：

- `redis`总是运行在管理节点上，因些它总是使用与管理节点相同的文件系统。
- `redis`在容器内部访问宿主机的任何目录都是通过`/data`，这个目录也是`redis`存放数据的地方。

这些特别配置，使的存放在物理文件系统的中数据变成可信源，`Redis`往`/data`目录存入数据就是存入到物理机的文件系统中，这可以避免在重新部署容器时数据丢失的问题。

可信源有两个元素：
- `placement`限制`redis`服务运行在管理节点上，确保它始终使用同一个主机。
- `volume`指定容器内部访问`./data`目录相当于访问宿主机目录`/data`，在容器运行起来后，生成的数据会固化存在指定主机上

### 第二步

在管理节点上创建`./data`目录

```
$ docker-machine ssh myvm1 "mkdir ./data"
```

### 第三步

拷贝`docker-compose.yml`文件到管理节点:

```
$ docker-machine scp docker-compose.yml myvm1:~
```

### 第四步

运行`docker stack deploy`命令：

```
$ docker-machine ssh myvm1 "docker stack deploy -c docker-compose.yml hello"
```

### 第五步

查看服务<http://192.168.99.100>，这次你就会看到访问计数了。这个计数存放在`redis`中。

![redis-count](/docker/image/redis-count.png)

再查看一个`visualizer`服务，你会看到`redis`服务和`web`、`visualizer`服务同时运行。

![visualizer-redis](/docker/image/visualizer-redis.png)







