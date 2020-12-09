# home-server-app
# ================
# build args =>
#     grecaptcha_site_key

# Create App
# ================
FROM ruby:2.7.2-alpine

ENV RAILS_ENV=production \
  NODE_ENV=production \
  USER=home-server-user \
  APP_HOME=/opt/app

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
  GEM_PATH=$APP_HOME/vendor/bundle \
  GEM_HOME=$APP_HOME/vendor/bundle \
  BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

RUN apk add --no-cache \
  tzdata \
  imagemagick \
  postgresql-client && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY --from=cpcwood/home-server-base:latest $APP_HOME $APP_HOME

RUN addgroup -S $USER && \
  adduser -S -G $USER $USER

USER $USER

EXPOSE 5000
CMD ["./scripts/docker-startup.sh"]