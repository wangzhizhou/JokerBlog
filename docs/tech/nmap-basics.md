# [Nmap](https://nmap.org) Basics

使用nmap有一段时间了，主要是在学习树莓派的过程中接触的，发现这个工具异常强大，是黑客必备的工具软件，不过，作为一般软件工程师的我，也想学习一些基本的操作，以备不时之需。

## **下面记录一些关于namp的常见用法：**

查询本机ip:

```
$ ifconfig en0
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=10b<RXCSUM,TXCSUM,VLAN_HWTAGGING,AV>
	ether 98:5a:eb:ce:ff:c5 
	inet6 fe80::10:d16a:4c30:3acd%en0 prefixlen 64 secured scopeid 0x4 
	inet 192.168.70.83 netmask 0xffffff00 broadcast 192.168.70.255
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect (1000baseT <full-duplex>)
	status: active
```

那么就使用 `192.168.70.83` / `192.168.70.83/24` 这个网络地址进行本机/本地网络扫描

#### 1. 获取远程主机的系统类型和开放端口

`sudo nmap -sS -P0 -sV -O 192.168.70.83`

 * `-sS` 使用 TCP SYN 技术扫描 
 	* s(scan) 
 	* S(SYN)  
 	
 * `-P0` 强制 Nmap 扫描任何地址，不论它是否响应了 ping 
 * `-sV` 探测开放端口提供的服务和版本
 * `-O`  侦测操作系统
 
 
 **Output**
 
