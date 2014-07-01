Rails.application.routes.draw do
  root 'home#dashboard'
  get 'dashboard', to: 'home#dashboard', as: :dashboard
  get 'home/dashboard'
  get '/query_table_widgets/:id', to: 'query_tables#show'

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
