#!/bin/bash
# This simply test that FreeSwitch successfully starts.
set -e
docker build -t shimaore-freeswitch-test-0001 0001/
echo 'shutdown' | docker run --rm -t -i --name test-0001 shimaore-freeswitch-test-0001
docker rmi shimaore-freeswitch-test-0001
