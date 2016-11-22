#!/bin/bash
set -e

echo 'Starting build.'
cd /home/freeswitch
git clone -b v1.6 https://stash.freeswitch.org/scm/fs/freeswitch.git freeswitch.git
cd freeswitch.git
git checkout -f f18f82cffee354543331ead39b3eb6f8e40ebd9e
cp /tmp/modules.conf.in build/modules.conf.in
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
