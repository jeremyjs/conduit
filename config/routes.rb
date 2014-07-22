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


  get '/widget_variables/:id', to: 'widgets#get_new_variables'
  get '/graph_headers/:type', to: 'graphs#get_headers'
  post '/widget/update_page', to: 'widgets#update_page'
  get '/providers', to: 'providers#index'
end
