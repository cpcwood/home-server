# home-server-sidekiq
# ================
# requires cpcwood/home-server-base to have been created

# Create Server NodeJS Assets
# ================
FROM alpine:latest as server-nodejs-assets

ENV RAILS_ENV=production \
  NODE_ENV=production \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  APP_HOME=/opt/app

RUN apk add --no-cache \
  nodejs \
  yarn \
  git

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup -S docker && \
  adduser -S -G docker docker && \
  chown -R docker:docker $APP_HOME

USER docker

RUN yarn add carbon-now-cli


# Create App
# ================
FROM ruby:2.7.2-alpine

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
  chromium && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup -S docker && \
  adduser -S -G docker docker

USER docker

COPY --chown=docker:docker --from=cpcwood/home-server-base $APP_HOME $APP_HOME
COPY --chown=docker:docker --from=server-nodejs-assets $APP_HOME/node_modules $APP_HOME/node_modules

CMD ["bundle", "exec", "sidekiq", "-C", "config/sidekiq.yml"]