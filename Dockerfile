ARG RUBY_VERSION

FROM ruby:$RUBY_VERSION

ARG NODE_MAJOR

ENV LANG=C.UTF-8\
  GEM_HOME=/bundle\
  BUNDLE_JOBS=4\
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH\
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

RUN apt-get update -qq &&\
    apt-get -yq --no-install-recommends install curl &&\
    # Node.js
    curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - &&\
    # nokogiri
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential libpq-dev \
    # mysql2
    libmariadb-dev \
    nodejs &&\
    apt-get clean &&\
    npm i -g yarn@$YARN_VERSION &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    truncate -s 0 /var/log/*log

WORKDIR /app
