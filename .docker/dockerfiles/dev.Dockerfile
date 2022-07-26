# home-server-dev-image
# ================

FROM ruby:3.1.2-alpine3.15

ENV RAILS_ENV=development \
  NODE_ENV=development \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
  APP_HOME=/opt/app \
  PORT=5000

ARG GEM_PATH=/gems
ENV BUNDLE_PATH=$GEM_PATH \
  GEM_PATH=$GEM_PATH \
  GEM_HOME=$GEM_PATH \
  BUNDLE_APP_CONFIG=$GEM_PATH

RUN export PATH="$(ruby -e 'print Gem.user_dir')/bin":$APP_HOME/node_modules/.bin:$PATH

RUN apk add \
  build-base \
  postgresql-dev postgresql-client \
  imagemagick \
  nodejs \
  yarn \
  curl \
  git \
  libffi-dev zlib-dev libxml2-dev libxslt-dev readline-dev \
  rust cargo python3 python3-dev py3-pip \
  chromium-chromedriver chromium libnotify-dev \
  shared-mime-info \
  bash \
  tzdata && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME $GEM_PATH && \
  addgroup --gid 1000 --system docker && \
  adduser --uid 1000 --system -G docker -D docker && \
  chown -R docker:docker $APP_HOME && \
  chown docker:docker $GEM_PATH

RUN echo $GEM_PATH

RUN chown docker $GEM_PATH

RUN ls -al /

RUN USER=docker && \
  GROUP=docker && \
  curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
  chown root:root /usr/local/bin/fixuid && \
  chmod 4755 /usr/local/bin/fixuid && \
  mkdir -p /etc/fixuid && \
  printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

USER docker

RUN pip3 install -U selenium

WORKDIR $APP_HOME

EXPOSE $PORT
ENTRYPOINT ["./.docker/scripts/entrypoint-dev"]
