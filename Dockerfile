# Compile Assets
# ================
FROM ruby:2.7.2-alpine as builder

RUN apk add --update --no-cache \
  tzdata \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  nodejs \
  yarn

ENV RAILS_ENV=production
ENV NODE_ENV=production

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN mkdir $APP_HOME/vendor && \
  mkdir $APP_HOME/vendor/bundle
ENV BUNDLE_PATH $APP_HOME/vendor/bundle
ENV GEM_PATH $APP_HOME/vendor/bundle
ENV GEM_HOME $APP_HOME/vendor/bundle

COPY Gemfile* $APP_HOME/
RUN gem install bundler:2.1.4 && \
  bundle config set without development:test:assets && \
  bundle config build.nokogiri --use-system-libraries && \
  bundle config set path 'vendor/bundle' && \
  bundle install

COPY package.json yarn.lock $APP_HOME/
RUN yarn install --check-files

ADD . $APP_HOME

ARG rails_credentials_key
ENV RAILS_MASTER_KEY=$rails_credentials_key

RUN bundle exec rails assets:precompile && \
  rm -rf $APP_HOME/node_modules && \
  rm -rf $APP_HOME/app/assets/images && \
  rm -rf $APP_HOME/app/frontend/packs && \
  rm -rf $APP_HOME/log/* && \
  rm -rf $APP_HOME/spec && \
  rm -rf $APP_HOME/storage/* && \
  rm -rf $APP_HOME/tmp/* && \
  rm -rf $APP_HOME/vendor/bundle/ruby/2.7.0/cache/*.gem && \
  find $APP_HOME/vendor/bundle/ruby/2.7.0/gems/ -name "*.c" -delete && \
  find $APP_HOME/vendor/bundle/ruby/2.7.0/gems/ -name "*.o" -delete


# Create App
# ================
FROM ruby:2.7.2-alpine

RUN apk add --update --no-cache \
  tzdata \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

ENV RAILS_ENV=production
ENV NODE_ENV=production

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY --from=builder /app $APP_HOME

ENV BUNDLE_PATH $APP_HOME/vendor/bundle
ENV GEM_PATH $APP_HOME/vendor/bundle
ENV GEM_HOME $APP_HOME/vendor/bundle
COPY --from=builder /app/vendor/bundle $APP_HOME/vendor/bundle
RUN bundle config set path 'vendor/bundle' && \
  bundle config without development:test:assets

EXPOSE 5000
CMD ["bundle", "exec", "rails","server","-b","0.0.0.0", "-p", "5000"]