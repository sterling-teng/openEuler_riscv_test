### 在openEuler riscv64中使用nmap执行安全测试

#### 1. nmap介绍

nmap是一款开源免费的网络发现工具，通过它能够找出网络上在线的主机,并测试主机上哪些端口处于监听状态，接着通过端口确定主机上运行的应用程序类型与版本信息，最后利用它还能侦测出操作系统的类型和版本。

#### 2. nmap下载和安装

安装环境：D1开发版烧入 openEuler riscv64 23.03 v1 版本 https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.03-V1-riscv64/

下载nmap源码并解压

````
$ wget https://nmap.org/dist/nmap-7.94.tar.bz2
$ bzip2 -cd nmap-7.94.tar.bz2 | tar xvf -
````

安装编译所需依赖包

````
$ yum install -y automake openssl-devel
````

用 automake 下的 config.guess 替换 nmap源码中的config.guess

````
$ cp /usr/share/automake-1.16/config.guess nmap-7.94/
````

nmap编译和安装

````
$ cd nmap-7.94
$ ./configure
$ make
$ make install
````

#### 3.使用nmap扫描

nmap命令格式：

nmap [\<scan type\>...] [\<options\>] {\<target specification\>}

扫描类型(scan type):

**-sT：**TCP connect()扫描，这是最基本的TCP扫描方式。connect()是一种系统调用，由操作系统提供，用来打开一个连接。如果目标端口有程序监听， connect()就会成功返回，否则这个端口是不可达的。这项技术最大的优点是，你勿需root权限。任何UNIX用户都可以自由使用这个系统调用。这种扫描很容易被检测到，在目标主机的日志中会记录大批的连接请求以及错误信息。 

 **-sS：**TCP同步扫描(TCP SYN)，因为不必全部打开一个TCP连接，所以这项技术通常称为半开扫描(half-open)。你可以发出一个TCP同步包(SYN)，然后等待回应。如果对方返回SYN|ACK(响应)包就表示目标端口正在监听；如果返回RST数据包，就表示目标端口没有监听程序；如果收到一个SYN|ACK包，源主机就会马上发出一个RST(复位)数据包断开和目标主机的连接，这实际上有我们的操作系统内核自动完成的。这项技术最大的好处是，很少有系统能够把这记入系统日志。不过，你需要root权限来定制SYN数据包。

 **-sU：**UDP扫描，发送0字节UDP包，快速扫描Windows的UDP端口如果你想知道在某台主机上提供哪些UDP(用户数据报协议,RFC768)服务，可以使用这种扫描方法。nmap首先向目标主机的每个端口发出一个0字节的UDP包，如果我们收到端口不可达的ICMP消息，端口就是关闭的，否则我们就假设它是打开的。

 **-sP：**ping扫描，有时你只是想知道此时网络上哪些主机正在运行。通过向你指定的网络内的每个IP地址发送ICMP echo请求数据包，nmap就可以完成这项任务。注意，nmap在任何情况下都会进行ping扫描，只有目标主机处于运行状态，才会进行后续的扫描。如果你只是想知道目标主机是否运行，而不想进行其它扫描，才会用到这个选项。

 **-sA：**ACK扫描 TCP ACK扫描，当防火墙开启时，查看防火墙有未过虑某端口，这项高级的扫描方法通常用来穿过防火墙的规则集。通常情况下，这有助于确定一个防火墙是功能比较完善的或者是一个简单的包过滤程序，只是阻塞进入的SYN包。这种扫描是向特定的端口发送ACK包(使用随机的应答/序列号)。如果返回一个RST包，这个端口就标记为unfiltered状态。如果什么都没有返回，或者返回一个不可达ICMP消息，这个端口就归入filtered类。注意，nmap通常不输出unfiltered的端口，所以在输出中通常不显示所有被探测的端口。显然，这种扫描方式不能找出处于打开状态的端口。

 **-sW：**滑动窗口扫描，这项高级扫描技术非常类似于ACK扫描，除了它有时可以检测到处于打开状态的端口，因为滑动窗口的大小是不规则的，有些操作系统可以报告其大小。 

 **-sR：**RPC扫描，和其他不同的端口扫描方法结合使用。

 **-b：**FTP反弹攻击(FTP Bounce attack) 外网用户通过FTP渗透内网

