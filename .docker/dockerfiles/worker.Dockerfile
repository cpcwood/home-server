# home-server-worker
# ================
# requires cpcwood/home-server-base to have been created

# Create Worker App
# ================
# Held at alpine3.23: carbon-now-cli 1.x's puppeteer can't drive alpine3.24's chromium 155 (Page.navigate: Target closed)
FROM ruby:4.0.8-alpine3.23

ENV RAILS_ENV=production \
    NODE_ENV=production \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    APP_HOME=/opt/app

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
    GEM_PATH=$APP_HOME/vendor/bundle \
    GEM_HOME=$APP_HOME/vendor/bundle \
    BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle \
    PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

RUN apk add --no-cache \
    bash \
    tini \
    tzdata \
    postgresql-client \
    nodejs \
    imagemagick \
    chromium \
    shared-mime-info && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup -g 1000 -S docker && \
    adduser -u 1000 -S -G docker docker
  
USER docker

COPY --chown=docker:docker --from=cpcwood/home-server-base $APP_HOME $APP_HOME
COPY --chown=docker:docker --from=cpcwood/home-server-base /var/opt/maxmind/GeoLite2-City.mmdb /var/opt/maxmind/GeoLite2-City.mmdb
COPY --chown=docker:docker --from=cpcwood/home-server-worker-dependencies $APP_HOME/node_modules $APP_HOME/node_modules

# Sidekiq jobs shell out to chromium/imagemagick; tini reaps the subprocesses they orphan
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["./.docker/scripts/startup-worker"]
