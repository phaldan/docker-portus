#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

main() {
  file="config/config.yml"

  replaceByEnv $file "PORTUS_EMAIL_FROM" "portus@example.com"
  replaceByEnv $file "PORTUS_EMAIL_NAME" "Portus"
  replaceByEnv $file "PORTUS_EMAIL_REPLY_TO" "no-reply@example.com"
  replaceByEnv $file "PORTUS_EMAIL_SMTP_ENABLED" "false"
  replaceByEnv $file "PORTUS_EMAIL_SMTP_ADDRESS" "smtp.example.com"
  replaceByEnv $file "PORTUS_EMAIL_SMTP_PORT" "587"
  replaceByEnv $file "PORTUS_EMAIL_SMTP_USER_NAME" "username@example.com"
  replaceByEnv $file "PORTUS_EMAIL_SMTP_PASSWORD" "password"
  replaceByEnv $file "PORTUS_EMAIL_SMTP_DOMAIN" "example.com"
  replaceByEnv $file "PORTUS_GRAVATAR_ENABLED" "true"
  replaceByEnv $file "PORTUS_DELETE_ENABLED" "false"
  replaceByEnv $file "PORTUS_LDAP_ENABLED" "false"
  replaceByEnv $file "PORTUS_LDAP_HOSTNAME" "ldap_hostname"
  replaceByEnv $file "PORTUS_LDAP_PORT" "389"
  replaceByEnv $file "PORTUS_LDAP_METHOD" "plain"
  replaceByEnv $file "PORTUS_LDAP_BASE" ""
  replaceByEnv $file "PORTUS_LDAP_FILTER" ""
  replaceByEnv $file "PORTUS_LDAP_UID" "uid"
  replaceByEnv $file "PORTUS_LDAP_AUTHENTICATION_ENABLED" "false"
  replaceByEnv $file "PORTUS_LDAP_AUTHENTICATION_BIND_DN" ""
  replaceByEnv $file "PORTUS_LDAP_AUTHENTICATION_PASSWORD" ""
  replaceByEnv $file "PORTUS_LDAP_GUESS_EMAIL_ENABLED" "false"
  replaceByEnv $file "PORTUS_LDAP_GUESS_EMAIL_ATTR" ""
  replaceByEnv $file "PORTUS_FIRST_USER_ADMIN_ENABLED" "true"
  replaceByEnv $file "PORTUS_SIGNUP_ENABLED" "true"
  replaceByEnv $file "PORTUS_CHECK_SSL_USAGE_ENABLED" "true"
  replaceByEnv $file "PORTUS_REGISTRY_JWT_EXPIRATION_TIME" "5"
  replaceByEnv $file "PORTUS_REGISTRY_CATALOG_PAGE" "100"
  replaceByEnv $file "PORTUS_MACHINE_FQDN" "portus.test.lan"
  replaceByEnv $file "PORTUS_DISPLAY_NAME_ENABLED" "false"
  replaceByEnv $file "PORTUS_USER_PERMISSION_CHANGE_VISIBILITY_ENABLED" "true"
  replaceByEnv $file "PORTUS_USER_PERMISSION_MANAGE_TEAM_ENABLED" "true"
  replaceByEnv $file "PORTUS_USER_PERMISSION_MANAGE_NAMESPACE_ENABLED" "true"
}

replaceByEnv() {
  file=${1}
  env_var=${2}
  default=${3}

  replace $file "${env_var}" "${!env_var:-$default}"
}

replace() {
  file=${1}
  search=${2}
  replace=${3}

  sed -i "s#${search}#${replace}#" ${file}
}

main
