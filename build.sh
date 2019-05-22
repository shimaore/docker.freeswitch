#!/bin/sh
set -e

echo 'Starting build.'
cd $HOME
git clone -b master https://gitlab.k-net.fr/ccnq/freeswitch-original.git freeswitch.git
cd freeswitch.git
git checkout a5cecbfc2a5e0ea2d3f45489f2681a67e32ce955
cp /tmp/modules.conf.in build/modules.conf.in
sh bootstrap.sh -j
for f in /tmp/patches/*; do patch -p1 < $f; done
./configure --prefix=/opt/freeswitch
make
make install

git log | gzip > /opt/freeswitch/.git.log.gz
cd ..
rm -rf freeswitch.git

# Cleanup, only keep /bin, /lib and /mod
rm -rf /opt/freeswitch/conf
rm -rf /opt/freeswitch/scripts
rm -rf /opt/freeswitch/htdocs
rm -rf /opt/freeswitch/grammar
echo 'Build done.'
