FROM shimaore/debian:2.0.5
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  git \
  jq \
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
  sox \
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
  make sounds-en-us-callie-8000-install && \
  git log | gzip > /opt/freeswitch/.git.log.gz && \
  cd .. && \
  rm -rf freeswitch.git
RUN \
  git clone https://github.com/shimaore/fr-sounds.git fr-sounds.git && \
  cd fr-sounds.git && \
  git checkout 02a7d9dcfa9f0d3b0041da0d0ecd3c67d0380679 && \
  ./build.sh && \
  mkdir -p /opt/freeswitch/share/freeswitch/sounds && \
  tar xzvf freeswitch-sounds-fr-fr-sibylle-8000-1.0.0.tar.gz -C /opt/freeswitch/share/freeswitch/sounds/ && \
  cd .. && \
  rm -rf fr-sounds.git && \
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
  jq \
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
  sox \
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
