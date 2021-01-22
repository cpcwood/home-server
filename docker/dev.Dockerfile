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

ENV BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle \
  BUNDLE_PATH=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

RUN apk add --no-cache \
  tzdata \
  build-base \
  postgresql-dev postgresql-client \
  imagemagick \
  nodejs \
  yarn \
  curl \
  git \
  libffi-dev zlib-dev libxml2-dev libxslt-dev readline-dev \
  python3 python3-dev py3-pip \
  chromium-chromedriver chromium \
  libnotify-dev && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

RUN pip3 install -U selenium

RUN gem install rake

WORKDIR $APP_HOME

EXPOSE $PORT

ENTRYPOINT ["./scripts/docker-dev-entrypoint.sh"]