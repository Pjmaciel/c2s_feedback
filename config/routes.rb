# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # Health check for Fly.io
  get '/up' => proc { [200, {}, ['OK']] }

  #autentication
  devise_for :users

  # Rotas personalizadas para clientes
  devise_scope :user do
    # Rotas de login para clientes
    get 'clients/sign_in', to: 'clients/sessions#new', as: :new_client_session
    post 'clients/sign_in', to: 'clients/sessions#create', as: :client_session

    # Rotas de login para funcionários
    get 'employees/sign_in', to: 'employees/sessions#new', as: :new_employee_session
    post 'employees/sign_in', to: 'employees/sessions#create', as: :employee_session

    # Rotas de registro para clientes
    get 'clients/sign_up', to: 'clients/registrations#new', as: :new_client_registration
    post 'clients', to: 'clients/registrations#create', as: :client_registration

    # Rotas de registro para funcionários
    get 'employees/sign_up', to: 'employees/registrations#new', as: :new_employee_registration
    post 'employees', to: 'employees/registrations#create', as: :employee_registration

  end


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

      resources :evaluations
    end
  end
end
