#!/bin/sh
set -e

if [ "$1" = 'abalone' ]; then
  exec su-exec app bundle exec rails s -b 0.0.0.0
else
  exec "$@"
fi
