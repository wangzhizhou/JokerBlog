上一章，把我们的应用转变成一个服务并部署在了单节点机群上，单节点机群使用多个进程模拟机群。

这一章我们将把应用部署在多物理机器组成的机群上。多容器多机器应用可以放在被`Docker`化的机群上，即`swarm`。

# 理解`Swarm`机群

`Swarm`是运行`Docker`并组成集群的一组机器。你可以像在一台机器上运行`Docker`命令，但实际上，它会通过`Swarm Manager`在整个机群上运行。`Swarm`机群中的机器可以是虚拟的也可以是物理的，当它们加入`Swarm`机群后，被称作`节点`。

`Swarm`管理器可以使用多种策略来运行容器，`空结点`是指那些运行最不常用容器的机器。`全局`策略会确保每一台机器只运行一个指定的容器实例。你在`docker-compose.yml`中指示`swarm`机群使用哪一种策略。

`Swarm`管理是机群中唯一的一台允许你执行命令或授权其它机器作为工作者加入机群的角色。工作者只提供处理能力，不能指挥其它机器。

目前为止，我们的操作都是在单主机环境下进行的。但是`Docker`可以转换成`机群`模式，转换为`机群`模式会把当前的机器变成`Swarm Manager`。至此，`Docker`运行的命令会作用在所管理的机群所有机器上，而不仅仅只在当前机器上执行。

# 建立你的Swarm机群

一个`Swarm`机群由多个节点组成，这些节点可以是虚拟的也可以是物理的。

运行`docker swarm init`开启`swarm`模式，并把当前的机器变为`swarm manager`。

使用`docker swarm join`来使其它的机器作为工作者加入到`Swarm`机群中，创建机群需要多个机器，我们可以使用虚拟机来创建多个虚拟的机器。

# 创建机群

