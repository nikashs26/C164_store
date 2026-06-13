Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  resources :users, only: [ :new, :create, :show ]
  get "signup", to: "users#new", as: :signup
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :products do
    resources :reviews, except: [ :index, :show, :new ]
  end

  resources :categories, except: [ :show ]

  resource :cart, only: [ :show ] do
    post "add/:product_id", to: "carts#add_item", as: :add_item
    patch "items/:line_item_id", to: "carts#update_item", as: :update_item
    delete "items/:line_item_id", to: "carts#remove_item", as: :remove_item
  end

  resources :orders, only: [ :index, :show, :create ]
end
