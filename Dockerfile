FROM ruby:2.7.0-alpine

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata \
      yarn

# Set local timezone
RUN apk add --update tzdata && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

ENV RAILS_ENV=production
ENV NODE_ENV=production

ENV APP_HOME /opt/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler:2.1.4
ADD Gemfile Gemfile.lock $APP_HOME/
RUN bundle config set without 'development test'
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install --check-files

ADD . $APP_HOME

ARG rails_credentials_key
ENV RAILS_PRODUCTION_KEY=$rails_credentials_key

RUN bundle exec rails assets:precompile

EXPOSE 5000
CMD ["rails","server","-b","0.0.0.0", "-p", "5000"]