# home-server-base-image
# ================
# build args =>
#     grecaptcha_site_key

# Compile Assets
# ================

FROM ruby:2.7.2-alpine

ENV RAILS_ENV=development \
  NODE_ENV=development \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  APP_HOME=/opt/app \
  PORT=5000

ENV BUNDLE_APP_CONFIG=$APP_HOME/.bundle/config \
  BUNDLE_PATH=$APP_HOME/vendor/bundle \
  GEM_PATH=$APP_HOME/vendor/bundle \
  GEM_HOME=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  imagemagick \
  chromium \
  nodejs \
  yarn \
  git

WORKDIR $APP_HOME

EXPOSE $PORT

ENTRYPOINT [ "/bin/sh", "-c" ]