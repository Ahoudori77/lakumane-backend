Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  get 'items/index'
  get '/protected_endpoint', to: 'protected#show'
  resources :categories, only: [:index]
  resources :items, only: [:index ,:show ,:create, :update, :destroy]
  resources :usage_records, only: [:index, :create]
  resources :inventory, only: [:index, :update]
  resources :orders, only: [:index, :create]
  
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :items, only: [:index, :show, :create, :update, :destroy]
      resources :inventory, only: [:index, :show, :create, :update, :destroy]
      resources :usage_records, only: [:index, :create]
      resources :orders, only: [:index, :show, :create, :update, :destroy] do
       collection do
          get :export_csv  # CSVエクスポート用エンドポイント
        end
        collection do
          post :import_csv  # CSVインポート用エンドポイント
        end
      end
      resources :notifications, only: [:index, :update, :create, :show] do
        collection do
          get :unread
        end
      end
    end
  end

  # プリフライト用のルーティング
  match '*path', to: 'application#preflight', via: [:options]
end
