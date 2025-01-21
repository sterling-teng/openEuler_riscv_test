Mugen测试Lesson Learn

### 1. mugen使用方法

#### 1.1 mugen测试环境准备

下载源码

````
$ git clone https://gitee.com/openeuler/mugen.git
````

安装依赖软件包

````
$ cd mugen
$ bash dep_install.sh
````

配置测试套环境变量

根据测试套中测试用例定义的条件，来配置环境变量，例如 security_guide 测试套，下面表示执行测试用例 oe_test_ssh_check_home 只需要 1 个设备（node)

````
{
    "name": "oe_test_ssh_check_home"
},
````

下面表示执行测试用例 oe_test_ssh_check_home 只需要 3 个设备（node)

````
{
    "name": "oe_test_ssh_disable_agent_forwarding",
	"machine num": 3
},
````

执行下面命令来配置环境变量

````
$ bash mugen.sh -c --ip $ip --password $passwd --user $user --port $port
````

ip：测试机的ip地址

user：测试机的登录用户，默认为root

password: 测试机的登录密码

port：测试机ssh登陆端口，默认为22

例如执行 bash mugen.sh -c --ip 10.0.2.15 --password openEuler12#$ --user root --port 22

执行测试用例需要几个设备（node），这个命令就需要执行几次

#### 1.2 执行mugen测试套和测试用例

执行所有用例 `bash mugen.sh -a`

执行指定测试套 `bash mugen.sh -f testsuite`

执行单条用例 `bash mugen.sh -f testsuite -r testcase`

如果需要日志输出shell脚本的执行过程，则需要在命令行后面加上参数 -x

```
$ bash mugen.sh -a -x 
$ bash mugen.sh -f testsuite -x
$ bash mugen.sh -f testsuite -r testcase -x
```

详情可以参看 https://gitee.com/openeuler/mugen

### 2. qemu 之间通讯的网络配置

qemu之间通讯可以利用 Bridge + TAP Network 方式实现，下面以启动 2个 qemu 为例进行说明

#### 2.1 宿主机网络配置

宿主机创建网桥，并给网桥配置 IP

````
$ sudo brctl addbr br0      //创建网桥br0
$ sudo ip link set br0 up   //启动br0
$ sudo ip addr add 10.0.0.1/24 dev br0   //给br0配置ip
````

宿主机添加 2 个虚拟网卡并将虚拟网卡加入网桥

````
$ sudo ip tuntap add tap0 mode tap   //添加一个tap0网卡
$ sudo brctl addif br0 tap0      //将tap0加入到网桥br0
$ sudo ip link set tap0 up     //启用tap0网卡
````

````
$ sudo ip tuntap add tap1 mode tap     //添加一个tap1网卡
$ sudo brctl addif br0 tap1      //将tap1加入到网桥br0
$ sudo ip link set tap1 up     //启用tap1网卡
$ sudo brctl show   //查看网桥
````

查看宿主机网络

````
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:22:1e:76:5f:38 brd ff:ff:ff:ff:ff:ff
    altname enp0s5
    altname ens5
    inet 10.240.124.59/20 metric 100 brd 10.240.127.255 scope global dynamic eth0
       valid_lft 100654293sec preferred_lft 100654293sec
    inet6 fe80::222:1eff:fe76:5f38/64 scope link 
       valid_lft forever preferred_lft forever
3: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b6:91:b2:04:38:07 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.1/24 scope global br0
       valid_lft forever preferred_lft forever
    inet6 fe80::b491:b2ff:fe04:3807/64 scope link 
       valid_lft forever preferred_lft forever
4: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master br0 state UP group default qlen 1000
    link/ether 2e:02:1c:7f:e2:c0 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::2c02:1cff:fe7f:e2c0/64 scope link 
       valid_lft forever preferred_lft forever
5: tap1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master br0 state UP group default qlen 1000
    link/ether d2:67:2f:85:a7:7d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d067:2fff:fe85:a77d/64 scope link 
       valid_lft forever preferred_lft forever
