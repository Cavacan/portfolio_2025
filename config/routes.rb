Rails.application.routes.draw do
  resources :schedules, only: [:index, :create, :edit, :update]
  get 'schedule/:id/archive' => 'schedules#archive', as: :archive_schedule
  patch 'schedule/:id/archive' => 'schedules#archive_complete', as: :archive_complete_schedule

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
