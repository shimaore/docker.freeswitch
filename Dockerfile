FROM alpine:edge
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

COPY modules.conf.in /tmp/modules.conf.in
COPY build.sh /tmp/build.sh
COPY patches /tmp/patches

RUN apk add --update --no-cache \
  libedit \
  libjpeg-turbo \
  libressl2.7-libtls \
  ncurses-libs \
  pcre \
  speex \
  speexdsp \
  sqlite-libs \
  zlib \
  opus \
  libogg libvorbis lame-dev libshout mpg123-dev \
  libsndfile flac libogg libvorbis \
  tiff \
  && \
  apk add --update --no-cache --virtual .build-deps \
  patch \
# bootstrapping
  autoconf \
  automake \
  libtool \
# clone
  ca-certificates \
  git \
# build
  build-base \
  bash \
  bsd-compat-headers \
  coreutils \
  util-linux-dev \
  linux-headers \

# core
  curl-dev \
  gnutls-dev \
  ldns-dev \
  libedit-dev \
  libjpeg-turbo-dev \
  ncurses-dev \
  pcre-dev \
  libressl-dev \
  speex-dev \
  speexdsp-dev \
  sqlite-dev \
  zlib-dev \
  yasm \
# mod_av
    # libavformat-dev libswscale-dev \
# mod_cv
    # libopencv-dev \
# mod_mp4
    # libmp4v2-dev \ # NOT in Alpine
# mod_ilbc
    # ilbc-dev \
# mod_opus
    opus-dev \
# mod_silk
    # libsilk-dev \  # NOT in Alpine
# mod_siren
    # libg7221-dev \ # NOT in Alpine
# mod_shout
    libogg-dev libvorbis-dev lame-dev libshout-dev mpg123-dev \
# mod_sndfile
    libsndfile-dev flac-dev libogg-dev libvorbis-dev \
# mod_spandsp
    tiff-dev \
# sounds
    curl \
    jq \
    sox \
  && \
  addgroup -S freeswitch && \
  adduser -S -D -s /sbin/nologin -G freeswitch -g FreeSwitch freeswitch && \
  mkdir -p /opt/freeswitch && \
  chown -R freeswitch.freeswitch /opt/freeswitch && \
  chmod +x /tmp/build.sh && \
  su -s /bin/sh -c /tmp/build.sh freeswitch && \
  rm -f /tmp/build.sh && \
# Cleanup build dependencies
  apk del .build-deps && \
  echo Done

USER freeswitch
