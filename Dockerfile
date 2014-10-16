FROM shimaore/debian
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends git build-essential automake autoconf libtool wget python zlib1g-dev libjpeg-dev libncurses5-dev libssl-dev libpcre3-dev libcurl4-openssl-dev libldns-dev libedit-dev libspeexdsp-dev  libspeexdsp-dev libsqlite3-dev
RUN apt-get install -y --no-install-recommends pkg-config uuid-dev

# Build
RUN useradd -m freeswitch
USER freeswitch
WORKDIR /home/freeswitch
RUN git clone -b production-v1.4 git://shimaore.net/git/freeswitch.git freeswitch.git
WORKDIR freeswitch.git
RUN sh bootstrap.sh
RUN ./configure --prefix=/usr/local/freeswitch
RUN make
# Install
USER root
RUN make install
RUN git log > /usr/local/freeswitch/.git.log

# Cleanup source
USER freeswitch
WORKDIR ..
RUN rm -rf freeswitch.git
# Cleanup build dependencies
USER root
RUN apt-get purge -y pkg-config git build-essential automake autoconf libtool wget libncurses5-dev libssl-dev libpcre3-dev libcurl4-openssl-dev libldns-dev libedit-dev libsqlite3-dev uuid-dev
# Cleanup, only keep /bin, /lib and /mod
RUN echo 'rm -rf /usr/local/freeswitch/{conf,scripts,db,htdocs,recordings,grammar}' | /bin/bash
RUN echo 'chown -R freeswitch.freeswitch /usr/local/freeswitch/{run,log}' | /bin/bash
# Install dependencies
RUN apt-get install -y --no-install-recommends libncurses5 libssl1.0.0 libpcre3 libcurl3 libldns1 libedit2 libsqlite3-0 libuuid1
RUN apt-get autoremove -y

USER freeswitch
