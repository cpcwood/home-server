# home-server-base-image
# ================
# build args =>
#     grecaptcha_site_key

# Compile Assets
# ================

FROM alpine:edge

ENV RAILS_ENV=production \
  NODE_ENV=production \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  USER=home-server-user \
  APP_HOME=/opt/app

RUN apk add --no-cache \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  nodejs \
  yarn \
  ruby-dev \
  ruby-full \
  git

RUN mkdir -p $APP_HOME $APP_HOME/vendor/bundle
WORKDIR $APP_HOME

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
  GEM_PATH=$APP_HOME/vendor/bundle \
  GEM_HOME=$APP_HOME/vendor/bundle

COPY Gemfile* $APP_HOME/
RUN gem install bundler:2.1.4 && \
  bundle config set without development:test:assets && \
  bundle config build.nokogiri --use-system-libraries && \
  bundle install

COPY package.json yarn.lock $APP_HOME/
RUN yarn install --production=true

ADD . $APP_HOME

RUN addgroup --system $USER && \
  adduser --system --disabled-password --gecos '' --ingroup $USER $USER && \
  chown -R $USER $APP_HOME

USER $USER

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
  rm -rf $APP_HOME/vendor/bundle/ruby/2.7.0/cache/*.gem && \
  find $APP_HOME/vendor/bundle/ruby/2.7.0/gems/ -name "*.c" -delete && \
  find $APP_HOME/vendor/bundle/ruby/2.7.0/gems/ -name "*.o" -delete
