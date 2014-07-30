Rails.application.routes.draw do
  root 'home#dashboard'
  get 'dashboard', to: 'home#dashboard', as: :dashboard
  get 'home/dashboard'

  get 'email' , to: 'home#email' , as: :email

  devise_for :users
  resources :graphs
  resources :widgets
  resources :tables
  resources :queries


  get '/users', to: 'users#index'
  get '/widget_variables/:id', to: 'widgets#get_new_variables'
  get '/graph_headers/:id/:type', to: 'graphs#get_headers'
  post '/widget/update_page', to: 'widgets#update_page'
  get '/providers', to: 'providers#index'
  get '/providers/:brand', to: 'providers#providers_by_brand'
end
