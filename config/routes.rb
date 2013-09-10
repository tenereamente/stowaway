StowAway::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  resources :storagespaces, :as => 'storage_spaces'
  get 'search' => 'search#index'
  get 'listspace/map' => 'listspace#map'

  get 'admin' => 'admin#index'
  get "/login" => redirect("/users")
 
end