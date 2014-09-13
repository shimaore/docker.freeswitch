FROM shimaore/debian
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends git build-essential automake autoconf libtool wget python zlib1g-dev libjpeg-dev libncurses5-dev libssl-dev libpcre3-dev libcurl4-openssl-dev libldns-dev libedit-dev libspeexdsp-dev  libspeexdsp-dev libsqlite3-dev
RUN apt-get install -y pkg-config uuid-dev
RUN git clone -b production-v1.4 git://shimaore.net/git/freeswitch.git freeswitch.git
RUN cd freeswitch.git && sh bootstrap.sh
RUN cd freeswitch.git && ./configure
RUN cd freeswitch.git && make
RUN cd freeswitch.git && make install
# Cleanup, only keep /bin, /lib and /mod
RUN echo 'rm -rf freeswitch.git /usr/local/freeswitch/{conf,scripts,db,htdocs,recordings,run,log,grammar}' | /bin/bash
