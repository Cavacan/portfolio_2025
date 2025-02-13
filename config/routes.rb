Rails.application.routes.draw do
  resources :registrations, only: [:new, :create]
  get 'registrations/edit' => 'registrations#edit', as: :edit_registration
  patch 'registrations' => 'registrations#update'
  get 'terms' => 'terms#show'
  get 'terms/embed' => 'terms#embed'
  root 'home#index'
end
