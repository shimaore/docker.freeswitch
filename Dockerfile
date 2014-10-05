FROM shimaore/debian
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends git build-essential automake autoconf libtool wget python zlib1g-dev libjpeg-dev libncurses5-dev libssl-dev libpcre3-dev libcurl4-openssl-dev libldns-dev libedit-dev libspeexdsp-dev  libspeexdsp-dev libsqlite3-dev
RUN apt-get install -y --no-install-recommends pkg-config uuid-dev
VOLUME /src/tmp
WORKDIR /srv/tmp
RUN git clone -b production-v1.4 git://shimaore.net/git/freeswitch.git freeswitch.git
WORKDIR freeswitch.git
  RUN sh bootstrap.sh
  RUN ./configure
  RUN make
  RUN make install
WORKDIR ..
RUN cd freeswitch.git && git log > /usr/local/freeswitch/.git.log
RUN apt-get purge -y pkg-config git build-essential automake autoconf libtool wget libncurses5-dev libssl-dev libpcre3-dev libcurl4-openssl-dev libldns-dev libedit-dev libsqlite3-dev uuid-dev
# Cleanup, only keep /bin, /lib and /mod
RUN echo 'rm -rf freeswitch.git /usr/local/freeswitch/{conf,scripts,db,htdocs,recordings,run,log,grammar}' | /bin/bash
RUN apt-get install -y --no-install-recommends libncurses5 libssl1.0.0 libpcre3 libcurl3 libldns1 libedit2 libsqlite3-0 libuuid1
RUN apt-get autoremove -y
