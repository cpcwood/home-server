#!/bin/sh
bundle install --quiet
kill -INT $(cat ./tmp/pids/server.pid) > /dev/null 2>&1
rm -f ./tmp/pids/server.pid > /dev/null 2>&1


if bundle exec rails db:exists ; then
  bundle exec rails db:migrate
else
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
fi

bundle exec rails server -b 0.0.0.0 -p 5000