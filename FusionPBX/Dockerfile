# Seen at https://github.com/fusionpbx/fusionpbx-install.sh/commit/3a63d467fd7cf28f0c21d94a4872e5c5ebd674c7
#ARG DEBIAN_DIGEST
ARG DEBIAN_TAG
FROM debian:${DEBIAN_TAG}

# FreeSwitch
ARG FREESWITCH_VERSION
#RUN \
#  apt-get update \
#  && apt-get install -y gnupg2 wget lsb-release \
#  && wget -O - https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - \
#  && echo "deb http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list \
#  && echo "deb-src http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list \
#  && apt-get update && apt-get install -y freeswitch-meta-all=${FREESWITCH_VERSION}

ARG TOKEN=pat_Mnmv74xiYYANdheqEkkmaFWB
RUN apt-get update && apt-get install -y gnupg2 wget lsb-release git build-essential autoconf libtool libssl-dev  libtiff-dev zip pkg-config &&  apt-get clean
RUN git clone https://github.com/freeswitch/sofia-sip /usr/src/libs/sofia-sip
RUN cd /usr/src/libs/sofia-sip && ./bootstrap.sh && ./configure && make  && make install
RUN git clone https://github.com/freeswitch/spandsp.git /usr/src/libs/spandsp
RUN cd /usr/src/libs/spandsp && ./bootstrap.sh && ./configure && make  && make install
RUN wget --http-user=signalwire --http-password=$TOKEN -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg
RUN echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" > /etc/apt/auth.conf
RUN chmod 600 /etc/apt/auth.conf
RUN echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
RUN echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list
RUN apt-get update && apt-get install -y freeswitch-meta-all

# NGINX
RUN \
   apt-get install -y nginx
# PHP
RUN \
  apt-get update && apt-get install -y \
    php7.4 \
    php7.4-cli \
    php7.4-fpm \
    php7.4-pgsql \
    php7.4-sqlite3 \
    php7.4-odbc \
    php7.4-curl \
    php7.4-imap \
    php7.4-xml \
    php7.4-gd
RUN rm -f /etc/php/7.4/fpm/pool.d/*
RUN mkdir -p /var/run/php
# Supervisor
RUN \
  apt-get update && apt-get install -y supervisor
# FusionPBX
## Core
ARG FUSIONPBX_VERSION
WORKDIR /var/www/fusionpbx
RUN mkdir -p /var/cache/fusionpbx /var/www/fusionpbx \
  && git clone https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx \
  && mkdir -p /etc/fusionpbx
## Apps
RUN mkdir -p /var/www/fusionpbx/app/command \
  && git clone https://github.com/fusionpbx/fusionpbx-app-command.git /var/www/fusionpbx/app/command
# Permissions
RUN \
  chown -R freeswitch:freeswitch /var/cache/fusionpbx && \
  chown -R freeswitch:freeswitch /var/www/fusionpbx && \
  chown -R freeswitch:freeswitch /etc/fusionpbx
# Configure FreeSwitch <-> FusionPBX integration
RUN \
  rm -rf /etc/freeswitch && \
  ln -sf /var/www/fusionpbx/resources/templates/conf /etc/freeswitch && \
  rm -rf /usr/share/freeswitch/scripts && \
  ln -sf /var/www/fusionpbx/app/scripts/resources/scripts /usr/share/freeswitch/scripts && \
  rm -rf /usr/share/freeswitch/sounds/music/8000/* \
  rm -rf /usr/share/freeswitch/sounds/music/16000/* \
  rm -rf /usr/share/freeswitch/sounds/music/32000/* \
  rm -rf /usr/share/freeswitch/sounds/music/48000/*
# Clean
RUN \
  apt-get clean && apt-get autoclean
# Configs
COPY php.ini /etc/php/7.4/conf.d/fusionpbx.ini
COPY fpm-pool.conf /etc/php/7.4/fpm/pool.d/freeswitch.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
# Entrypoint
WORKDIR /var/www/fusionpbx
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && ln -sf /usr/local/bin/entrypoint.sh /entrypoint
ENTRYPOINT [ "/entrypoint" ]
