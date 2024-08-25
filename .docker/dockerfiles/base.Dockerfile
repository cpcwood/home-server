# home-server-base-image
# ================
# build args =>
#     grecaptcha_site_key

# Compile Assets
# ================

FROM ruby:3.2.3-alpine3.18

ENV RAILS_ENV=production \
    NODE_ENV=production \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    APP_HOME=/opt/app

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
    GEM_PATH=$APP_HOME/vendor/bundle \
    GEM_HOME=$APP_HOME/vendor/bundle \
    BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle \
    NODE_OPTIONS="--openssl-legacy-provider"

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    yarn \
    git \
    curl \
    gzip \
    tar \
    shared-mime-info \
    xz \
    openssl1.1-compat

RUN mkdir -p $APP_HOME $APP_HOME/vendor/bundle $APP_HOME/tmp
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle config set without development:test:assets && \
    bundle config set bin $GEM_PATH/bin && \
    bundle config set deployment true && \
    bundle install

COPY package.json yarn.lock $APP_HOME/
RUN yarn install --production=true && \
    rm -rf /usr/local/share/.cache/yarn

ARG MAX_MIND_LICENSE
RUN curl -L "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAX_MIND_LICENSE&suffix=tar.gz" -o ./GeoLite2-City.tar.gz && \
    gzip -d GeoLite2-City.tar.gz && \
    tar -xvf GeoLite2-City.tar && \
    mkdir -p /var/opt/maxmind/ && \
    mv GeoLite2-City_*/GeoLite2-City.mmdb /var/opt/maxmind/GeoLite2-City.mmdb

RUN addgroup -S docker && \
    adduser -S -G docker docker

COPY --chown=docker:docker . $APP_HOME

ARG grecaptcha_site_key
ENV GRECAPTCHA_SITE_KEY=$grecaptcha_site_key \
    SECRET_KEY_BASE=1234567890

RUN bundle exec rails assets:precompile && \
    rm -rf $APP_HOME/node_modules && \
    rm -rf $APP_HOME/app/frontend/packs && \
    rm -rf $APP_HOME/log/* && \
    rm -rf $APP_HOME/spec && \
    rm -rf $APP_HOME/storage/* && \
    rm -rf $APP_HOME/tmp/* && \
    rm -rf $APP_HOME/vendor/bundle/ruby/3.2.0/cache/ && \
    find $APP_HOME/vendor/bundle/ruby/3.2.0/gems/ -name "*.c" -delete && \
    find $APP_HOME/vendor/bundle/ruby/3.2.0/gems/ -name "*.o" -delete

USER docker
