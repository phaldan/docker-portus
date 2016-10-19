FROM library/ruby:2.3-alpine

MAINTAINER Philipp Daniels <philipp.daniels@gmail.com>

ENV PORTUS_VERSION=2.1.1 \
    PORTUS_PATH=/portus \
    PORTUS_CONFIG_PATH=/portus/config \
    RACK_ENV=production \
    RAILS_ENV=production \
    BUNDLE_GEMFILE=/portus/Gemfile

WORKDIR ${PORTUS_PATH}

# RUNTIME DEPENDENCIES
RUN set -ex && \
  apk add --no-cache \
    nodejs-lts \
    libxslt \
    mariadb-client-libs \
    libcurl \
    tzdata

COPY *.sh ${PORTUS_PATH}/bin/

RUN set -ex && \
  apk add --update --no-cache --virtual build-deps \
    wget \
    libxslt-dev \
    tar \
    make \
    gcc \
    libc-dev \
    mariadb-dev && \
  bin/install.sh && \
  apk del --purge build-deps && \
  rm -rf /var/cache/apk/*

COPY *.yml puma.rb ${PORTUS_CONFIG_PATH}/

CMD exec bin/run.sh
