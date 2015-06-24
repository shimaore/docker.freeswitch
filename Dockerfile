FROM shimaore/debian:2.0.0
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
RUN git clone -b production-v1.4 https://gitlab.k-net.fr/shimaore/freeswitch.git freeswitch.git
WORKDIR freeswitch.git
# Lock each of our release to a specific codeset.
RUN git checkout 036f0761ace3720730dc18f90f8a428f5e24c8a6
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

# Install sounds en-US and MoH
RUN make cd-sounds-install cd-moh-install

# Install sounds fr-FR
USER root
RUN apt-get install -y --no-install-recommends \
  sox
USER freeswitch
RUN git clone https://gitlab.k-net.fr/shimaore/fr-sounds.git fr-sounds.git
WORKDIR fr-sounds.git
RUN ./build.sh && mv fr /opt/freeswitch/sounds/
WORKDIR ..

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
  libsqlite3-dev \
  libssl-dev \
  libtool \
  pkg-config \
  sox \
  uuid-dev \
  wget

# Install dependencies
RUN apt-get install -y --no-install-recommends \
    libcurl3 \
    libedit2 \
    libldns1 \
    libncurses5 \
    libpcre3 \
    libsqlite3-0 \
    libssl1.0.0 \
    libuuid1
RUN apt-get autoremove -y
RUN apt-get clean

USER freeswitch