````

#### 2.2 qemu启动脚本配置

将添加的网卡和 mac 添加到 qemu 启动命令里

qemu1

````
#!/usr/bin/env bash

# The script is created for starting a riscv64 qemu virtual machine with specific parameters.

RESTORE=$(echo -en '\001\033[0m\002')
YELLOW=$(echo -en '\001\033[00;33m\002')

## Configuration
vcpu=8
memory=8
memory_append=`expr $memory \* 1024`
drive="$(ls *.qcow2)"
fw="fw_payload_oe_uboot_2304.bin"
ssh_port=12055

cmd="qemu-system-riscv64 \
  -nographic -machine virt \
  -smp "$vcpu" -m "$memory"G \
  -bios "$fw" \
  -drive file="$drive",format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-vga \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device virtio-net-pci,netdev=net0,mac=52:54:00:11:45:02 \
  -device virtio-net-device,netdev=usernet,mac=52:54:00:11:45:01 \
  -netdev user,id=usernet,hostfwd=tcp::"$ssh_port"-:22 \
  -device qemu-xhci -usb -device usb-kbd -device usb-tablet"

echo ${YELLOW}:: Starting VM...${RESTORE}
echo ${YELLOW}:: Using following configuration${RESTORE}
echo ""
echo ${YELLOW}vCPU Cores: "$vcpu"${RESTORE}
echo ${YELLOW}Memory: "$memory"G${RESTORE}
echo ${YELLOW}Disk: "$drive"${RESTORE}
echo ${YELLOW}SSH Port: "$ssh_port"${RESTORE}
echo ""
echo ${YELLOW}:: NOTE: Make sure ONLY ONE .qcow2 file is${RESTORE}
echo ${YELLOW}in the current directory${RESTORE}
echo ""
echo ${YELLOW}:: Tip: Try setting DNS manually if QEMU user network doesn\'t work well. ${RESTORE}
echo ${YELLOW}:: HOWTO -\> https://serverfault.com/a/810639 ${RESTORE}
echo ""
echo ${YELLOW}:: Tip: If \'ping\' reports permission error, try reinstalling \'iputils\'. ${RESTORE}
echo ${YELLOW}:: HOWTO -\> \'sudo dnf reinstall iputils\' ${RESTORE}
echo ""

sleep 2

eval $cmd
````

qemu2

````
#!/usr/bin/env bash

# The script is created for starting a riscv64 qemu virtual machine with specific parameters.

RESTORE=$(echo -en '\001\033[0m\002')
YELLOW=$(echo -en '\001\033[00;33m\002')

## Configuration
vcpu=8
memory=8
memory_append=`expr $memory \* 1024`
drive="$(ls *.qcow2)"
fw="fw_payload_oe_uboot_2304.bin"
ssh_port=12056

cmd="qemu-system-riscv64 \
  -nographic -machine virt \
  -smp "$vcpu" -m "$memory"G \
  -bios "$fw" \
  -drive file="$drive",format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-vga \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -netdev tap,id=net1,ifname=tap1,script=no,downscript=no -device virtio-net-pci,netdev=net1,mac=52:54:00:11:45:04 \
  -device virtio-net-device,netdev=usernet,mac=52:54:00:11:45:03 \
  -netdev user,id=usernet,hostfwd=tcp::"$ssh_port"-:22 \
  -device qemu-xhci -usb -device usb-kbd -device usb-tablet"

