# home-server-app
# ================
# build args =>
#     grecaptcha_site_key

# Create App
# ================
FROM alpine:edge

ENV RAILS_ENV=production \
  NODE_ENV=production \
  USER=home-server-user \
  APP_HOME=/opt/app

RUN apk add --no-cache \
  tzdata \
  imagemagick \
  libxml2 \
  libxslt \
  postgresql-client \
  ruby-full && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup --system $USER && \
  adduser --system --disabled-password --gecos '' --ingroup $USER $USER && \
  chown -R $USER $APP_HOME

USER $USER

COPY --from=cpcwood/home-server-base $APP_HOME $APP_HOME

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
  GEM_PATH=$APP_HOME/vendor/bundle \
  GEM_HOME=$APP_HOME/vendor/bundle \
  PATH=$APP_HOME/vendor/bundle/bin:$APP_HOME/vendor/bundle:$APP_HOME/node_modules/.bin:$PATH

EXPOSE 5000
CMD ["./scripts/docker-startup.sh"]