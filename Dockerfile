FROM ruby:2.5.0
LABEL maintainer="@kkenya"

ENV APP_ROOT /rails_app

RUN apt-get update -qq && \
    apt-get install -y nodejs \
                       mysql-client \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# /tmp配下のファイルに変更がない限りbundle installを実行しない
WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN   bundle install

WORKDIR $APP_ROOT
COPY . $APP_ROOT
