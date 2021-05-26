# home-server-app
# ================
# requires cpcwood/home-server-base to have been created

# Create App
# ================
FROM ruby:2.7.3-alpine3.13

ENV RAILS_ENV=production \
  NODE_ENV=production \
  APP_HOME=/opt/app

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
  GEM_PATH=$APP_HOME/vendor/bundle \
  GEM_HOME=$APP_HOME/vendor/bundle \
  BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

RUN apk add --no-cache \
  tzdata \
  imagemagick \
  postgresql-client \
  shared-mime-info && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup -S docker && \
  adduser -S -G docker docker

USER docker

COPY --chown=docker:docker --from=cpcwood/home-server-base $APP_HOME $APP_HOME

EXPOSE 5000
CMD ["./.docker/scripts/startup-app.sh"]