FROM shimaore/debian:2.0.12
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

COPY modules.conf.in /tmp/modules.conf.in
COPY build.sh /tmp/build.sh

# This version tries to be modelled after FreeSwitch's own
#  debian/bootstrap.sh (section on `Build-Depends`)
# especially by re-using the lists of `Build-Depends from
#  debian/control-modules

RUN apt-get update && apt-get install -y --no-install-recommends \

# bootstrapping
  autoconf \
  automake \
  libtool \
  libtool-bin \

# clone
  ca-certificates \
  git \

# sounds
  curl \
  jq \
  sox \

# build
  build-essential \

# core
  libcurl4-openssl-dev \
  libedit-dev \
  libjpeg-dev \
  libpcre3-dev \
  libspeexdsp-dev \
  libsqlite3-dev \
  libssl-dev \
  uuid-dev \
  zlib1g-dev \

  yasm \

# mod_av
    # libavformat-dev libswscale-dev \
# mod_cv
    # libopencv-dev \
# mod_mp4
    libmp4v2-dev \
# mod_ilbc
    # libilbc-dev \  # NOT in Debian
# mod_opus
    libopus-dev \
# mod_silk
    # libsilk-dev \  # NOT in Debian
# mod_siren
    # libg7221-dev \ # NOT in Debian
# mod_shout
    libogg-dev libvorbis-dev libmp3lame-dev libshout3-dev libmpg123-dev \
# mod_sndfile
    libsndfile1-dev libflac-dev libogg-dev libvorbis-dev \

  && \

  useradd -m freeswitch && \
  mkdir -p /opt/freeswitch && \
  chown -R freeswitch.freeswitch /opt/freeswitch && \

  chmod +x /tmp/build.sh && \
  su -c /tmp/build.sh freeswitch && \

  rm -f /tmp/build.sh && \

# Cleanup build dependencies
  apt-get purge -y \

# bootstrapping
    autoconf \
    automake \
    libtool \
    libtool-bin \

# clone
    ca-certificates \
    git \

# sounds
    curl \
    jq \
    sox \

# build
    build-essential \
    cpp-5 \
    gcc-5 \

# core
    yasm \

  && \
  apt-get autoremove -y && apt-get clean && \
  find /usr/share/doc /var/lib/apt/lists -type f -delete && \
  echo Done

USER freeswitch
