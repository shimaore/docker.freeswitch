#!/bin/sh
set -e

docker build -t shimaore/freeswitch .

# COMMIT=`docker run --rm=true -t shimaore/freeswitch head -1 /usr/local/freeswitch/.git.log | cut -d ' ' -f 2`
# docker tag 'shimaore/freeswitch:latest' "shimaore/freeswitch:${COMMIT}"

# echo "Tests"
# (cd test && for test in ./*.sh; do "$test"; done)
