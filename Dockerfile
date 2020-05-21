FROM ruby:2.7-slim-buster

ENV LANG=C.UTF-8\
  GEM_HOME=/bundle\
  BUNDLE_JOBS=4\
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH\
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

COPY Gemfile Gemfile.lock ./

RUN apt-get update -qq && apt-get install -y \
  # nokogiri
  build-essential libpq-dev \
  # mysql2
  libmariadb-dev \
  nodejs && \
  bundle install --clean

WORKDIR /app
