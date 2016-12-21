#!/bin/bash
set -e

echo 'Starting build.'
cd /home/freeswitch
git clone -b test-FS-9776 https://freeswitch.org/stash/scm/~stephalnet/freeswitch.git freeswitch.git
cd freeswitch.git
git checkout d0acd9b091ecdcf3b8c1d91cf5bf68c0c754a9e1
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
