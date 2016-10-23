#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

main() {
  install
  cleanup
  addDefaultCerts "vagrant/conf/ca_bundle"
}

install() {
  echo "=> Download portus and install gems"
  wget -qO- "https://github.com/SUSE/Portus/archive/${PORTUS_VERSION}.tar.gz" | tar -xvz --strip-components=1

  # Fix missing gems without dev
  sed -i '/gem "md2man"/d' ${BUNDLE_GEMFILE}
  sed -i '/gem "puma"/d' ${BUNDLE_GEMFILE}
  echo 'gem "md2man", "~>5.1.1", require: false' >> ${BUNDLE_GEMFILE}
  echo 'gem "puma"' >> ${BUNDLE_GEMFILE}

  bundle config --local build.nokogiri --use-system-libraries # Fix broken nokogiri build
  bundle install --jobs=4 --retry=3 --no-cache --clean --deployment --without test development
}

cleanup() {
  echo "=> Remove build dependencies and cleanup tmp/cache"
  gem cleanup
  rm -rf /tmp/* /tmp/.??* /root/* /root/.??* /usr/lib/ruby/gems/*/cache/*
}

addDefaultCerts() {
  echo "=> Provide default SSL certs"

  src_folder="${1}"
  mkdir ${PORTUS_CONFIG_PATH}/certs
  cp ${src_folder}/server.key ${src_folder}/server.crt ${PORTUS_CONFIG_PATH}/certs
}

main
