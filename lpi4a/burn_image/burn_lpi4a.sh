#! /bin/sh
# Script to flash images via fastboot, edit image path first
#

sudo ./fastboot flash ram ./images/u-boot-with-spl-lpi4a-16g.bin
sudo ./fastboot reboot
sleep 10
sudo ./fastboot flash uboot ./images/u-boot-with-spl-lpi4a-16g.bin
sudo ./fastboot flash boot ./images/boot-20231130-224942.ext4
sudo ./fastboot flash root ./images/root-20231130-224942.ext4