# home-server-app
# ================
# requires cpcwood/home-server-base to have been created

# Create App
# ================
FROM ruby:3.2.3-alpine3.18

ENV RAILS_ENV=production \
    NODE_ENV=production \
    APP_HOME=/opt/app

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
    GEM_PATH=$APP_HOME/vendor/bundle \
    GEM_HOME=$APP_HOME/vendor/bundle \
    BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle \
    PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0

RUN apk add --no-cache \
    bash \
    tzdata \
    imagemagick \
    postgresql-client \
    openssl1.1-compat \
    shared-mime-info && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup -S docker && \
    adduser -S -G docker docker

USER docker

COPY --chown=docker:docker --from=cpcwood/home-server-base $APP_HOME $APP_HOME
COPY --chown=docker:docker --from=cpcwood/home-server-base /var/opt/maxmind/GeoLite2-City.mmdb /var/opt/maxmind/GeoLite2-City.mmdb

EXPOSE 5000
CMD ["./.docker/scripts/startup-app"]
