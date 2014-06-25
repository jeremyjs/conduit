Rails.application.routes.draw do
  root 'home#dashboard'
  get 'home/dashboard'

  resources :query_tables

  resources :queries
end
