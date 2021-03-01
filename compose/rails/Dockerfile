FROM ruby:3.0.0-slim-buster

RUN apt-get update

RUN apt-get install nodejs npm -y
RUN npm install yarn

# pg gem`s dependencies
RUN apt-get install libpq-dev -y

WORKDIR /app

COPY ./rails-backend/Gemfile /app/Gemfile
RUN gem install bundler
RUN bundle

COPY  ./rails-backend/start /start
RUN chmod +x /start
