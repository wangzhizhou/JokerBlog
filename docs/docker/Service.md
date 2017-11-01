这部分，我们扩展我们的应用，并使其负载平衡。这样我们就要上升到服务层来进行讨论。

- 栈
- 服务(目前我们在这里)
- 容器


# 理解什么是服务

在分布式应用中，应用的不同部分被称为服务。例如，假设有一个视频分享网站，它可能会包含视频存储、视频转码、前端等服务。

服务即是在生产环境中的容器。一个服务只运行一个镜像，但是它会规定这个镜像运行的方式：使用哪个端口、运行多少重复容器实例来达到需要的服务能力等等。扩展服务改变运行应用的容器实例个数会给运行在进程中的服务更多的计算资源。

值得庆幸的是，在`Docker`上，想要定义、运行、扩展服务，只需要编写`docker-compose.yml`文件。

# 第一个docker-compose.yml文件

`docker-compose.yml`是一个`YAML`格式的文件，它定义了`Docker`容器在生产环境下应该怎样的表现自己。

创建一个`docker-compose.yml`文件，放在任何你想放的位置，前提是你已经把之前创建好的镜像上传到了登记处，因为我们会在文件中引用这个上传的镜像。

```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image:zhulongyixian/hello:v1.0
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "80:80"
    networks:
      - webnet
networks:
  webnet:
```

这个文件告诉`Docker`做以下一些事情：

- 拉取我们前面上传到登记处的镜像
- 运行五个镜像实例做为服务，并把服务命名为`web`，并为每一个实例分配资源上限，最多`10%`的CPU使用和`50MB`的内存
- 如果有一个容器不能运行就立即重启
- 映射容器端口80到宿主机端口80
- 指定所有容器通过名为`webnet`的负载平衡网络来共享端口80
- 用默认设置来定义`webnet`负载均衡网络


## 对`Docker-compose.yml`文件的版本、名字、指令感到好奇吗？

`version: "3"`会使机群模式生效，在这个版本下，我们可以使用`deploy key`和它的一些子选项来对服务进行负载平衡和性能优化。而这些功能只有在版本是3.x时才能使用。使用命令`docker stack deploy`来部署机群。在不使用机群配置的情况下，我们可以使用命令`docker-compose`。

`docekr-compose.yml`这个文件名字可以随便取，只要你自己明白它存在的意义就可以了。`docker-compose.yml`只是一个惯用的名字。

# 运行带有负载平衡的应用

在我们使用`docker stack deploy`命令之前，我们需要先运行：

```
docker swarm init
```

这个命令的意义会在下一章解释

现在我们来运行命令:

```
docker stack deploy -c docker-compose.yml hello
```

使用下面的命令查看我们运行起来的五个容器:

```
$ docker stack ps hello
ID                  NAME                IMAGE                      NODE                DESIRED STATE       CURRENT STATE                    ERROR               PORTS
mdx4cjuphpgu        hello_web.1         zhulongyixian/hello:v1.0   moby                Running             Running 33 seconds ago                               
0nuenxnduonl        hello_web.2         zhulongyixian/hello:v1.0   moby                Running             Running 33 seconds ago                               
7wv949rmcgl1        hello_web.3         zhulongyixian/hello:v1.0   moby                Running             Running 33 seconds ago                               
o09klm7wj1fl        hello_web.4         zhulongyixian/hello:v1.0   moby                Running             Running less than a second ago                       
w9xxpso8jpy3        hello_web.5         zhulongyixian/hello:v1.0   moby                Running             Running 33 seconds ago       
```



我们之后请求服务时，会随机的访问五个容器中的其中一个，这样就可以在用户比较多时，负载平衡。我们可以尝试用`curl http://localhost`来多次请求服务，或者在浏览器里多次刷新看看，每次请求回的容器ID是不是五个容器中的一个。

**注意**：目前我们的服务响应一个HTTP请求可能会花费30秒，这不能表现`Docker`或`Swarm`的性能，这是因为我们还没有建立起应用的`Redis`依赖，这部分我们会在后面进行补充。


# 扩展应用

你可以通过修改`docker-compose.yml`文件中的`replicas`来扩展你的应用，修改后保存文件，并重新执行一次下面的命令：

`docker stack deploy -c docker-compose.yml hello`

`Docker`会在原来的基础上做一次更新，不需要关闭原来的服务再重来一次。


现在我们可以使用`docker stack ps hello`来查看一下修改后的容器实例有多少个。

我把`replicas`改为`4`后执行了一次，如下：

```
$ docker stack deploy -c docker-compose.yml hello
Updating service hello_web (id: 6mgnwcgu02lxfx9flyiv40gme)

$ docker stack ps hello
ID                  NAME                IMAGE                      NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
mdx4cjuphpgu        hello_web.1         zhulongyixian/hello:v1.0   moby                Running             Running about a minute ago                       
0nuenxnduonl        hello_web.2         zhulongyixian/hello:v1.0   moby                Running             Running about a minute ago                       
7wv949rmcgl1        hello_web.3         zhulongyixian/hello:v1.0   moby                Running             Running about a minute ago                       
w9xxpso8jpy3        hello_web.5         zhulongyixian/hello:v1.0   moby                Running             Running about a minute ago                 
```


# 关闭应用和机群

`docker stack rm hello`这个命令可以移除我们的应用，但是我们的单节点机群(即宿主机)仍然会运行，可以使用`docker node ls`来查看。

关闭机群的命令如下：

```
docker swarm leave --force
```

之后的内容我们会尝试在真正的`Docker`机群上部署我们的服务。

**注意**：我们定义的`docker-compose.yml`文件可以上传到`Docker 云`提供商，或者任何其它支持`Docker`企业版的硬件上。


```
$ docker stack rm hello
Removing service hello_web
Removing network hello_webnet

$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
n0wlb32a7qwudl9p7u5wh9gx7 *   moby                Ready               Active              Leader

$ docker swarm leave --force
Node left the swarm.
```

# 一些常用的命令

```
docker stack ls              # List all running applications on this Docker host
docker stack deploy -c <composefile> <appname>  # Run the specified Compose file
docker stack services <appname>       # List the services associated with an app
docker stack ps <appname>   # List the running containers associated with an app
docker stack rm <appname>                             # Tear down an application
```

