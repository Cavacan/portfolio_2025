# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'unshared' => 'shared_users#unshared'
  get 'logs' => 'logs#index'

  resources :shared_lists, only: %i[index new create edit update] do
    member do
      get 'pdf'
    end
  end

  resources :shared_users, only: %i[show create destroy] do
    member do
      get 'edit_schedule/:schedule_id' => 'shared_users#edit', as: :edit_schedule
      patch 'complete_schedule/:schedule_id' => 'shared_users#complete_schedule', as: :complete_schedule
    end
  end
  get '/shared_user_session/:id', to: 'shared_user_sessions#show', as: :shared_user_session

  get 'emails/edit'
  get 'emails/update'
  resources :password_resets, only: %i[new create edit update]
  resource :email, only: %i[edit update]
  get 'email/confirm' => 'emails#confirm', as: :email_confirm

  namespace :magic_link do
    get 'portal' => 'portal#portal', as: :portal
    delete 'magic_link_logout' => 'portal#magic_link_logout', as: :magic_link_logout
    
    post 'login' => 'sessions#login', as: :magic_link_login
    post 'generate' => 'sessions#generate'
    get 'authenticate' => 'sessions#authenticate', as: :magic_link_authenticate

    get 'index' => 'schedules#index', as: :magic_links_index
    post 'create_schedule' => 'schedules#create_schedule', as: :magic_link_create
    get 'edit_schedule/:id' => 'schedules#edit_schedule', as: :edit_magic_link_schedule
    patch 'update_schedule/:id' => 'schedules#update_schedule', as: :update_magic_link_schedule
  end

  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    get 'sessions/new' => 'sessions#new', as: :login
    post 'sessions' => 'sessions#create'
    delete 'sessions' => 'sessions#destroy', as: :logout
    resources 'logs', only: [:index]
    resource :application_setting, only: %i[edit update]
  end

  resource :user_setting, only: %i[show] do
    patch :check_done
    patch :notification_time
  end

  resources :schedules, only: %i[index create edit update] do
    get :complete, on: :member
  end
  get 'schedule/:id/archive' => 'schedules#archive', as: :archive_schedule
  patch 'schedule/:id/archive' => 'schedules#archive_complete', as: :archive_complete_schedule
  get 'schedules/:id/notification' => 'schedules#notification', as: :notification_schedule

  get 'temp' => 'temp#index'

  resources :registrations, only: %i[new create]
  get 'registrations/edit' => 'registrations#edit', as: :edit_registration
  patch 'registrations' => 'registrations#update'

  get 'terms' => 'terms#show'
  get 'terms/embed' => 'terms#embed'
  get 'policy' => 'terms#policy'

  get 'login' => 'sessions#new', as: :login
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy', as: :logout

  root 'home#index'
end
