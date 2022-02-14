# home-server-worker-dependencies
# ================

# Create Server NodeJS Assets
# ================
FROM alpine:3.14 as server-nodejs-assets

ENV RAILS_ENV=production \
  NODE_ENV=production \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  APP_HOME=/opt/app

RUN apk add --no-cache \
  nodejs \
  yarn \
  git

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup -S docker && \
  adduser -S -G docker docker && \
  chown -R docker:docker $APP_HOME

USER docker

RUN yarn add carbon-now-cli && \
  ls | grep -v node_modules$| xargs rm -rf
