pkglist=$(dnf list available | awk '/Available Packages/{flag=1; next} flag' | awk '{print $1}')
yumdownloader $pkglist --destdir=.
