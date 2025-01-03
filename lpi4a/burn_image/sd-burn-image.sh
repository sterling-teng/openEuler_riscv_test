#!/bin/bash

set -ex

IMG="./images/openEuler-24.03SP1-V1-base-lpi4a-devel-uefi.img"
TF="/dev/sdb"

sudo dd if=${IMG} of=${TF} bs=1M iflag=fullblock oflag=direct conv=fsync status=progress


# set default=0
# set timeout_style=menu
# set timeout=5

# set term="vt100"

# menuentry 'openEuler24.03 vmlinuz-6.6.0 | Milk-V Pioneer' {
#         linux /vmlinuz-6.6.0-14.0.0.10.oe2403.riscv64 rootwait root=/dev/mmcblk1p3 console=ttyS0,115200 earlycon nvme.use_threaded_interrupts=1 nvme_core.io_timeout=3000
#         initrd /initramfs-6.6.0-14.0.0.10.oe2403.riscv64.img
# }
