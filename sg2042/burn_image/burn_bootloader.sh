#!/bin/bash

set -ex

IMG="firmware_single_sg2042-dev-6.6.img"
TF="/dev/sdb"

sudo dd if=${IMG} of=${TF} bs=1M iflag=fullblock oflag=direct conv=fsync status=progress


# download bootloader url: https://github.com/sophgo/bootloader-riscv/actions/runs/8577991354/artifacts/1390186911

# ouuleilei:
# https://github.com/sophgo/bootloader-riscv/actions/runs/8577991354/artifacts/1390186911

# ouuleilei:
# 就下载这里的 sophgo-bootloader-single-sg2042-master

# ouuleilei:
# 解压出来里面有一个 Img和一个 bin

# ouuleilei:
# 把img烧录至 sd卡上

# ouuleilei:
# mv bootloader/riscv64/riscv64_Image bootloader/riscv64/linuxboot    
# cp bootloader/riscv64/SG2042.fd bootloader/riscv64/riscv64_Image

# 然后进sd卡里 把文件替换下