echo ${YELLOW}:: Starting VM...${RESTORE}
echo ${YELLOW}:: Using following configuration${RESTORE}
echo ""
echo ${YELLOW}vCPU Cores: "$vcpu"${RESTORE}
echo ${YELLOW}Memory: "$memory"G${RESTORE}
echo ${YELLOW}Disk: "$drive"${RESTORE}
echo ${YELLOW}SSH Port: "$ssh_port"${RESTORE}
echo ""
echo ${YELLOW}:: NOTE: Make sure ONLY ONE .qcow2 file is${RESTORE}
echo ${YELLOW}in the current directory${RESTORE}
echo ""
echo ${YELLOW}:: Tip: Try setting DNS manually if QEMU user network doesn\'t work well. ${RESTORE}
echo ${YELLOW}:: HOWTO -\> https://serverfault.com/a/810639 ${RESTORE}
echo ""
echo ${YELLOW}:: Tip: If \'ping\' reports permission error, try reinstalling \'iputils\'. ${RESTORE}
echo ${YELLOW}:: HOWTO -\> \'sudo dnf reinstall iputils\' ${RESTORE}
echo ""

sleep 2

eval $cmd
````

#### 2.3 qemu 网络配置

qemu 启动后，在 qemu 中配置网络

qemu1未网络配置之前查看网卡信息

````
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:11:45:01 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute eth0
       valid_lft 84881sec preferred_lft 84881sec
    inet6 fec0::19a:7beb:4c1e:b68e/64 scope site dynamic noprefixroute 
       valid_lft 86057sec preferred_lft 14057sec
    inet6 fe80::a8fa:9572:dba1:6a8d/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:11:45:02 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::e222:7489:3b39:174e/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
````

qemu1 配置网络

````
$ nmcli con add type ethernet con-name net-static ifname enp0s2 ip4 10.0.0.2/24 gw4 10.0.0.254    //创建名为 net-static的静态连接配置文件
$ nmcli con up net-static      //激活连接
$ nmcli device status     //检查网卡及连接的状态
````

qemu1 配置网络后再次查看网卡信息

````
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:11:45:01 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute eth0
       valid_lft 84881sec preferred_lft 84881sec
    inet6 fec0::19a:7beb:4c1e:b68e/64 scope site dynamic noprefixroute 
       valid_lft 86057sec preferred_lft 14057sec
    inet6 fe80::a8fa:9572:dba1:6a8d/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:11:45:02 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.2/24 brd 10.0.0.255 scope global noprefixroute enp0s2
       valid_lft forever preferred_lft forever
    inet6 fe80::e222:7489:3b39:174e/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
````

qemu2 未网络配置之前查看网卡信息

````
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:11:45:03 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute eth0
       valid_lft 82067sec preferred_lft 82067sec
    inet6 fec0::250c:3e07:8b2b:d852/64 scope site dynamic noprefixroute 
       valid_lft 86274sec preferred_lft 14274sec
    inet6 fe80::682b:e5c3:1e2e:1ff8/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:11:45:04 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::1c25:7d88:dfb4:8661/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
````

qemu2 配置网络

````
$ nmcli con add type ethernet con-name net-static ifname enp0s2 ip4 10.0.0.3/24 gw4 10.0.0.254    //创建名为 net-static的静态连接配置文件
$ nmcli con up net-static     //激活连接
$ nmcli device status      //检查网卡及连接的状态
````

qemu2 配置网络后再次查看网卡信息

````
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:11:45:03 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute eth0
       valid_lft 82067sec preferred_lft 82067sec
    inet6 fec0::250c:3e07:8b2b:d852/64 scope site dynamic noprefixroute 
       valid_lft 86274sec preferred_lft 14274sec
    inet6 fe80::682b:e5c3:1e2e:1ff8/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:11:45:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.3/24 brd 10.0.0.255 scope global noprefixroute enp0s2
       valid_lft forever preferred_lft forever
    inet6 fe80::1c25:7d88:dfb4:8661/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
````

此时，在 qemu1 中 ping qemu2 ip 10.0.0.3 可以 ping 通。在 qemu2 中 ping qemu1 ip 10.0.0.2 也可以 ping 通

### 3. 给qemu添加磁盘

qemu未添加磁盘时查看硬盘信息

````
$ fdisk -l
Disk /dev/vda: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: C1ED27BF-65EA-4BF3-A537-BBD23DF7C75B

