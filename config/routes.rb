Rails.application.routes.draw do
  root 'query_tables#index'

  get 'dashboard', to: 'home#dashboard'
  get 'home/dashboard'

  devise_for :users

  resources :issued_graphs

  resources :converted_graphs

  resources :imported_graphs

  resources :sent_graphs

  resources :graphs

  resources :widgets

  resources :query_tables

  resources :queries
end
