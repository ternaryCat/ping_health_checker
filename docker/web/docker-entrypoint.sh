#!/bin/bash
set -e

bundle install

rake db:create
rake db:migrate

exec "$@"