通用选项(options):

**-P0：**nmap扫描前不Ping目标主机。在扫描之前，不必ping主机。有些网络的防火墙不允许ICMP echo请求穿过，使用这个选项可以对这些网络进行扫描。

 **-PT：**nmap扫描前使用TCP ACK包确定主机是否在运行（-PT默认80。扫描之前，使用TCP ping确定哪些主机正在运行。nmap不是通过发送ICMP echo请求包然后等待响应来实现这种功能，而是向目标网络(或者单一主机)发出TCP ACK包然后等待回应。如果主机正在运行就会返回RST包。只有在目标网络/主机阻塞了ping包，而仍旧允许你对其进行扫描时，这个选项才有效。对于非 root用户，我们使用connect()系统调用来实现这项功能。使用-PT 来设定目标端口。默认的端口号是80，因为这个端口通常不会被过滤。　　

 **-PS：** nmap使用TCP SYN包进行扫描。对于root用户，这个选项让nmap使用SYN包而不是ACK包来对目标主机进行扫描。如果主机正在运行就返回一个RST包(或者一个SYN/ACK包)。

  **-PI：**nmap进行Ping扫描。设置这个选项，让nmap使用真正的ping(ICMP echo请求)来扫描目标主机是否正在运行。使用这个选项让nmap发现正在运行的主机的同时，nmap也会对你的直接子网广播地址进行观察。直接子网广播地址一些外部可达的IP地址，把外部的包转换为一个内向的IP广播包，向一个计算机子网发送。这些IP广播包应该删除，因为会造成拒绝服务攻击(例如 smurf)。

 **-PB：**结合-PT和-PI功能，这是默认的ping扫描选项。它使用ACK(-PT)和ICMP(-PI)两种扫描类型并行扫描。如果防火墙能够过滤其中一种包，使用这种方法，你就能够穿过防火墙。

 **-O：**Nmap扫描TCP/IP指纹特征，确定目标主机系统类型。

 **-I：**反向标志扫描，扫描监听端口的用户

 **-f：**分片发送SYN、FIN、Xmas、和Null扫描的数据包

 **-v：**冗余模式扫描，可以得到扫描详细信息

 **-oN：** 扫描结果重定向到文件

 **-resume：**使被中断的扫描可以继续

 **-iL：**-iL,扫描目录文件列表

 **-p：**-p 指定端口或扫描端口列表及范围，默认扫描1-1024端口和/usr/share/nmap/nmap-services文件中指定端口。-p例：23；20-30,139,60000-这个选项让你选择要进行扫描的端口号的范围。例如，-p 23表示：只扫描目标主机的23号端口。-p 20-30,139,60000-表示：扫描20到30号端口，139号端口以及所有大于60000的端口。

扫描目标(target specification)

扫描目标通常为IP地址或IP列表

192.168.10.1

192.168.10.0/24

192.168.\*.\*

##### 3.1 扫描主机：

扫描单个主机：

nmap 192.168.0.103

