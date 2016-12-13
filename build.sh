#!/bin/bash
set -e

echo 'Starting build.'
cd /home/freeswitch
git clone -b FS-9776 https://freeswitch.org/stash/scm/~stephalnet/freeswitch.git freeswitch.git
cd freeswitch.git
  git config --global user.email "stephane@shimaore.net"
  git config --global user.name "shimaore"
git merge origin/FS-9785
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