```
Starting Nmap 7.12 ( https://nmap.org ) at 2016-12-23 18:51 CST
Nmap scan report for bogon (192.168.70.83)
Host is up (0.000096s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE         VERSION
53/tcp   open  domain?
80/tcp   open  http            Apache httpd 2.4.23 ((Unix))
8888/tcp open  sun-answerbook?
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port8888-TCP:V=7.12%I=7%D=12/23%Time=585D01AC%P=x86_64-apple-darwin15.4
SF:.0%r(GetRequest,3AF,"HTTP/1\.0\x20503\x20Error\r\nServer:\x20Charles\r\
SF:nCache-Control:\x20must-revalidate,no-cache,no-store\r\nContent-Type:\x
SF:20text/html;charset=ISO-8859-1\r\nContent-Length:\x20764\r\nProxy-Conne
SF:ction:\x20Close\r\n\r\n<html>\n<head>\n\x20\x20\x20\x20<title>Charles\x
SF:20Error\x20Report</title>\n\x20\x20\x20\x20<style\x20type=\"text/css\">
SF:\nbody\x20{\n\x20\x20\x20\x20font-family:\x20Arial,Helvetica,Sans-serif
SF:;\n\x20\x20\x20\x20font-size:\x2012px;\n\x20\x20\x20\x20color:\x20#3333
SF:33;\n\x20\x20\x20\x20background-color:\x20#ffffff;\n}\n\nh1\x20{\n\x20\
SF:x20\x20\x20font-size:\x2024px;\n\x20\x20\x20\x20font-weight:\x20bold;\n
SF:}\n\nh2\x20{\n\x20\x20\x20\x20font-size:\x2018px;\n\x20\x20\x20\x20font
SF:-weight:\x20bold;\n}\n\x20\x20\x20\x20</style>\n</head>\n<body>\n\n<h1>
SF:Charles\x20Error\x20Report</h1>\n<h2>Failure</h2>\n<p>Malformed\x20requ
SF:est\x20URL\x20&quot;&#x2F;&quot;\.\x20Consider\x20enabling\x20Transpare
SF:nt\x20proxying\.</p>\n<p>The\x20actual\x20exception\x20reported\x20was:
SF:</p>\n<pre>\ncom\.xk72\.proxy\.ProxyException:\x20Malformed\x20request\
SF:x20URL\x20&quot;&#x2F;&quot;\.\x20Consider\x20enabling\x20Transparent\x
SF:20proxying\.\n</pre>\n\n<p>\n<i>Charles\x20Proxy,\x20<a\x20href=\"http:
SF://www\.charlesproxy\.com/\">http://www\.cha")%r(HTTPOptions,3AF,"HTTP/1
SF:\.0\x20503\x20Error\r\nServer:\x20Charles\r\nCache-Control:\x20must-rev
SF:alidate,no-cache,no-store\r\nContent-Type:\x20text/html;charset=ISO-885
SF:9-1\r\nContent-Length:\x20764\r\nProxy-Connection:\x20Close\r\n\r\n<htm
SF:l>\n<head>\n\x20\x20\x20\x20<title>Charles\x20Error\x20Report</title>\n
SF:\x20\x20\x20\x20<style\x20type=\"text/css\">\nbody\x20{\n\x20\x20\x20\x
SF:20font-family:\x20Arial,Helvetica,Sans-serif;\n\x20\x20\x20\x20font-siz
SF:e:\x2012px;\n\x20\x20\x20\x20color:\x20#333333;\n\x20\x20\x20\x20backgr
SF:ound-color:\x20#ffffff;\n}\n\nh1\x20{\n\x20\x20\x20\x20font-size:\x2024
SF:px;\n\x20\x20\x20\x20font-weight:\x20bold;\n}\n\nh2\x20{\n\x20\x20\x20\
SF:x20font-size:\x2018px;\n\x20\x20\x20\x20font-weight:\x20bold;\n}\n\x20\
SF:x20\x20\x20</style>\n</head>\n<body>\n\n<h1>Charles\x20Error\x20Report<
SF:/h1>\n<h2>Failure</h2>\n<p>Malformed\x20request\x20URL\x20&quot;&#x2F;&
SF:quot;\.\x20Consider\x20enabling\x20Transparent\x20proxying\.</p>\n<p>Th
SF:e\x20actual\x20exception\x20reported\x20was:</p>\n<pre>\ncom\.xk72\.pro
SF:xy\.ProxyException:\x20Malformed\x20request\x20URL\x20&quot;&#x2F;&quot
SF:;\.\x20Consider\x20enabling\x20Transparent\x20proxying\.\n</pre>\n\n<p>
SF:\n<i>Charles\x20Proxy,\x20<a\x20href=\"http://www\.charlesproxy\.com/\"
SF:>http://www\.cha");
Device type: general purpose
Running: Apple Mac OS X 10.10.X|10.11.X
OS CPE: cpe:/o:apple:mac_os_x:10.10 cpe:/o:apple:mac_os_x:10.11
OS details: Apple Mac OS X 10.10 (Yosemite) - 10.11 (El Capitan) (Darwin 14.0.0 - 15.0.0)
Network Distance: 0 hops
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 131.69 seconds
```

#### 2. 列出开放了指定端口的主机列表

`sudo nmap -sT -p 80 -oG - 192.168.70.83/24 | grep open`

* `-sT` 使用 Connect() 技术扫描
* `-p`  指定扫描端口号
* `-oG` 以 Grepable 格式式输出扫描结果
* `grep open` 过滤扫描结果，输出打开的端口相关的信息

 **Output**
 
```
Host: 192.168.70.114 (bogon)	Ports: 80/open/tcp//http///    
Host: 192.168.70.164 ()	Ports: 80/open/tcp//http///    
Host: 192.168.70.83 (bogon)	Ports: 80/open/tcp//http///
```

#### 3. 在网络中寻找所有在线主机

`sudo nmap -sP 192.168.70.83/24`

* `-sP` 对指定 IP 范围内的所有地址进行 ping 扫描，列出响应的主机

**Output**

