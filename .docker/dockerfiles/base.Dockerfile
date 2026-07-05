# home-server-base-image
# ================
# build args =>
#     grecaptcha_site_key

# Compile Assets
# ================

FROM ruby:3.4.9-alpine3.22

ENV RAILS_ENV=production \
    NODE_ENV=production \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    APP_HOME=/opt/app

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
    GEM_PATH=$APP_HOME/vendor/bundle \
    GEM_HOME=$APP_HOME/vendor/bundle \
    BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle

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
    xz

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

# Absent secret (no license mounted) → skip the download and leave an empty
# placeholder so the app/worker `COPY --from` of this path still resolves. Only
# PR build-validate does this; published main builds mount the real license and
# bake the DB.
RUN --mount=type=secret,id=max_mind_license \
    mkdir -p /var/opt/maxmind/ && \
    if [ -s /run/secrets/max_mind_license ]; then \
      MAX_MIND_LICENSE="$(cat /run/secrets/max_mind_license)" && \
      curl -L "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAX_MIND_LICENSE&suffix=tar.gz" -o ./GeoLite2-City.tar.gz && \
      gzip -d GeoLite2-City.tar.gz && \
      tar -xvf GeoLite2-City.tar && \
      mv GeoLite2-City_*/GeoLite2-City.mmdb /var/opt/maxmind/GeoLite2-City.mmdb; \
    else \
      touch /var/opt/maxmind/GeoLite2-City.mmdb; \
    fi

RUN addgroup -g 1000 -S docker && \
    adduser -u 1000 -S -G docker docker

COPY --chown=docker:docker . $APP_HOME

# SITE_HOST: placeholder so the production env boots for assets:precompile —
# sitemap_generator 7's railtie calls full_url_for on default_url_options at init.
# The real host comes from SITE_HOST at runtime.
ARG GRECAPTCHA_SITE_KEY=""
RUN export GRECAPTCHA_SITE_KEY="$GRECAPTCHA_SITE_KEY" && \
    export SECRET_KEY_BASE=1234567890 && \
    export SITE_HOST=localhost && \
    bundle exec rails assets:precompile && \
    rm -rf $APP_HOME/node_modules && \
    rm -rf $APP_HOME/app/frontend/packs && \
    rm -rf $APP_HOME/log/* && \
    rm -rf $APP_HOME/spec && \
    rm -rf $APP_HOME/storage/* && \
    rm -rf $APP_HOME/tmp/* && \
    rm -rf $APP_HOME/vendor/bundle/ruby/3.4.0/cache/ && \
    find $APP_HOME/vendor/bundle/ruby/3.4.0/gems/ -name "*.c" -delete && \
    find $APP_HOME/vendor/bundle/ruby/3.4.0/gems/ -name "*.o" -delete

USER docker
