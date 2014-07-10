Rails.application.routes.draw do
  root 'home#dashboard'
  get 'dashboard', to: 'home#dashboard', as: :dashboard
  get 'home/dashboard'

  get 'email' , to: 'home#email' , as: :email

  devise_for :users
  resources :issued_graphs
  resources :converted_graphs
  resources :imported_graphs
  resources :sent_graphs
  resources :graphs
  resources :widgets
  resources :query_tables
  resources :queries

  post '/widget/update_page', to: 'widgets#update_page'
end
