require "rails_identity"

Rails.application.routes.draw do

  get "/app", to: redirect("/index.html")

  resources :products, shallow: true do
    resources :product_images
    match '(products/:product_id/)product_images(/:id)' => 'product_images#options', via: [:options]
    resources :reviews
    match '(products/:product_id/)reviews(/:id)' => 'reviews#options', via: [:options]
  end
  match 'products(/:id)' => 'products#options', via: [:options]

  resources :carts, shallow: true do
    resources :items
    match '(carts/:cart_id/)items(/:id)' => 'items#options', via: [:options]
  end
  match 'carts(/:id)' => 'carts#options', via: [:options]

  resources :orders, shallow: true do
    resources :items
    match '(orders/:order_id/)items(/:id)' => 'items#options', via: [:options]
  end
  match 'orders(/:id)' => 'orders#options', via: [:options]

  mount RailsIdentity::Engine, at: "/"
end
