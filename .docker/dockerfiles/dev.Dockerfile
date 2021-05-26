# home-server-dev-image
# ================

# Compile Assets
# ================

FROM ruby:2.7.3-alpine3.13

ENV RAILS_ENV=development \
  NODE_ENV=development \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
  APP_HOME=/opt/app \
  PORT=5000

ENV BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle \
  BUNDLE_PATH=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

RUN apk add \
  build-base \
  postgresql-dev postgresql-client \
  imagemagick \
  nodejs \
  yarn \
  curl \
  git \
  libffi-dev zlib-dev libxml2-dev libxslt-dev readline-dev \
  python3 python3-dev py3-pip \
  chromium-chromedriver chromium libnotify-dev \
  shared-mime-info \
  tzdata && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

RUN pip3 install -U selenium && \
  gem install rake

RUN mkdir -p $APP_HOME && \
  addgroup --gid 1000 --system docker && \
  adduser --uid 1000 --system -G docker docker && \
  chown -R docker:docker $APP_HOME

USER docker

WORKDIR $APP_HOME

EXPOSE $PORT

ENTRYPOINT ["./.docker/scripts/entrypoint-dev.sh"]