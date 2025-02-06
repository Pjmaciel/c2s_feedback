# syntax = docker/dockerfile:1

# Use Ruby 3.3.0-slim (melhor para Docker)
FROM ruby:3.3.0-slim as base

# Set working directory
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Install essential system packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git libpq-dev libvips pkg-config \
    ruby-dev make g++ gcc postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives/*

# Install Bundler
RUN gem install bundler

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 5 --retry 5 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Ensure the 'rails' user has ownership of necessary directories
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /usr/local/bundle /rails /rails/tmp /rails/log /rails/storage

USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
