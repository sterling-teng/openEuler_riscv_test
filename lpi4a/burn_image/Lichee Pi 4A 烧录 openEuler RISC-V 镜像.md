### Lichee Pi 4A 烧录 openEuler RISC-V 镜像

本文是使用 Ubuntu OS 烧录 openEuler RISC-V 镜像

#### 1. 下载烧录工具

下载烧录工具 [burn_tools.zip](https://pan.baidu.com/e/1xH56ZlewB6UOMlke5BrKWQ)，解压

````
$ unzip burn_tools.zip
$ cd burn_tools/linux
````

给 fastboot 赋予可执行权限，否则会提示 "sudo: ./fastboot: command not found"

````
$ sudo chmod +x fastboot
````

#### 2. 下载镜像

根据需要，选择和下载 [openEuler RISC-V Lichee Pi 4A 镜像](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/lpi4a/)

````
$ mkdir images
$ cd images
$ wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/lpi4a/u-boot-with-spl-lpi4a-16g.bin
$ wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/lpi4a/boot-20231130-224942.ext4.zst
$ wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/lpi4a/root-20231130-224942.ext4.zst
$ unzstd boot-20231130-224942.ext4.zst
$ unzstd root-20231130-224942.ext4.zst
````

#### 3. 烧录

按住板上的BOOT键不放，然后插入USB-C 线，线的另一头接PC，即可进入USB烧录模式

确认进入USB烧录模式

````
$ lsusb
Bus 004 Device 003: ID 0bda:8153 Realtek Semiconductor Corp. RTL8153 Gigabit Ethernet Adapter
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 012: ID 2345:7654 T-HEAD USB download gadget
Bus 003 Device 004: ID 0e0f:0002 VMware, Inc. Virtual USB Hub
Bus 003 Device 003: ID 0e0f:0002 VMware, Inc. Virtual USB Hub
Bus 003 Device 010: ID 2109:8817 VIA Labs, Inc. USB Billboard Device   
Bus 003 Device 002: ID 0e0f:0003 VMware, Inc. Virtual Mouse
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 0e0f:0002 VMware, Inc. Virtual USB Hub
Bus 001 Device 002: ID 0e0f:0008 VMware, Inc. Virtual Bluetooth Adapter
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
````

执行命令开始烧录镜像，先检查并格式化分区

````
$ sudo ./fastboot flash ram ./images/u-boot-with-spl-lpi4a-16g.bin
Sending 'ram' (940 KB)                             OKAY [  0.329s]
Writing 'ram'                                      OKAY [  0.002s]
Finished. Total time: 0.337s
````

重启

````
$ sudo ./fastboot reboot
Rebooting                                          OKAY [  0.010s]
Finished. Total time: 0.270s
````

烧录启动引导镜像-uboot

````
$ sudo ./fastboot flash uboot ./images/u-boot-with-spl-lpi4a-16g.bin
Sending 'uboot' (940 KB)                           OKAY [  0.185s]
Writing 'uboot'                                    OKAY [  0.065s]
Finished. Total time: 0.312s
````

烧录启动分区-boot

````
$ sudo ./fastboot flash boot ./images/boot-20231130-224942.ext4
Invalid sparse file format at header magic
Sending sparse 'boot' 1/3 (111956 KB)              OKAY [  8.040s]
Writing 'boot'                                     OKAY [  0.741s]
Sending sparse 'boot' 2/3 (110852 KB)              OKAY [  8.176s]
Writing 'boot'                                     OKAY [  0.554s]
Sending sparse 'boot' 3/3 (53736 KB)               OKAY [  3.991s]
Writing 'boot'                                     OKAY [  1.415s]
Finished. Total time: 23.867s
````

烧录操作系统根分区-root

````
$ sudo ./fastboot flash root ./images/root-20231130-224942.ext4
Invalid sparse file format at header magic
Sending sparse 'root' 1/36 (114452 KB)             OKAY [  8.034s]
Writing 'root'                                     OKAY [  0.702s]
Sending sparse 'root' 2/36 (114684 KB)             OKAY [  8.598s]
Writing 'root'                                     OKAY [  0.501s]
Sending sparse 'root' 3/36 (108628 KB)             OKAY [  7.687s]
Writing 'root'                                     OKAY [  0.479s]
Sending sparse 'root' 4/36 (106274 KB)             OKAY [  7.735s]
Writing 'root'                                     OKAY [  0.774s]
Sending sparse 'root' 5/36 (100640 KB)             OKAY [  9.164s]
Writing 'root'                                     OKAY [  0.518s]
Sending sparse 'root' 6/36 (114685 KB)             OKAY [ 10.058s]
Writing 'root'                                     OKAY [  0.601s]
Sending sparse 'root' 7/36 (104274 KB)             OKAY [  7.768s]
Writing 'root'                                     OKAY [  0.749s]
Sending sparse 'root' 8/36 (113802 KB)             OKAY [  8.433s]
Writing 'root'                                     OKAY [  0.711s]
Sending sparse 'root' 9/36 (114684 KB)             OKAY [  8.517s]
Writing 'root'                                     OKAY [  0.488s]
Sending sparse 'root' 10/36 (114684 KB)            OKAY [  7.917s]
Writing 'root'                                     OKAY [  0.490s]
Sending sparse 'root' 11/36 (114684 KB)            OKAY [  9.380s]
Writing 'root'                                     OKAY [  0.501s]
Sending sparse 'root' 12/36 (114684 KB)            OKAY [  8.622s]
Writing 'root'                                     OKAY [  0.485s]
Sending sparse 'root' 13/36 (114521 KB)            OKAY [  8.122s]
Writing 'root'                                     OKAY [  0.671s]
Sending sparse 'root' 14/36 (113728 KB)            OKAY [  8.274s]
Writing 'root'                                     OKAY [  1.488s]
Sending sparse 'root' 15/36 (114685 KB)            OKAY [  9.053s]
Writing 'root'                                     OKAY [  0.718s]
Sending sparse 'root' 16/36 (113540 KB)            OKAY [  9.273s]
Writing 'root'                                     OKAY [  0.491s]
Sending sparse 'root' 17/36 (111900 KB)            OKAY [  9.277s]
Writing 'root'                                     OKAY [  0.538s]
Sending sparse 'root' 18/36 (114436 KB)            OKAY [  8.388s]
Writing 'root'                                     OKAY [  0.572s]
Sending sparse 'root' 19/36 (114684 KB)            OKAY [  8.265s]
Writing 'root'                                     OKAY [  0.585s]
Sending sparse 'root' 20/36 (114546 KB)            OKAY [  8.179s]
Writing 'root'                                     OKAY [  0.708s]
Sending sparse 'root' 21/36 (114165 KB)            OKAY [  8.378s]
Writing 'root'                                     OKAY [  1.133s]
Sending sparse 'root' 22/36 (110540 KB)            OKAY [  8.238s]
Writing 'root'                                     OKAY [  0.536s]
Sending sparse 'root' 23/36 (109652 KB)            OKAY [  7.930s]
Writing 'root'                                     OKAY [  0.958s]
Sending sparse 'root' 24/36 (114684 KB)            OKAY [  7.856s]
Writing 'root'                                     OKAY [  1.005s]
Sending sparse 'root' 25/36 (105640 KB)            OKAY [  7.794s]
Writing 'root'                                     OKAY [  0.458s]
Sending sparse 'root' 26/36 (101892 KB)            OKAY [  7.251s]
Writing 'root'                                     OKAY [  0.520s]
Sending sparse 'root' 27/36 (101912 KB)            OKAY [  7.094s]
Writing 'root'                                     OKAY [  0.450s]
Sending sparse 'root' 28/36 (114649 KB)            OKAY [  8.488s]
Writing 'root'                                     OKAY [  1.553s]
Sending sparse 'root' 29/36 (110539 KB)            OKAY [  8.412s]
Writing 'root'                                     OKAY [  0.920s]
Sending sparse 'root' 30/36 (114549 KB)            OKAY [  8.614s]
Writing 'root'                                     OKAY [  0.622s]
Sending sparse 'root' 31/36 (108799 KB)            OKAY [  8.540s]
Writing 'root'                                     OKAY [  0.858s]
Sending sparse 'root' 32/36 (100892 KB)            OKAY [  7.327s]
Writing 'root'                                     OKAY [  0.440s]
Sending sparse 'root' 33/36 (114684 KB)            OKAY [  8.115s]
Writing 'root'                                     OKAY [  1.494s]
Sending sparse 'root' 34/36 (114684 KB)            OKAY [  8.385s]
Writing 'root'                                     OKAY [  0.489s]
Sending sparse 'root' 35/36 (113781 KB)            OKAY [  8.624s]
Writing 'root'                                     OKAY [  0.610s]
Sending sparse 'root' 36/36 (12124 KB)             OKAY [  0.972s]
Writing 'root'                                     OKAY [  0.082s]
Finished. Total time: 331.617s
````

以上烧录命令可以用一个 [burn_lpi4a.sh](./burn_lpi4a.sh) 脚本来执行 

烧录完成后重启板子即可

参考：

https://wiki.sipeed.com/hardware/zh/lichee/th1520/lpi4a/4_burn_image.html