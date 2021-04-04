# home-server-worker
# ================
# requires cpcwood/home-server-base to have been created

# Create Worker App
# ================
FROM ruby:2.7.2-alpine3.13

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

RUN addgroup -S docker && \
  adduser -S -G docker docker

USER docker

COPY --chown=docker:docker --from=cpcwood/home-server-base $APP_HOME $APP_HOME
COPY --chown=docker:docker --from=cpcwood/home-server-worker-dependencies $APP_HOME/node_modules $APP_HOME/node_modules

CMD ["./.docker/scripts/startup-worker.sh"]