Device       Start      End  Sectors  Size Type
/dev/vda1     2048  1050623  1048576  512M BIOS boot
/dev/vda2  1050624 41943006 40892383 19.5G Linux filesystem
````

创建硬盘镜像

````
$ qemu-img create -f qcow2 disk.qcow2 10G
````

在 qemu 启动命令中挂载硬盘

````
#!/usr/bin/env bash

# The script is created for starting a riscv64 qemu virtual machine with specific parameters.

RESTORE=$(echo -en '\001\033[0m\002')
YELLOW=$(echo -en '\001\033[00;33m\002')

## Configuration
vcpu=8
memory=8
memory_append=`expr $memory \* 1024`
drive="$(ls *.qcow2)"
fw="fw_payload_oe_uboot_2304.bin"
ssh_port=12056

cmd="qemu-system-riscv64 \
  -nographic -machine virt \
  -smp "$vcpu" -m "$memory"G \
  -bios "$fw" \
  -drive file="$drive",format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-vga \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -drive format=qcow2,file=/opt/cloudroot/2403/bb/disk/disk.qcow2,id=hd1,if=none \
  -device virtio-blk-pci,drive=hd1 \
  -netdev tap,id=net1,ifname=tap1,script=no,downscript=no -device virtio-net-pci,netdev=net1,mac=52:54:00:11:45:04 \
  -device virtio-net-device,netdev=usernet,mac=52:54:00:11:45:03 \
  -netdev user,id=usernet,hostfwd=tcp::"$ssh_port"-:22 \
  -device qemu-xhci -usb -device usb-kbd -device usb-tablet"

echo ${YELLOW}:: Starting VM...${RESTORE}
echo ${YELLOW}:: Using following configuration${RESTORE}
echo ""
echo ${YELLOW}vCPU Cores: "$vcpu"${RESTORE}
echo ${YELLOW}Memory: "$memory"G${RESTORE}
echo ${YELLOW}Disk: "$drive"${RESTORE}
echo ${YELLOW}SSH Port: "$ssh_port"${RESTORE}
echo ""
echo ${YELLOW}:: NOTE: Make sure ONLY ONE .qcow2 file is${RESTORE}
echo ${YELLOW}in the current directory${RESTORE}
echo ""
echo ${YELLOW}:: Tip: Try setting DNS manually if QEMU user network doesn\'t work well. ${RESTORE}
echo ${YELLOW}:: HOWTO -\> https://serverfault.com/a/810639 ${RESTORE}
echo ""
echo ${YELLOW}:: Tip: If \'ping\' reports permission error, try reinstalling \'iputils\'. ${RESTORE}
echo ${YELLOW}:: HOWTO -\> \'sudo dnf reinstall iputils\' ${RESTORE}
echo ""

sleep 2

eval $cmd
````

qemu 启动后再次查看硬盘信息

````
$ fdisk -l
Disk /dev/vda: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: C1ED27BF-65EA-4BF3-A537-BBD23DF7C75B

Device       Start      End  Sectors  Size Type
/dev/vda1     2048  1050623  1048576  512M BIOS boot
/dev/vda2  1050624 41943006 40892383 19.5G Linux filesystem


Disk /dev/vdb: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
````

可以看到新添加磁盘的信息

### 4.  qemu 中创建 swap 分区

有些测试用例需要用到 swap 分区，例如FS_Device 测试套的 oe_test_swap_close_temp，在 qemu 中创建 swap 分区的方法如下：

````
$ dd if=/dev/zero of=/swap bs=1G count=1   //使用dd创建一个1G大小的swap文件
$ mkswap /swap      //创建swap空间
$ swapon /swap      //启用swap空间
$ echo '/swap swap swap defaults 0 0' >> /etc/fstab    //写入fstab以在启动时启用swap
$ free -m
               total        used        free      shared  buff/cache   available
Mem:            7926         418        6237           3        1444        7507
Swap:           1023           0        1023
````