````
$ nmap 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 14:37 CST
Nmap scan report for 192.168.0.103
Host is up (-12s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE
111/tcp  open  rpcbind
2049/tcp open  nfs
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 4.90 seconds
````

由输出可知，主机192.168.0.103 处于 up 状态，并且该主机上开放了111，2049端口，同时还侦测到开放的端口对应的服务，以及该主机网卡的MAC Address

扫描多个主机

nmap 192.168.0.102 192.168.0.103

````
$ nmap 192.168.0.102 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 14:45 CST
Nmap scan report for 192.168.0.102
Host is up (-12s latency).
Not shown: 994 closed tcp ports (reset)
PORT     STATE SERVICE
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
902/tcp  open  iss-realsecure
912/tcp  open  apex-mesh
2869/tcp open  icslap
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap scan report for 192.168.0.103
Host is up (-12s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE
111/tcp  open  rpcbind
2049/tcp open  nfs
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap done: 2 IP addresses (2 hosts up) scanned in 5.86 seconds
````

扫描一个范围内的主机

nmap 192.168.0.1-110

````
$ nmap 192.168.0.1-110
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 14:48 CST
Nmap scan report for 192.168.0.1
Host is up (-12s latency).
Not shown: 998 filtered tcp ports (no-response)
PORT     STATE SERVICE
80/tcp   open  http
1900/tcp open  upnp
MAC Address: F4:83:CD:AB:C3:67 (TP-Link Technologies)

Nmap scan report for 192.168.0.102
Host is up (-12s latency).
Not shown: 994 closed tcp ports (reset)
PORT     STATE SERVICE
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
902/tcp  open  iss-realsecure
912/tcp  open  apex-mesh
2869/tcp open  icslap
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap scan report for 192.168.0.103
Host is up (-12s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE
111/tcp  open  rpcbind
2049/tcp open  nfs
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap scan report for 192.168.0.104
Host is up (-12s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
````

扫描整个子网

nmap 192.168.0.1/24

````
$ nmap 192.168.0.1/24
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 16:10 CST
Nmap scan report for 192.168.0.1
Host is up (-12s latency).
Not shown: 998 filtered tcp ports (no-response)
PORT     STATE SERVICE
80/tcp   open  http
1900/tcp open  upnp
MAC Address: F4:83:CD:AB:C3:67 (TP-Link Technologies)

Nmap scan report for 192.168.0.102
Host is up (-12s latency).
Not shown: 994 closed tcp ports (reset)
PORT     STATE SERVICE
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
902/tcp  open  iss-realsecure
912/tcp  open  apex-mesh
2869/tcp open  icslap
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap scan report for 192.168.0.103
Host is up (-12s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE
111/tcp  open  rpcbind
2049/tcp open  nfs
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap scan report for 192.168.0.104
Host is up (-12s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh

Nmap done: 256 IP addresses (4 hosts up) scanned in 29.61 seconds
````

获取指定主机更多信息

nmap -T4 -A -v 192.168.0.103

其中：

-A：开启全面扫描

-T4：指定扫描过程中使用的时序模版，总共有6个等级（0~5），等级越高，扫描速度越快，但也越容易被防火墙或者入侵检测设备发现并屏蔽，所以选择一个适当的扫描等级非常重要，这里推荐使用-T4

-v：显示扫描细节

````
$ nmap -T4 -A -v 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 14:53 CST
NSE: Script scanning 192.168.0.103.
Initiating NSE at 15:09
Completed NSE at 15:09, 0.49s elapsed
Initiating NSE at 15:09
Completed NSE at 15:09, 0.10s elapsed
Initiating NSE at 15:09
Completed NSE at 15:09, 0.02s elapsed
Nmap scan report for 192.168.0.103
Host is up (-12s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
111/tcp  open  rpcbind 2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100003  3,4         2049/tcp   nfs
|_  100003  3,4         2049/tcp6  nfs
2049/tcp open  nfs     3-4 (RPC #100003)
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)
Device type: general purpose
Running: Linux 4.X|5.X
OS CPE: cpe:/o:linux:linux_kernel:4 cpe:/o:linux:linux_kernel:5
OS details: Linux 4.15 - 5.8
Uptime guess: 28.812 days (since Thu Jun 22 19:39:43 2023)
Network Distance: 1 hop
TCP Sequence Prediction: Difficulty=263 (Good luck!)
IP ID Sequence Generation: All zeros

TRACEROUTE
HOP RTT ADDRESS
1   --  192.168.0.103

NSE: Script Post-scanning.
Initiating NSE at 15:09
Completed NSE at 15:09, 0.01s elapsed
Initiating NSE at 15:09
Completed NSE at 15:09, 0.01s elapsed
Initiating NSE at 15:09
Completed NSE at 15:09, 0.01s elapsed
Read data files from: /usr/local/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 30.35 seconds
           Raw packets sent: 1033 (46.246KB) | Rcvd: 1023 (41.618KB)
````

第一部分是对主机是否在线进行扫描；

第二部分是对端口进行扫描，在默认情况下nmap会扫描1000个最有可能开放的端口，由于只扫描到111，2049 二个端口处于打开状态，所以在输出中会有"998 closed tcp ports";

第三部分是对端口上运行的应用服务以及版本号进行统计；

第四部分是对操作系统类型和版本进行探测；

##### 3.2 扫描端口

nmap将端口分成6个状态：

open(开放的)：应用程序正在该端口接收TCP连接或者UDP报文

closed(关闭的)：关闭的端口对于nmap也是可访问的，但没有应用程序在其上监听

filtered(被过滤的)：由于包过滤阻止探测报文到达端口，nmap无法确定该端口是否开放

unfiltered(未被过滤的)：未被过滤状态意味着端口可访问，但nmap不能确定它是开放还是关闭

open | filtered(开放或者被过滤的)：当无法确定端口是开放还是被过滤的，nmap就把该端口划分成这种状态

closed | filtered(关闭或者被过滤的)：该状态用于nmap不能确定端口是关闭的还是被过滤的

扫描指定主机的单个指定端口

nmap -p80 192.168.0.103

````
$ nmap -p80 192.168.0.1
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 16:12 CST
Nmap scan report for 192.168.0.1
Host is up (-12s latency).

PORT   STATE SERVICE
80/tcp open  http
MAC Address: F4:83:CD:AB:C3:67 (TP-Link Technologies)

Nmap done: 1 IP address (1 host up) scanned in 1.54 seconds
[root@openeuler-riscv64 ~]# nmap -p80 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 17:25 CST
Nmap scan report for 192.168.0.103
Host is up (-12s latency).

PORT   STATE  SERVICE
80/tcp closed http
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 1.68 seconds

````

扫描指定主机的多个指定端口

nmap -p80,22 192.168.0.103

````
$ nmap -p80,22 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 17:26 CST
Nmap scan report for 192.168.0.103
Host is up (-12s latency).

PORT   STATE  SERVICE
22/tcp closed ssh
80/tcp closed http
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 2.73 seconds

````

扫描指定主机一定范围内的端口

nmap -p20-200 192.168.0.103

````
$ nmap -p20-200 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 17:41 CST
Nmap scan report for 192.168.0.103
Host is up (-12s latency).
Not shown: 105 filtered tcp ports (no-response), 75 closed tcp ports (reset)
PORT    STATE SERVICE
111/tcp open  rpcbind
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 3.30 seconds
````

使用Ping协议进行主机发现（Ping扫描）

nmap -sP 192.168.0.103

````
$ nmap -sP 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 17:48 CST
Nmap scan report for 192.168.0.103
Host is up (-12s latency).
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)
Nmap done: 1 IP address (1 host up) scanned in 1.19 seconds
````

使用ARP协议进行主机发现

nmap -PR 192.168.0.103

````
$ nmap -sP 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 17:48 CST
Nmap scan report for 192.168.0.103
Host is up (-12s latency).
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)
Nmap done: 1 IP address (1 host up) scanned in 1.19 seconds
[root@openeuler-riscv64 ~]# nmap -PR 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 17:49 CST
Nmap scan report for 192.168.0.103
Host is up (-12s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE
111/tcp  open  rpcbind
2049/tcp open  nfs
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 7.27 seconds
````

扫描指定指定主机的TCP端口

nmap -sT 192.168.0.103

````
$ nmap -sT 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 17:50 CST
Nmap scan report for 192.168.0.103
Host is up (-12s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT     STATE SERVICE
111/tcp  open  rpcbind
2049/tcp open  nfs
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 4.73 seconds
````

扫描指定主机的UDP端口

nmap -sU 192.168.0.103

````
$ nmap -sU 192.168.0.103
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 17:52 CST
Nmap scan report for 192.168.0.103
Host is up (-11s latency).
Not shown: 997 closed udp ports (port-unreach)
PORT     STATE         SERVICE
111/udp  open          rpcbind
631/udp  open|filtered ipp
5353/udp open|filtered zeroconf
MAC Address: 3C:E9:F7:32:6F:D6 (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 1160.41 seconds
````





参考：

https://nmap.org/

https://www.cnblogs.com/linyfeng/p/12591725.html

https://juejin.cn/post/6844903635910918158