安装[`Virtual Box`](https://www.virtualbox.org/wiki/Downloads)

**注意**：如果你是`Windows 10`系统，它自带的Hyper-V就可以创建虚拟机，所以不需要安装`Virtual Box`。

安装完`Virtual Box`后，使用`docker-machine`来创建多个虚拟机：

```
$ docker-machine create --driver virtualbox myvm1
$ docker-machine craete --driver virtualbox myvm2
```

你现在创建了两个虚拟机了，可以使用命令`docker-machine ls`来查看。第一个会指定为`manager`，第二个会被受权加入机群，成为工作者。

```
$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
myvm1   -        virtualbox   Running   tcp://192.168.99.100:2376           v17.06.0-ce   
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v17.06.0-ce   
```

可以使用`docker-machine ssh`来登录`myvm1`，并使其成为一个`Swarm Manager`：

```
$ docker-machine ssh myvm1 "docker swarm init"
Error response from daemon: could not choose an IP address to advertise since this system has multiple addresses on different interfaces (10.0.2.15 on eth0 and 192.168.99.100 on eth1) - specify one with --advertise-addr
exit status 1
```

如果碰到需要使用`--advertise-addr`的错误，可以使用`docker-machine ls`先查看`myvm1`的IP地址，再使用命令运行一次，但是我们需要使用端口`2377`，因为`swarm join`使用这个端口工作：
 
```
$ docker-machine ssh myvm1 "docker swarm init --advertise-addr 192.168.99.100:2377"
Swarm initialized: current node (7z8gne0xkr4nixklkx8t1sb3g) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-5t4tfzrmtnw9prl7fcpcwpgp924vvntg03urytnw1g2c7ou0ej-6thxazc7buydklnmyi1idr1rv 192.168.99.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```


`docker swarm init`会输出一段用来加入机群的指令，你可以复制这段指令并在想加入的机器上运行就可以把机器转化成工作者了。

```
$ docker-machine ssh myvm2 "docker swarm join --token SWMTKN-1-5t4tfzrmtnw9prl7fcpcwpgp924vvntg03urytnw1g2c7ou0ej-6thxazc7buydklnmyi1idr1rv 192.168.99.100:2377"
This node joined a swarm as a worker.
```

恭喜你，已经创建了你的第一个机群了。

直接使用`docker-machine ssh myvm1`这种方式会登录机器，需要使用`exit`来登出

而使用`docker-machine ssh myvm1 "command"`这种方法会登录机器后执行命令，并自动登出。

# 在机群上部署你的应用

最难的部分过去了，现在只需要重复在上一章已经做过的流程来就可以了。只需要记住`myvm1`是`Swarm Manager`可以执行指令，其它的是工作者，只处理事务。

把我们之前创建的`docker-compose.yml`文件拷到`myvm1`这个`swarm manager`上：

```
$ docker-machine scp docker-compose.yml myvm1:~
docker-compose.yml                                                                    100%  368   333.7KB/s   00:00 
```

然后开始部署我们的应用到机群上：

```
$ docker-machine ssh myvm1 "docker stack deploy -c docker-compose.yml hello"
Creating network hello_webnet
Creating service hello_web
```

查看部署情况：

```
$ docker-machine ssh myvm1 "docker stack ps hello"
ID                  NAME                IMAGE                      NODE                DESIRED STATE       CURRENT STATE                  ERROR               PORTS
fla301e97hse        hello_web.1         zhulongyixian/hello:v1.0   myvm2               Running             Preparing about a minute ago                       
jhp43be5v3op        hello_web.2         zhulongyixian/hello:v1.0   myvm1               Running             Preparing about a minute ago                       
k58kkikey222        hello_web.3         zhulongyixian/hello:v1.0   myvm2               Running             Preparing about a minute ago                       
85gtwdojwots        hello_web.4         zhulongyixian/hello:v1.0   myvm1               Running             Preparing about a minute ago   
```

可以看到应用已经被部署到机群上了。

# 访问你的机群

你可以通过`myvm1`或者`myvm2`的IP地址来访问我们已经部署的应用。因为我们创建了在机群机器间共享的网络层，用来平衡负载。

使用`docker-machine ls`查看机器的IP地址：

```
$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
myvm1   -        virtualbox   Running   tcp://192.168.99.100:2376           v17.06.0-ce   
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v17.06.0-ce
```

在浏览器中打开:<http://192.168.99.100>就可以访问服务了。多刷新几次浏览器，会发现容器ID会不停的变化，说明我们的机群可以处理负载平衡。

我们可以通过机群内任意一个节点的IP来访问服务的原因是我们的机群设置了路由网。这可以使部署的服务在机群内部有指定端口，不用关心容器是如果被执行的。下面是一张三节点机群图用来说明发布在`8080`端口的`my-web`服务的内部网络结构：

![ingress network](/docker/image/ingress.png)

**可能遇到的连接问题**: 为了使用`Swarm`机群，我们在开启`Swarm`模式前要确保节点之间的以下端口是打开的：

- `7946` TCP/UDP端口，这个端口用于网络发现
- `4789` UDP端口，这个端口用于容器的ingress网络


# 扩展你的应用

你可以像第三章学到的那样，通过改变`docker-compose.yml`中的设置并重新运行命令`docker stack deploy -c docker-compose.yml hello`来改变部署的方式。也可以使用命令`docker swarm join`命令来加入更多的工作者节点，然后使用前面的命令更新部署一次。

# 清理工作

可以使用下面的命令停止应用栈的运行：

```
$ docker-machine ssh myvm1 "docker stack rm hello"
Removing service hello_web
Removing network hello_webnet
```

这只是移除了机群上的应用，但机群本身还在运行。

可以使用下面的命令关闭机群：

```
$ docker-machine ssh myvm2 "docker swarm leave"
Node left the swarm. # 工作者节点离开机群

$ docker-machine ssh myvm1 "docker swarm leave --force"
Node left the swarm. # 机群管理节点离开机群
```


# 常用到的指令列表

```
docker-machine create --driver virtualbox myvm1 # Create a VM (Mac, Win7, Linux)
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1 # Win10
docker-machine env myvm1                # View basic information about your node
docker-machine ssh myvm1 "docker node ls"         # List the nodes in your swarm
docker-machine ssh myvm1 "docker node inspect <node ID>"        # Inspect a node
docker-machine ssh myvm1 "docker swarm join-token -q worker"   # View join token
docker-machine ssh myvm1   # Open an SSH session with the VM; type "exit" to end
docker-machine ssh myvm2 "docker swarm leave"  # Make the worker leave the swarm
docker-machine ssh myvm1 "docker swarm leave -f" # Make master leave, kill swarm
docker-machine start myvm1            # Start a VM that is currently not running
docker-machine stop $(docker-machine ls -q)               # Stop all running VMs
docker-machine rm $(docker-machine ls -q) # Delete all VMs and their disk images
docker-machine scp docker-compose.yml myvm1:~     # Copy file to node's home dir
docker-machine ssh myvm1 "docker stack deploy -c <file> <app>"   # Deploy an app
```