```
Starting Nmap 7.12 ( https://nmap.org ) at 2016-12-23 19:10 CST
Nmap scan report for bogon (192.168.70.1)
Host is up (0.00016s latency).
MAC Address: 00:13:72:3F:72:F1 (Dell)
Nmap scan report for 192.168.70.29
Host is up (0.00037s latency).
MAC Address: 08:62:66:8A:42:84 (Asustek Computer)
Nmap scan report for bogon (192.168.70.30)
Host is up (0.00038s latency).
MAC Address: C8:60:00:5B:14:33 (Asustek Computer)
Nmap scan report for 192.168.70.32
Host is up (0.00023s latency).
MAC Address: 60:A4:4C:3E:53:71 (Asustek Computer)
Nmap scan report for bogon (192.168.70.35)
Host is up (0.00017s latency).
MAC Address: 08:60:6E:EF:78:7B (Asustek Computer)
Nmap scan report for 192.168.70.78
Host is up (0.00040s latency).
MAC Address: 20:6A:8A:11:DF:C4 (Wistron InfoComm Manufacturing(Kunshan)Co.)
Nmap scan report for bogon (192.168.70.86)
Host is up (0.00039s latency).
MAC Address: FC:AA:14:7F:82:C7 (Giga-byte Technology)
Nmap scan report for 192.168.70.108
Host is up (0.00038s latency).
MAC Address: E0:CB:4E:A4:AA:AA (Asustek Computer)
Nmap scan report for bogon (192.168.70.114)
Host is up (0.0018s latency).
MAC Address: 38:C9:86:3A:11:B8 (Apple)
Nmap scan report for 192.168.70.121
Host is up (0.00028s latency).
MAC Address: 74:D0:2B:9C:CB:B0 (Asustek Computer)
Nmap scan report for bogon (192.168.70.146)
Host is up (0.00024s latency).
MAC Address: E0:CB:4E:E3:15:E7 (Asustek Computer)
Nmap scan report for 192.168.70.250
Host is up (0.00027s latency).
MAC Address: 14:DA:E9:91:A8:B5 (Asustek Computer)
Nmap scan report for bogon (192.168.70.83)
Host is up.
Nmap done: 256 IP addresses (13 hosts up) scanned in 1.19 seconds
```

#### 4. Ping指定范围内的IP地址
	
`sudo nmap -sP 192.168.70.100-200`

* `-sP` 对指定 IP 范围内的所有地址进行 ping 扫描，列出响应的主机

**Output**

```
Starting Nmap 7.12 ( https://nmap.org ) at 2016-12-23 19:13 CST
Nmap scan report for bogon (192.168.70.108)
Host is up (0.00041s latency).
MAC Address: E0:CB:4E:A4:AA:AA (Asustek Computer)
Nmap scan report for 192.168.70.114
Host is up (0.00057s latency).
MAC Address: 38:C9:86:3A:11:B8 (Apple)
Nmap scan report for bogon (192.168.70.121)
Host is up (0.00021s latency).
MAC Address: 74:D0:2B:9C:CB:B0 (Asustek Computer)
Nmap scan report for 192.168.70.146
Host is up (0.00029s latency).
MAC Address: E0:CB:4E:E3:15:E7 (Asustek Computer)
Nmap done: 101 IP addresses (4 hosts up) scanned in 1.60 seconds
```

#### 5. 在某段子网上查找未占用IP

`sudo nmap -T4 -sP 192.168.70.83/24 && egrep "00:00:00:00:00:00" /proc/net/arp`

* `-T<0-5>` 设定定时模板，越大越快
* `-sP` 对指定 IP 范围内的所有地址进行 ping 扫描，列出响应的主机
* `egrep "00:00:00:00:00:00" /proc/net/arp`  使用在ARP反向解析，查找没有MAC地址对应的IP

**Output**
```
```

### 6. 在局域网上扫描Conficker蠕虫病毒

`nmap -PN -T4 -p139,455 -n -v --script=smb-check-vulns --script-args safe = 1 192.168.0.1-254`

### 7. 扫描网络上的恶意接入点

`nmap -A -p1-85,113,443,8080-8100 -T4 --min-hostgroup 50 --max-rtt-timeout 2000 --initial-rtt-timeout 300 --max-retries 3 --host-timeout 20m --max-scan-delay 1000 -oA wapscan 10.0.0.0/8`

