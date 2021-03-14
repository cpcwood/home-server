#!/bin/sh

until curl --output /dev/null --silent --head http://app:5000 ; do
    echo 'waiting for app...'
    sleep 1
done

bundle exec sidekiq -C config/sidekiq.yml