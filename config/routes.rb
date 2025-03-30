Rails.application.routes.draw do
  get 'emails/edit'
  get 'emails/update'
  resources :password_resets, only: %i[new create edit update]
  resource :email, only: %i[edit update]
  get 'email/confirm' => 'emails#confirm', as: :email_confirm

  get '/magic_link/portal' => 'magic_links#portal', as: :magic_link_portal
  post '/magic_link/login' => 'magic_links#login', as: :magic_link_login

  post '/magic_link/generate' => 'magic_links#generate'
  get '/magic_link/authenticate' => 'magic_links#authenticate', as: :magic_link_authenticate
  get '/magic_link/index' => 'magic_links#index', as: :magic_links_index
  post '/magic_link/create_schedule' => 'magic_links#create_schedule', as: :magic_link_create
  get '/magic_link/edit_schedule/:id' => 'magic_links#edit_schedule', as: :edit_magic_link_schedule
  patch '/magic_link/update_schedule/:id' => 'magic_links#update_schedule', as: :update_magic_link_schedule
  delete '/magic_link/magic_link_logout' => 'magic_links#magic_link_logout', as: :magic_link_logout

  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    get 'sessions/new' => 'sessions#new', as: :login
    post 'sessions' => 'sessions#create'
    delete 'sessions' => 'sessions#destroy', as: :logout
    resources 'logs', only: [:index]
  end

  resource :user_setting, only: %i[show update]

  resources :schedules, only: %i[index create edit update]
  get 'schedule/:id/archive' => 'schedules#archive', as: :archive_schedule
  patch 'schedule/:id/archive' => 'schedules#archive_complete', as: :archive_complete_schedule
  get 'schedules/:id/notification' => 'schedules#notification', as: :notification_schedule

  get 'temp' => 'temp#index'

  resources :registrations, only: %i[new create]
  get 'registrations/edit' => 'registrations#edit', as: :edit_registration
  patch 'registrations' => 'registrations#update'

  get 'terms' => 'terms#show'
  get 'terms/embed' => 'terms#embed'

  get 'login' => 'sessions#new', as: :login
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy', as: :logout

  root 'home#index'
end
