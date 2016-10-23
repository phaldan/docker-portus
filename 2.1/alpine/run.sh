#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

main() {
  debug "Create database"
  rake db:create

  debug "Migrate database schema"
  rake db:migrate

  bundle exec puma &
  puma_pid="$!"
  debug "Starting webserver - ${puma_pid}"

  if [ -n "${PORTUS_CATALOG_CRON:-}" ]; then
    export "CATALOG_CRON=${PORTUS_CATALOG_CRON:-}"
  fi
  bundle exec crono &
  crono_pid="$!"
  debug "Starting synchronisation - ${crono_pid}"

  wait ${puma_pid}
  kill ${crono_pid}
}

debug() {
  message="${1:-}"
  if [ "${DEBUG:-0}" -eq "1" ]; then
    echo "[$(date +'%F %X %z')]: $message"
  fi
}

shutdown() {
  debug "Shutdown portus - ${puma_pid} ${crono_pid}"
  kill ${puma_pid} ${crono_pid}
  sleep 1
  exit 0
}


puma_pid=""
crono_pid=""
trap shutdown SIGINT SIGTERM
main
