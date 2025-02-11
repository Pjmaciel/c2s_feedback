# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

# --- Core ---
gem 'rails', '~> 7.1.5', '>= 7.1.5.1'
gem 'sprockets-rails'

# --- Database ---
gem 'pg', '~> 1.5'
gem 'annotate'

# --- Web Server ---
gem 'puma', '>= 5.0'

# --- Background Jobs ---
gem 'sidekiq'
gem 'redis', '>= 4.0.1'
gem 'sidekiq-cron'

# --- Environment Configuration ---
gem 'dotenv-rails'

# --- Authentication & Authorization ---
gem 'devise'
gem 'pundit'
gem 'cpf_cnpj', '~> 0.2.1'

# --- Web Scraping ---
gem 'nokogiri'
gem 'selenium-webdriver'

# --- API ---
gem 'google-cloud-language'

# --- Testing ---
group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'database_cleaner-active_record'
  gem 'warden-rspec-rails'
  gem 'rails-controller-testing'
end

# --- Documentation ---
gem 'rails-erd'
gem 'redoc-rails'
gem 'rswag'

# --- Optimization & Utilities ---
gem 'bootsnap', require: false
gem 'foreman'

# --- Development Tools ---
group :development do
  gem 'debug', platforms: %i[mri windows]
  gem 'letter_opener'
  gem 'letter_opener_web'
end

# --- Front-end & Assets ---
gem 'importmap-rails', '~> 2.1'

# --- Pagination & Helpers ---
gem 'kaminari'
