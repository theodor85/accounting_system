FROM ruby:3.0.0-slim-buster

RUN apt-get update
RUN apt-get install nodejs npm
RUN npm install yarn

WORKDIR /app

RUN gem install bundler
RUN bundle

RUN chmod +x start
