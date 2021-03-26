FROM ruby:3.0.0-slim-buster

RUN apt-get update

RUN apt-get install nodejs npm -y
RUN apt-get install shared-mime-info -y
RUN npm install yarn
ENV PATH="/node_modules/yarn/bin:${PATH}"

# pg gem`s dependencies
RUN apt-get install libpq-dev -y

WORKDIR /app

RUN gem install bundler
COPY ./rails-backend/Gemfile /app/Gemfile
COPY ./rails-backend/Gemfile.lock /app/Gemfile.lock
RUN bundle

COPY  ./rails-backend/start /start
RUN chmod +x /start
