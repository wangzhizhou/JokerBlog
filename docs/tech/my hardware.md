# 花生壳动态域名

**zhulongyixian.vicp.cc**

## 路由器端口映射

### Raspberry Pi 3 Model B+

- Host IP: 192.168.0.200
	- SSH Port: 22 -> 22
	- HTTP Port: 80 -> 8000
	- HTTPs Port: 5000 -> 443
	- Gogs Port: 3000 -> 30237

### USB-Armory inversePath 

- Host IP: 192.168.0.202
	- SSH Port: 22 -> 8004

#### MacBook Pro (Retina, 13-inch, Early 2015)

- Host IP: 192.168.0.201
	- SSH Port: 22 -> 8001
	- HTTP Port: 80 -> 8002
	- Gogs Port: 3000 -> 8003

### 魅蓝Note 2

- Host IP: 192.168.0.203
	- SSH Port: 22 -> 8005


### SSH config file

```
SG9zdCBtYwogIEhvc3ROYW1lIHd3dy5vb2Jienlvby5jb20KICBVc2VyIGpva2VyCgpIb3N0IGthbGkKCUhvc3ROYW1lIHpodWxvbmd5aXhpYW4udmljcC5jYwoJVXNlciByb290CiAgICBQb3J0IDgwMDQKCkhvc3QgcGhvbmUKICAgIEhvc3ROYW1lIHpodWxvbmd5aXhpYW4udmljcC5jYwogICAgVXNlciBhbmRyb2lkCiAgICBQb3J0IDgwMDUKCkhvc3QgcGkKICAgIEhvc3ROYW1lIHpodWxvbmd5aXhpYW4udmljcC5jYwogICAgVXNlciBwaQo=
```

