# issue 1

## 现象

当启动`jupyterhub`时出现错误：

```
Uncaught Exception Error: listen EADDRINUSE :::8000
```

## 原因

同时开了两个应用，但是只关掉了其中一个，另一个还在侦听端口

## 解决：

```
$　pkill node
```

## docker image

```
$ docker run -d --name jupyterhub zhulongyixian/jupyterhub jupyterhub
```