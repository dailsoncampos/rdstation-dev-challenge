require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :products

  resource :cart, only: [:show] do
    post 'add_item', to: 'carts#add_product'
    patch 'update_item', to: 'carts#update_item'
    delete 'remove_product/:product_id', to: 'carts#remove_product'
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end