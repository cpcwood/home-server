# home-server-worker-dependencies
# ================

# Create Server NodeJS Assets
# ================
FROM alpine:3.18 AS server-nodejs-assets

ENV RAILS_ENV=production \
    NODE_ENV=production \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    APP_HOME=/opt/app \
    NODE_OPTIONS="--openssl-legacy-provider"

RUN apk add --no-cache \
    nodejs \
    yarn \
    git \
    openssl1.1-compat

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY package.json yarn.lock ./

RUN addgroup -S docker && \
    adduser -S -G docker docker && \
    chown -R docker:docker $APP_HOME

USER docker

RUN PACKAGE_NAME='carbon-now-cli' && \
    LINE_NUMBER="$(cat yarn.lock | grep -n "$PACKAGE_NAME@.*:" | cut -f1 -d:)" && \
    VERSION="$(cat yarn.lock | sed -n $((LINE_NUMBER + 1))p | sed 's/.*version \"\(.*\)\"/\1/')" && \
    yarn add ${PACKAGE_NAME}@${VERSION} && \
    ls | grep -v node_modules | xargs rm -rf
