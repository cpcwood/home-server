#!/bin/sh
bundle install --quiet
kill -INT $(cat ./tmp/pids/server.pid) > /dev/null 2>&1
rm -f ./tmp/pids/server.pid > /dev/null 2>&1
bundle exec rake db:exists && bundle exec rake db:migrate || bundle exec rake db:setup
bundle exec rails server -b 0.0.0.0 -p 5000