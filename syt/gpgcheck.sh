#!/usr/bin/bash

dnf update
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-openEuler
rm -rf gpgcheck
mkdir gpgcheck && cd gpgcheck
pkglist=$(dnf list available | awk '/Available Packages/{flag=1; next} flag' | awk '{print $1}')
yumdownloader $pkglist --destdir=.
pkglist=$(ls)
for pkg in $pkglist
do
  echo $pkg
  if [[ $pkg != *".src" && $pkg != *"debug"* ]]; then
    rpm -K $pkg | grep "digests signatures OK"
    if [ $? -eq 0 ]; then
       echo "$pkg gpg check success"
    else
       echo "$pkg gpg check failed"
    fi
  fi
done


