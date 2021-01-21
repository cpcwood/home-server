#!/bin/sh
bundle exec rake db:exists && bundle exec rake db:migrate || bundle exec rake db:setup
if [ $RAILS_ENV == 'production' ]; then
    bundle exec rails sitemap:refresh:no_ping
    bundle exec rails whenever --update-crontab
fi
bundle exec rails server -b 0.0.0.0 -p 5000