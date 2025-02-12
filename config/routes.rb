Rails.application.routes.draw do
  get 'terms' => 'terms#show'
  get 'terms/embed' => 'terms#embed'
  get 'signin02/new' => 'signin02#new'
  post 'signin02/create' => 'signin02#create'
  get 'signin01/new' => 'signin01#new'
  post 'signin01/create' => 'signin01#create'
  root 'home#index'
end
