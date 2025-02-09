# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

# --- Core ---
gem 'rails', '~> 7.1.5', '>= 7.1.5.1'
gem 'sprockets-rails' # Asset pipeline for Rails

# --- Database ---
gem 'pg', '~> 1.5' # PostgreSQL database adapter
gem 'annotate' # Adds schema annotations to models

# --- Web Server ---
gem 'puma', '>= 5.0' # Web server for Rails

# --- Background Jobs ---
gem 'sidekiq' # Background job processing
gem 'redis', '>= 4.0.1' # Required for Sidekiq

# --- Environment Configuration ---
gem 'dotenv-rails' # Load environment variables from .env file

# --- Authentication & Authorization ---
gem 'devise' # User authentication
gem 'pundit' # Role-based authorization
gem 'cpf_cnpj', '~> 0.2.1'

# --- Web Scraping ---
gem 'nokogiri' # HTML and XML parsing

# --- Testing ---
group :test do
  gem 'rspec-rails' # Testing framework for Rails
  gem 'factory_bot_rails' # Test data generation
  gem 'faker' # Random test data generator
end

# --- Documentation ---
gem 'rails-erd' # Generate database relationship diagrams
gem 'redoc-rails' # OpenAPI documentation viewer
gem 'rswag' # Generate Swagger documentation

# --- Optimization & Utilities ---
gem 'bootsnap', require: false # Speeds up boot time by caching
gem 'foreman' # Process management tool for Rails and Sidekiq

# --- Development Tools ---
group :development do
  gem 'debug', platforms: %i[mri windows] # Debugging tools
  gem 'letter_opener'
end

gem "importmap-rails", "~> 2.1"

