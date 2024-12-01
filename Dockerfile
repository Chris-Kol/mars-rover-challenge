FROM ruby:3.2

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

COPY . .

RUN chmod +x bin/mars_rover

CMD ["./bin/mars_rover"]