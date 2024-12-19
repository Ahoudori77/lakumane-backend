Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  get 'items/index'
  get '/protected_endpoint', to: 'protected#show'
  resources :categories, only: [:index]
  resources :items, only: [:index ,:show ,:create, :update, :destroy]
  resources :usage_records, only: [:create]
  resources :inventory, only: [:index, :update]
  resources :orders, only: [:index, :create]
end
