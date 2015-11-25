FROM shimaore/debian:2.0.4
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  git \
  libcurl4-openssl-dev \
  libedit-dev \
  libjpeg-dev \
  libldns-dev \
  libncurses5-dev \
  libpcre3-dev \
  libshout3-dev \
  libspeexdsp-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  libtool-bin \
  pkg-config \
  python \
  uuid-dev \
  wget \
  zlib1g-dev

# Build
RUN useradd -m freeswitch
USER freeswitch
WORKDIR /home/freeswitch
RUN git clone -b v1.6 https://stash.freeswitch.org/scm/fs/freeswitch.git freeswitch.git
WORKDIR freeswitch.git
# Lock each of our release to a specific codeset.
RUN git checkout 70b8c177639a980c0ef12f2f826cdcc3b5a9c8a2
COPY modules.conf.in build/modules.conf.in
RUN sh bootstrap.sh
RUN ./configure --prefix=/opt/freeswitch
RUN make

# Install
USER root
RUN mkdir -p /opt/freeswitch
RUN chown -R freeswitch.freeswitch /opt/freeswitch
USER freeswitch
RUN make install
RUN git log > /opt/freeswitch/.git.log

# Cleanup source
WORKDIR ..
RUN rm -rf freeswitch.git

# Cleanup, only keep /bin, /lib and /mod
RUN echo 'rm -rf /opt/freeswitch/{conf,scripts,htdocs,grammar}' | /bin/bash

# Cleanup build dependencies
USER root
RUN apt-get purge -y \
  autoconf \
  automake \
  build-essential \
  git \
  libcurl4-openssl-dev \
  libedit-dev \
  libldns-dev \
  libncurses5-dev \
  libpcre3-dev \
  libshout3-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  pkg-config \
  uuid-dev \
  wget

# Install dependencies
RUN apt-get install -y --no-install-recommends \
    libcurl3 \
    libedit2 \
    libldns1 \
    libncurses5 \
    libpcre3 \
    libshout3 \
    libsqlite3-0 \
    libssl1.0.0 \
    libuuid1
RUN apt-get autoremove -y
RUN apt-get clean

USER freeswitch
