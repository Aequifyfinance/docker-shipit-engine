#!/bin/sh
set -e

# Validate required env vars
: "${DATABASE_URL:?DATABASE_URL not set}"
: "${REDIS_URL:?REDIS_URL not set}"
: "${SECRET_KEY_BASE:?SECRET_KEY_BASE not set}"

command=$1

case $command in
  setup)
    bundle exec rake railties:install:migrations db:create db:migrate
    exit 0
    ;;
  upgrade)
    bundle exec rake railties:install:migrations db:migrate
    exit 0
    ;;
  *)
    # Default: start Puma (HTTP)
    exec bundle exec puma -C config/puma.rb
    ;;
esac
