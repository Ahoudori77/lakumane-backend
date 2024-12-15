Rails.application.routes.draw do
  get 'items/index'
  resources :categories, only: [:index]
  resources :items, only: [:index ,:show ,:create, :update, :destroy]
  resources :usage_records, only: [:create]
end
