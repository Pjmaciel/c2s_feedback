# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/swagger'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      get 'health/show'
      get '/health', to: 'health#show'
    end
  end

  # Health check for Fly.io
  get '/up' => proc { [200, {}, ['OK']] }

  #  principal
  root 'pages#construction'

  # Static pages
  get '/construction', to: 'pages#construction'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'

  # Sidekiq Web UI (only accessible to Admin in the future)
  mount Sidekiq::Web => '/sidekiq'
end
