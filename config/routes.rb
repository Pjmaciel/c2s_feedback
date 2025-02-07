# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # Health check for Fly.io
  get '/up' => proc { [200, {}, ['OK']] }

  #autentication
  devise_for :users

  #  principal
  root to: 'pages#home'

  # Static pages
  get '/home', to: 'pages#construction'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'

  # Sidekiq Web UI (only accessible to Admin in the future)
  mount Sidekiq::Web => '/sidekiq'

  get 'redoc/index'
  mount Rswag::Ui::Engine => '/swagger'
  mount Rswag::Api::Engine => '/api-docs'

  get '/redoc' => 'redoc#index'

  namespace :api do
    namespace :v1 do
      get 'health/show'
      get '/health', to: 'health#show'
    end
  end
end
