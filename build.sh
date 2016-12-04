#!/bin/bash
set -e

echo 'Starting build.'
cd /home/freeswitch
git clone -b master https://stash.freeswitch.org/scm/fs/freeswitch.git freeswitch.git
cd freeswitch.git
git show
cp /tmp/modules.conf.in build/modules.conf.in
sh bootstrap.sh -j
./configure --prefix=/opt/freeswitch --disable-srtp
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
