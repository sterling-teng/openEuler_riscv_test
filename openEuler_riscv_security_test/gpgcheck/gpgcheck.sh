#!/usr/bin/bash

dnf update
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-openEuler
pkglist=$(dnf list available | sed '1d' | sed '1d' | awk '{print $1}')
rm -rf gpgcheck
for pkg in $pkglist
do
  echo $pkg
  if [[ $pkg != *".src" ]]; then
    mkdir gpgcheck && cd gpgcheck
    dnf download $pkg
    echo "ls $(ls)"
    rpmname=$(ls)
    rpm -K $rpmname | grep "digests signatures OK"
    if [ $? -eq 0 ]; then
       echo "$pkg gpg check success"
    else
       echo "$pkg gpg check failed"
    fi
    cd .. && rm -rf gpgcheck
  fi
done


