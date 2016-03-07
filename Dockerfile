FROM shimaore/debian:2.0.6
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
  libmp3lame-dev \
  libmpg123-dev \
  libncurses5-dev \
  libpcre3-dev \
  libshout3-dev \
  libsndfile-dev \
  libspeexdsp-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  libtool-bin \
  pkg-config \
  python \
  uuid-dev \
  wget \
  zlib1g-dev \
  && \
  useradd -m freeswitch && \
  mkdir -p /opt/freeswitch && \
  chown -R freeswitch.freeswitch /opt/freeswitch

USER freeswitch
COPY modules.conf.in /tmp/modules.conf.in
WORKDIR /home/freeswitch
RUN \
  git clone -b v1.6 https://stash.freeswitch.org/scm/fs/freeswitch.git freeswitch.git && \
  cd freeswitch.git && \
  git checkout 70b8c177639a980c0ef12f2f826cdcc3b5a9c8a2 && \
  cp /tmp/modules.conf.in build/modules.conf.in && \
  sh bootstrap.sh && \
  ./configure --prefix=/opt/freeswitch && \
  make && \
  make install && \
  git log > /opt/freeswitch/.git.log && \
  cd .. && \
  rm -rf freeswitch.git && \
  # Cleanup, only keep /bin, /lib and /mod
  echo 'rm -rf /opt/freeswitch/{conf,scripts,htdocs,grammar}' | /bin/bash

# Cleanup build dependencies
USER root
RUN apt-get purge -y \
  autoconf \
  automake \
  build-essential \
  cpp-5 \
  gcc-5 \
  git \
  libcurl4-openssl-dev \
  libedit-dev \
  libjpeg-dev \
  libldns-dev \
  libmp3lame-dev \
  libmpg123-dev \
  libncurses5-dev \
  libpcre3-dev \
  libshout3-dev \
  libsndfile-dev \
  libspeexdsp-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  pkg-config \
  uuid-dev \
  wget \
  zlib1g-dev \
  && \
  apt-get install -y --no-install-recommends \
    libcurl3 \
    libedit2 \
    libjpeg62-turbo \
    libldns1 \
    libmp3lame0 \
    libmpg123-0 \
    libncurses5 \
    libpcre3 \
    libshout3 \
    libsndfile1 \
    libspeexdsp1 \
    libsqlite3-0 \
    libssl1.0.0 \
    libuuid1 \
    zlib1g \
  && \
  apt-get autoremove -y && apt-get clean

USER freeswitch
