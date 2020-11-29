FROM ruby:2.7.2-alpine

ENV RAILS_ENV=production
ENV NODE_ENV=production

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apk add --no-cache \
  tzdata \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  chromium \
  nss \
  freetype \
  freetype-dev \
  harfbuzz \
  ca-certificates \
  ttf-freefont \
  nodejs \
  yarn \
  git && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN yarn add carbon-now-cli

ADD . $APP_HOME

RUN mkdir -p $APP_HOME/vendor/bundle
ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
  GEM_PATH=$APP_HOME/vendor/bundle \
  GEM_HOME=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle:/app/node_modules/.bin:$PATH

COPY Gemfile* $APP_HOME/
RUN gem install bundler:2.1.4 addressable && \
  bundle config set without development:test:assets && \
  bundle config build.nokogiri --use-system-libraries && \
  bundle config set path 'vendor/bundle' && \
  bundle install

RUN rm -rf $APP_HOME/app/assets/images && \
  rm -rf $APP_HOME/app/frontend/packs && \
  rm -rf $APP_HOME/log/* && \
  rm -rf $APP_HOME/public && \
  rm -rf $APP_HOME/spec && \
  rm -rf $APP_HOME/storage/* && \
  rm -rf $APP_HOME/tmp/* && \
  rm -rf $APP_HOME/vendor/bundle/ruby/2.7.0/cache/*.gem && \
  find $APP_HOME/vendor/bundle/ruby/2.7.0/gems/ -name "*.c" -delete && \
  find $APP_HOME/vendor/bundle/ruby/2.7.0/gems/ -name "*.o" -delete

RUN addgroup -S pptruser && \
  adduser -S -G pptruser pptruser && \
  chown -R pptruser:pptruser /app

USER pptruser

CMD ["bundle", "exec", "sidekiq", "-C", "config/sidekiq.yml"]