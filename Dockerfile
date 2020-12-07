# home-server-app-v5
# ================
# build args =>
#     grecaptcha_site_key


# Compile Assets
# ================
FROM alpine:edge as server-rails-assets

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

ENV RAILS_ENV=production \
  NODE_ENV=production \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  APP_HOME=/opt/app

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
RUN yarn install --check-files --production=true

ADD . $APP_HOME

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

RUN addgroup -S home-server && \
  adduser -S -G home-server home-server && \
  chown -R home-server:home-server $APP_HOME


# Create App
# ================
FROM alpine:edge

RUN apk add --no-cache \
  tzdata \
  imagemagick \
  libxml2 \
  libxslt \
  postgresql-client \
  ruby-full && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

ENV RAILS_ENV=production \
  NODE_ENV=production \
  APP_HOME=/opt/app

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY --from=server-rails-assets $APP_HOME $APP_HOME

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
  GEM_PATH=$APP_HOME/vendor/bundle \
  GEM_HOME=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

EXPOSE 5000
CMD ["./scripts/docker-startup.sh"]