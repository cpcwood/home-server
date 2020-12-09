# home-server-sidekiq
# ================
# requires cpcwood/home-server-base to have been created

# Create Server NodeJS Assets
# ================
FROM alpine:latest as server-nodejs-assets

ENV RAILS_ENV=production \
  NODE_ENV=production \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  USER=home-server-user \
  APP_HOME=/opt/app

RUN apk add --no-cache \
  nodejs \
  yarn \
  git

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup --system $USER && \
  adduser --system --disabled-password --gecos '' --ingroup $USER $USER && \
  chown -R $USER $APP_HOME

USER $USER

RUN yarn add carbon-now-cli


# Create App
# ================
FROM ruby:2.7.2-alpine

ENV RAILS_ENV=production \
  NODE_ENV=production \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
  USER=home-server-user \
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

COPY --from=cpcwood/home-server-base:latest $APP_HOME $APP_HOME
COPY --from=server-nodejs-assets $APP_HOME/node_modules $APP_HOME/node_modules

RUN addgroup -S $USER && \
  adduser -S -G $USER $USER

USER $USER

CMD ["bundle", "exec", "sidekiq", "-C", "config/sidekiq.yml"]