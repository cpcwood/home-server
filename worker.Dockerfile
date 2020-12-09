# home-server-sidekiq
# ================
# requires cpcwood/home-server-base to have been created

# Create Server NodeJS Assets
# ================
FROM alpine:edge as server-nodejs-assets

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
FROM alpine:edge

ENV RAILS_ENV=production \
  NODE_ENV=production \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
  USER=home-server-user \
  APP_HOME=/opt/app

RUN apk add --no-cache \
  tzdata \
  libxml2 \
  libxslt \
  postgresql-client \
  nodejs \
  imagemagick \
  ruby-full \
  chromium && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup --system $USER && \
  adduser --system --disabled-password --gecos '' --ingroup $USER $USER && \
  chown -R $USER $APP_HOME

USER $USER

COPY --from=cpcwood/home-server-base $APP_HOME $APP_HOME
COPY --from=server-nodejs-assets $APP_HOME/node_modules $APP_HOME/node_modules

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
  GEM_PATH=$APP_HOME/vendor/bundle \
  GEM_HOME=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

CMD ["bundle", "exec", "sidekiq", "-C", "config/sidekiq.yml"]