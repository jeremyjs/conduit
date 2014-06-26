Rails.application.routes.draw do
  root 'home#dashboard'
  get 'home/dashboard'

  resources :issued_graphs

  resources :converted_graphs

  resources :imported_graphs

  resources :sent_graphs

  resources :graphs

  resources :widgets
  resources :query_tables
  resources :queries

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
end
