Rails.application.routes.draw do
  devise_for :users
  
  # Admin namespace
  namespace :admin do
    root "dashboard#index"
    get "dashboard", to: "dashboard#index"
    resources :products
  end
  
  # Public products (前台产品展示)
  resources :products, only: [:index, :show] do
    member do
      post :add_to_cart
    end
  end
  
  # Shopping cart
  resource :cart, only: [:show] do
    post 'add_item/:product_id', to: 'carts#add_item', as: :add_item
    patch 'increase_quantity/:id', to: 'carts#increase_quantity', as: :increase_quantity
    patch 'decrease_quantity/:id', to: 'carts#decrease_quantity', as: :decrease_quantity
    delete 'remove_item/:id', to: 'carts#remove_item', as: :remove_item
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
