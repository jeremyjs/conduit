Rails.application.routes.draw do
  resources :widgets

  root 'home#dashboard'
  get 'home/dashboard'

  resources :query_tables

  resources :queries
end
