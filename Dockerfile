# Step 1: Build stage
FROM ruby:2.7.5 AS builder

WORKDIR /app

# Install dependencies
RUN ruby --version
COPY Gemfile Gemfile.lock ./
RUN bundle --version
RUN gem install bundler:2.3.6
RUN bundle --version
RUN bundle install

# Step 2: Final stage
FROM ruby:2.7.5 AS runtime

WORKDIR /app

# Copy only necessary files from the build stage
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY . .

RUN bundle --version

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]