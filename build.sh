#!/bin/sh
set -e

echo 'Starting build.'
cd $HOME
git clone -b master https://gitlab.k-net.fr/ccnq/freeswitch-original.git freeswitch.git
cd freeswitch.git
git checkout 9127c41316b41f1bb00f72515de3f825595f6e09
cp /tmp/modules.conf.in build/modules.conf.in
for f in /tmp/patches/*; do patch -p1 < $f; done
sh bootstrap.sh -j
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
