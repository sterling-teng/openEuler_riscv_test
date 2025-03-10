#!/usr/bin/bash

dnf update
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-openEuler
pkglist=$(dnf list available | awk '/Available Packages/{flag=1; next} flag' | awk '{print $1}')
rm -rf gpgcheck
mkdir gpgcheck && cd gpgcheck
for pkg in $pkglist
do
  echo $pkg
  if [[ $pkg != *".src" && $pkg != *"debug"* ]]; then
    dnf download $pkg
    echo "rpm pkg: $(ls)"
    rpmname=$(ls)
    rpm -K $rpmname | grep "digests signatures OK"
    if [ $? -eq 0 ]; then
       echo "$pkg gpg check success"
    else
       echo "$pkg gpg check failed"
    fi
    rm -rf ./*
  fi
done


