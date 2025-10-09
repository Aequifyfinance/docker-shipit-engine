#!/bin/sh
set -e

# Validate required env vars
: "${DATABASE_URL:?DATABASE_URL not set}"
: "${REDIS_URL:?REDIS_URL not set}"
: "${SECRET_KEY_BASE:?SECRET_KEY_BASE not set}"

# Generate secrets.yml from environment variables at runtime
cat > config/secrets.yml <<EOF
${RAILS_ENV:-production}:
  secret_key_base: ${SECRET_KEY_BASE}
  redis_url: ${REDIS_URL}
  host: ${SHIPIT_HOST:-shipit.aequify.com}
  github:
    app_id: ${GITHUB_APP_ID:-2083748}
    installation_id: ${GITHUB_INSTALLATION_ID:-89235109}
    domain: ${GITHUB_DOMAIN:-}
    bot_login: ${GITHUB_BOT_LOGIN:-Aequify-IT-App[bot]}
    webhook_secret: ${WEBHOOK_SECRET}
    private_key: ${PRIVATE_KEY}
    oauth:
      id: ${OAUTH_ID:-Iv23lilB2oNp3rrTU3Al}
      secret: ${OAUTH_SECRET}
      teams:
        - ${GITHUB_TEAM:-Aequifyfinance/Engineering}
EOF

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
