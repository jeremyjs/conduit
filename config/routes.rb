Rails.application.routes.draw do
  resources :widgets

  root 'query_tables#index'
  get 'home/dashboard'

  resources :query_tables

  resources :queries
end
