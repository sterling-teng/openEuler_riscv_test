sg2042 烧录 openEuler RISC-V 24.03 LTS镜像方法

#### 1. 烧录启动固件到sd卡

下载启动固件地址：https://github.com/sophgo/bootloader-riscv/actions/runs/8461433685/artifacts/1365272016

解压固件，解压出来包括一个 img 和一个 bin，将 img 烧录到 sd 卡里，并修改文件

````
$ unzip sophgo-bootloader-single-sg2042-master.zip
$ sudo dd if=firmware_single_sg2042-master.img   of=/dev/sda bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
$ mount /dev/sdb1  /mnt/
$ sudo mv /mnt/riscv64/riscv64_Image /mnt/riscv64/linuxboot
$ sudo cp /mnt/riscv64/SG2042.fd /mnt/riscv64/riscv64_Image
$ sudo umount /mnt
````

#### 2. 烧录镜像到 ssd 固态硬盘

下载镜像地址：https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/2403LTS-test/v1/SG2042/

解压镜像，将镜像烧录到 ssd 中

````
$ unzstd openEuler-24.03-V1-base-sg2042-testing-uefi.img.zst
$ sudo dd if=openEuler-24.03-V1-base-sg2042-testing-uefi.img  of=/dev/sda bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
````

修改配置文件，设置root=/dev/nvme0n1p3（原来是root=/dev/mmcblk1p3）

````
$ sudo mount /dev/sdb2 /mnt 
$ sudo vim /mnt/efi/BOOT/grub.cfg
set default=0
set timeout_style=menu
set timeout=5

set term="vt100"

menuentry 'openEuler24.03 vmlinuz-6.1.61 | Milk-V Pioneer' {
        root=hd0,msdos2
        linux /vmlinuz-6.1.61-4.oe2403.riscv64 rootwait root=/dev/nvme0n1p3 console=ttyS0,115200 earlycon nvme.use_threaded_interrupts=1 nvme_core.io_timeout=3000
        initrd /initramfs-6.1.61-4.oe2403.riscv64.img
}
$ sudo umount /mnt
````

以上所有操作也可以在 windows 系统上执行，烧录可以用 balenaEtcher 

sd 和 ssd 烧录完成后，将他们都装回 sg2042 就可以开机启动了

#### 3. 烧录 openEuler RISC-V 24.09 镜像

windows 11 可以直接使用 balenaEtcher 工具烧录

##### 3.1 烧录 image

如果直接烧录到sd卡中，可以直接在sd卡里烧录 https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/24.09_artifacts/embedded_image/riscv64/SG2042/openEuler-24.09-riscv64-sg2042.img.zip

如果要烧录到ssd：

sd卡里烧录固件linuxboot https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/24.09_artifacts/embedded_image/riscv64/SG2042/sg2042_firmware_linuxboot.img.zip

ssd里烧录openEuler RISC-V image  https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/24.09_artifacts/embedded_image/riscv64/SG2042/openEuler-24.09-riscv64-sg2042.img.zip

烧录完成后无需做任何配置文件的修改

##### 3.2 iso安装

sd卡里烧录uefi固件 https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/24.09_artifacts/embedded_image/riscv64/SG2042/sg2042_firmware_uefi.img.zip

U盘烧录 iso 文件后进行安装 http://121.36.84.172/dailybuild/EBS-openEuler-24.09/openeuler-2024-09-26-08-33-57/ISO/riscv64/openEuler-24.09-riscv64-dvd.iso





参考

https://gitee.com/ouuleilei/working-documents/blob/master/RISC-V/openEuler/sg2042/Milk-V_Pioneer_Box_v1.3/image%E5%AE%89%E8%A3%85%E6%96%87%E6%A1%A3.md

