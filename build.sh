#!/bin/bash
set -e

echo 'Starting build.'
cd /home/freeswitch
git clone -b test-FS-9776 https://gitlab.k-net.fr/shimaore/freeswitch.git freeswitch.git
cd freeswitch.git
git checkout 4cab46834c643767a06a22230bf3afc180af2acc
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
