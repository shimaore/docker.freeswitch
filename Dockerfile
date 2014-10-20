FROM shimaore/debian
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  build-essential \
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
  pkg-config \
  python \
  uuid-dev \
  wget \
  zlib1g-dev

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
  uuid-dev \
  wget

# Cleanup, only keep /bin, /lib and /mod
RUN echo 'rm -rf /usr/local/freeswitch/{conf,scripts,htdocs,grammar}' | /bin/bash
RUN echo 'chown -R freeswitch.freeswitch /usr/local/freeswitch/{run,log,db,recordings}' | /bin/bash
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

USER freeswitch
