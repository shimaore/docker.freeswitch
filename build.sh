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

if $WITH_SOUNDS; then
make sounds-en-us-callie-8000-install
fi

git log | gzip > /opt/freeswitch/.git.log.gz
cd ..
rm -rf freeswitch.git

if $WITH_SOUNDS; then
# Install fr-sounds
git clone https://github.com/shimaore/fr-sounds.git fr-sounds.git
cd fr-sounds.git
git checkout 02a7d9dcfa9f0d3b0041da0d0ecd3c67d0380679
./build.sh
mkdir -p /opt/freeswitch/share/freeswitch/sounds
tar xzvf freeswitch-sounds-fr-fr-sibylle-8000-1.0.0.tar.gz -C /opt/freeswitch/share/freeswitch/sounds/
cd ..
rm -rf fr-sounds.git
fi

# Cleanup, only keep /bin, /lib and /mod
rm -rf /opt/freeswitch/conf
rm -rf /opt/freeswitch/scripts
rm -rf /opt/freeswitch/htdocs
rm -rf /opt/freeswitch/grammar
echo 'Build done.'
