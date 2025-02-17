Rails.application.routes.draw do
  get '/magic_link/portal' => 'magic_links#portal', as: :magic_link_portal
  post '/magic_link/login' => 'magic_links#login', as: :magic_link_login

  post '/magic_link/generate' => 'magic_links#generate'
  get '/magic_link/authenticate' => 'magic_links#authenticate', as: :magic_link_authenticate
  get '/magic_link/index' => 'magic_links#index', as: :magic_links_index

  namespace :admin do
    get 'dashboard/index' => 'dashboard#index'
    get 'sessions/new' => 'sessions#new', as: :login
    post 'sessions/create' => 'sessions#create'
    delete 'sessions/destroy' => 'sessions#destroy', as: :logout
  end
  
  resources :schedules, only: [:index, :create, :edit, :update]
  get 'schedule/:id/archive' => 'schedules#archive', as: :archive_schedule
  patch 'schedule/:id/archive' => 'schedules#archive_complete', as: :archive_complete_schedule
  get 'schedules/:id/notification' => 'schedules#notification', as: :notification_schedule

  get 'temp' => 'temp#index'

  resources :registrations, only: [:new, :create]
  get 'registrations/edit' => 'registrations#edit', as: :edit_registration
  patch 'registrations' => 'registrations#update'

  get 'terms' => 'terms#show'
  get 'terms/embed' => 'terms#embed'

  get 'login' => 'sessions#new', as: :login
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy', as: :logout

  root 'home#index'
end