### 8. 使用诱饵扫描方法来扫描主机端口

`sudo nmap -sS 192.168.0.10 -D 192.168.0.2`

### 9. 为一个子网列出反向 DNS 记录

`nmap -R -sL 209.85.229.99/27 | awk {if($3=="not")print"("$2") no PTR";else print$3" is "$2} | grep (`

### 10. 显示网络上共有多少台 Linux 及 Win 设备?

`sudo nmap -F -O 192.168.0.1-255 | grep "Running: " > /tmp/os; echo "$(cat /tmp/os | grep Linux | wc -l) Linux device(s)"; echo "$(cat /tmp/os | grep Windows | wc -l) Window(s) device"`

[link](http://www.2cto.com/article/201102/84402.html)



## 下面列一下 nmap 的帮助信息

```
Nmap version 7.12 ( https://nmap.org )
Platform: x86_64-apple-darwin15.4.0
Compiled with: liblua-5.2.4 openssl-1.0.2g nmap-libpcre-7.6 libpcap-1.7.4 nmap-libdnet-1.12 ipv6
Compiled without:
Available nsock engines: kqueue poll select
```

### **nmap --help**

```
Nmap 7.12 ( https://nmap.org )
Usage: nmap [Scan Type(s)] [Options] {target specification}
TARGET SPECIFICATION:
  Can pass hostnames, IP addresses, networks, etc.
  Ex: scanme.nmap.org, microsoft.com/24, 192.168.0.1; 10.0.0-255.1-254
  -iL <inputfilename>: Input from list of hosts/networks
  -iR <num hosts>: Choose random targets
  --exclude <host1[,host2][,host3],...>: Exclude hosts/networks
  --excludefile <exclude_file>: Exclude list from file
HOST DISCOVERY:
  -sL: List Scan - simply list targets to scan
  -sn: Ping Scan - disable port scan
  -Pn: Treat all hosts as online -- skip host discovery
  -PS/PA/PU/PY[portlist]: TCP SYN/ACK, UDP or SCTP discovery to given ports
  -PE/PP/PM: ICMP echo, timestamp, and netmask request discovery probes
  -PO[protocol list]: IP Protocol Ping
  -n/-R: Never do DNS resolution/Always resolve [default: sometimes]
  --dns-servers <serv1[,serv2],...>: Specify custom DNS servers
  --system-dns: Use OS's DNS resolver
  --traceroute: Trace hop path to each host
SCAN TECHNIQUES:
  -sS/sT/sA/sW/sM: TCP SYN/Connect()/ACK/Window/Maimon scans
  -sU: UDP Scan
  -sN/sF/sX: TCP Null, FIN, and Xmas scans
  --scanflags <flags>: Customize TCP scan flags
  -sI <zombie host[:probeport]>: Idle scan
  -sY/sZ: SCTP INIT/COOKIE-ECHO scans
  -sO: IP protocol scan
  -b <FTP relay host>: FTP bounce scan
PORT SPECIFICATION AND SCAN ORDER:
  -p <port ranges>: Only scan specified ports
    Ex: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9
  --exclude-ports <port ranges>: Exclude the specified ports from scanning
  -F: Fast mode - Scan fewer ports than the default scan
  -r: Scan ports consecutively - don't randomize
  --top-ports <number>: Scan <number> most common ports
  --port-ratio <ratio>: Scan ports more common than <ratio>
SERVICE/VERSION DETECTION:
  -sV: Probe open ports to determine service/version info
  --version-intensity <level>: Set from 0 (light) to 9 (try all probes)
  --version-light: Limit to most likely probes (intensity 2)
  --version-all: Try every single probe (intensity 9)
  --version-trace: Show detailed version scan activity (for debugging)
SCRIPT SCAN:
  -sC: equivalent to --script=default
  --script=<Lua scripts>: <Lua scripts> is a comma separated list of
           directories, script-files or script-categories
  --script-args=<n1=v1,[n2=v2,...]>: provide arguments to scripts
  --script-args-file=filename: provide NSE script args in a file
  --script-trace: Show all data sent and received
  --script-updatedb: Update the script database.
  --script-help=<Lua scripts>: Show help about scripts.
           <Lua scripts> is a comma-separated list of script-files or
           script-categories.
OS DETECTION:
  -O: Enable OS detection
  --osscan-limit: Limit OS detection to promising targets
  --osscan-guess: Guess OS more aggressively
TIMING AND PERFORMANCE:
  Options which take <time> are in seconds, or append 'ms' (milliseconds),
  's' (seconds), 'm' (minutes), or 'h' (hours) to the value (e.g. 30m).
  -T<0-5>: Set timing template (higher is faster)
  --min-hostgroup/max-hostgroup <size>: Parallel host scan group sizes
  --min-parallelism/max-parallelism <numprobes>: Probe parallelization
  --min-rtt-timeout/max-rtt-timeout/initial-rtt-timeout <time>: Specifies
      probe round trip time.
  --max-retries <tries>: Caps number of port scan probe retransmissions.
  --host-timeout <time>: Give up on target after this long
  --scan-delay/--max-scan-delay <time>: Adjust delay between probes
  --min-rate <number>: Send packets no slower than <number> per second
  --max-rate <number>: Send packets no faster than <number> per second
FIREWALL/IDS EVASION AND SPOOFING:
  -f; --mtu <val>: fragment packets (optionally w/given MTU)
  -D <decoy1,decoy2[,ME],...>: Cloak a scan with decoys
  -S <IP_Address>: Spoof source address
  -e <iface>: Use specified interface
  -g/--source-port <portnum>: Use given port number
  --proxies <url1,[url2],...>: Relay connections through HTTP/SOCKS4 proxies
  --data <hex string>: Append a custom payload to sent packets
  --data-string <string>: Append a custom ASCII string to sent packets
  --data-length <num>: Append random data to sent packets
  --ip-options <options>: Send packets with specified ip options
  --ttl <val>: Set IP time-to-live field
  --spoof-mac <mac address/prefix/vendor name>: Spoof your MAC address
  --badsum: Send packets with a bogus TCP/UDP/SCTP checksum
OUTPUT:
  -oN/-oX/-oS/-oG <file>: Output scan in normal, XML, s|<rIpt kIddi3,
     and Grepable format, respectively, to the given filename.
  -oA <basename>: Output in the three major formats at once
  -v: Increase verbosity level (use -vv or more for greater effect)
  -d: Increase debugging level (use -dd or more for greater effect)
  --reason: Display the reason a port is in a particular state
  --open: Only show open (or possibly open) ports
  --packet-trace: Show all packets sent and received
  --iflist: Print host interfaces and routes (for debugging)
  --append-output: Append to rather than clobber specified output files
  --resume <filename>: Resume an aborted scan
  --stylesheet <path/URL>: XSL stylesheet to transform XML output to HTML
  --webxml: Reference stylesheet from Nmap.Org for more portable XML
  --no-stylesheet: Prevent associating of XSL stylesheet w/XML output
MISC:
  -6: Enable IPv6 scanning
  -A: Enable OS detection, version detection, script scanning, and traceroute
  --datadir <dirname>: Specify custom Nmap data file location
  --send-eth/--send-ip: Send using raw ethernet frames or IP packets
  --privileged: Assume that the user is fully privileged
  --unprivileged: Assume the user lacks raw socket privileges
  -V: Print version number
  -h: Print this help summary page.
EXAMPLES:
  nmap -v -A scanme.nmap.org
  nmap -v -sn 192.168.0.0/16 10.0.0.0/8
  nmap -v -iR 10000 -Pn -p 80
SEE THE MAN PAGE (https://nmap.org/book/man.html) FOR MORE OPTIONS AND EXAMPLES
```

