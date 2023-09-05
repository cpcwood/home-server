# home-server-dev-image
# ================

FROM ruby:3.2.2-alpine3.18

ENV RAILS_ENV=development \
    NODE_ENV=development \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    APP_HOME=/opt/app \
    PORT=5000 \
    NODE_OPTIONS="--openssl-legacy-provider"

RUN apk add \
    build-base \
    postgresql-dev postgresql-client \
    imagemagick \
    nodejs \
    yarn \
    curl \
    git \
    gzip \
    tar \
    libffi-dev zlib-dev libxml2-dev libxslt-dev readline-dev xz \
    rust cargo python3 python3-dev py3-pip \
    chromium-chromedriver chromium libnotify-dev \
    shared-mime-info \
    bash \
    openssl1.1-compat \
    tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

# Ensure gems are owned by docker user
ARG BUNDLE_PATH=/gems
ENV BUNDLE_PATH=$BUNDLE_PATH \
    BUNDLE_APP_CONFIG=$BUNDLE_PATH \
    BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH="$BUNDLE_BIN/bin:$PATH"

ENV PATH=$BUNDLE_PATH/bin:$APP_HOME/node_modules/.bin:$PATH

ARG MAX_MIND_LICENSE
RUN curl "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAX_MIND_LICENSE&suffix=tar.gz" -o ./GeoLite2-City.tar.gz && \
    gzip -d GeoLite2-City.tar.gz && \
    tar -xvf GeoLite2-City.tar && \
    mkdir -p /var/opt/maxmind/ && \
    mv GeoLite2-City_*/GeoLite2-City.mmdb /var/opt/maxmind/GeoLite2-City.mmdb

# Create docker user with variable ID for dev
RUN mkdir -p $APP_HOME /gems && \
    addgroup --gid 1000 --system docker && \
    adduser --uid 1000 --system -G docker -D docker && \
    chown -R docker:docker $APP_HOME /gems

RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\npaths:\n- /\n- /gems" > /etc/fixuid/config.yml

USER docker:docker

ENV PATH="$PATH:$HOME/bin"

RUN pip3 install -U selenium

WORKDIR $APP_HOME

EXPOSE $PORT
ENTRYPOINT ["./.docker/scripts/entrypoint-dev"]
