FROM library/ruby:2.3

MAINTAINER Philipp Daniels <philipp.daniels@gmail.com>

ENV PORTUS_VERSION=2.1.1 \
    PORTUS_PATH=/portus \
    PORTUS_CONFIG_PATH=/portus/config \
    RACK_ENV=production \
    RAILS_ENV=production

WORKDIR ${PORTUS_PATH}

# DEPENDENCIES
RUN set -ex && \
  apt-get update && \
  apt-get install -y --no-install-recommends nodejs && \
  rm -rf /var/lib/apt/lists/*

# INSTALL
RUN set -ex && \
  wget -qO- "https://github.com/SUSE/Portus/archive/${PORTUS_VERSION}.tar.gz" | tar -xvz --strip-components=1 && \
  bundle install --retry=3

# CONFIG
COPY config/ ${PORTUS_CONFIG_PATH}
RUN mkdir ${PORTUS_CONFIG_PATH}/certs && \
  cp vagrant/conf/ca_bundle/server.key vagrant/conf/ca_bundle/server.crt ${PORTUS_CONFIG_PATH}/certs

COPY ./*.sh ${PORTUS_PATH}
CMD ./prepare.sh && puma
