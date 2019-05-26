#!/bin/sh
set -e

echo 'Starting build.'
cd $HOME
git clone -b master https://gitlab.k-net.fr/ccnq/freeswitch-original.git freeswitch.git
cd freeswitch.git
git checkout 886b2d39aa418e8e4ca67335c4448f79f1da9cc5
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
