FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /carding
WORKDIR /carding
COPY Gemfile /carding/Gemfile
COPY Gemfile.lock /carding/Gemfile.lock
RUN bundle install
COPY . /carding
