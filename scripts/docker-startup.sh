#!/bin/sh
bundle exec rake db:exists && bundle exec rake db:migrate || bundle exec rake db:setup
bundle exec rails server -b 0.0.0.0 -p 5000