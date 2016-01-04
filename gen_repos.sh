#!/usr/bin/env bash

ROOT=`pwd`
DEB_DIR=$ROOT/apt/debian/
RPM_DIR=$ROOT/yum/

cd $DEB_DIR
dpkg-sig --sign builder *.deb
apt-ftparchive packages . > Packages
gzip -c Packages > Packages.gz
apt-ftparchive release . > Release
gpg --clearsign -o InRelease Release
gpg -abs -o Release.gpg Release
cd -
createrepo -v -s sha1 $RPM_DIR
