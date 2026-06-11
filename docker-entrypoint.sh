#!/bin/bash
set -e

cd /var/www/html

if [ ! -f .env ]; then
  cp .env.example .env
fi

set_env_value() {
  varname="$1"
  value="${!varname}"
  if [ -n "$value" ]; then
    if grep -q "^$varname=" .env; then
      awk -F'=' -v var="$varname" -v val="$value" 'BEGIN { OFS = FS } $1 == var { $0 = var "=" val } 1' .env > .env.tmp
      cat .env.tmp > .env
      rm -f .env.tmp
    else
      printf '%s=%s\n' "$varname" "$value" >> .env
    fi
  fi
}

set_env_value APP_NAME
set_env_value APP_ENV
set_env_value APP_URL
set_env_value DB_CONNECTION
set_env_value DB_HOST
set_env_value DB_PORT
set_env_value DB_DATABASE
set_env_value DB_USERNAME
set_env_value DB_PASSWORD
set_env_value SESSION_DRIVER
set_env_value SESSION_LIFETIME
set_env_value SESSION_ENCRYPT
set_env_value SESSION_PATH
set_env_value SESSION_DOMAIN
set_env_value BROADCAST_CONNECTION
set_env_value FILESYSTEM_DISK
set_env_value QUEUE_CONNECTION
set_env_value CACHE_STORE
set_env_value CACHE_PREFIX
set_env_value REDIS_CLIENT
set_env_value REDIS_HOST
set_env_value REDIS_PASSWORD
set_env_value REDIS_PORT
set_env_value MAIL_MAILER
set_env_value MAIL_HOST
set_env_value MAIL_PORT
set_env_value MAIL_USERNAME
set_env_value MAIL_PASSWORD
set_env_value MAIL_ENCRYPTION
set_env_value MAIL_FROM_ADDRESS
set_env_value MAIL_FROM_NAME
set_env_value VITE_APP_NAME

if ! grep -qE '^APP_KEY=base64:[A-Za-z0-9+/=]+$' .env; then
  php artisan key:generate --force
fi

if [ ! -f vendor/autoload.php ]; then
  composer install --ignore-platform-reqs --no-interaction --prefer-dist --no-progress
fi

php artisan storage:link || true

chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

exec "$@"
