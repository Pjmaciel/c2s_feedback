# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

# --- Core ---
gem 'rails', '~> 7.1.5', '>= 7.1.5.1'
gem 'sprockets-rails'

# --- Database ---
gem 'annotate'             # Adds schema annotations to models
gem 'pg', '~> 1.5'         # PostgreSQL adapter for ActiveRecord

# --- Web Server ---
gem 'puma', '>= 5.0'

# --- Authentication & Authorization ---
gem 'devise'               # User authentication
gem 'devise-jwt'           # JWT authentication for Devise
gem 'pundit'               # Role-based authorization

# --- API & Serialization ---
gem 'active_model_serializers' # JSON serialization for APIs
gem 'graphql' # GraphQL API support

# --- Background Jobs & Queues ---
gem 'redis', '>= 4.0.1'    # Required dependency for Sidekiq
gem 'sidekiq'              # Background job processing
gem 'sidekiq-cron'         # Cron job scheduling for Sidekiq

# --- Documentation ---
gem 'rails-erd'
gem 'redoc-rails'          # API documentation viewer
gem 'rswag'                # OpenAPI/Swagger documentation generator

# --- Security ---
gem 'brakeman', require: false # Static code analysis for vulnerabilities
gem 'rack-attack' # API rate limiting & abuse protection

# --- Monitoring & Logging ---
gem 'ahoy_matey'          # Request tracking & analytics
gem 'lograge'             # Optimized log formatting

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# --- Payments & Monetization ---
gem 'pay'                 # Subscription & payment integrations
gem 'stripe'              # Stripe payment processing

# --- CI/CD & Code Quality ---
group :development, :test do
  gem 'rubocop', require: false # Linter & code style enforcement
  gem 'simplecov', require: false # Code coverage analysis
end

# --- Development Tools ---
group :development do
  gem 'debug', platforms: %i[mri windows] # Debugging tools
  gem 'web-console' # Interactive debugging console for errors
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'           # Feature & integration testing
  gem 'database_cleaner'   # Ensures a clean test database
  gem 'factory_bot_rails'  # Factory pattern for test data
  gem 'faker'              # Random test data generator
  gem 'rspec-rails'        # Rails testing framework
  gem 'selenium-webdriver' # UI testing with Selenium
end

gem "dockerfile-rails", ">= 1.7", :group => :development
