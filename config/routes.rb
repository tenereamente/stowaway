StowAway::Application.routes.draw do
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  namespace :user do
    root :to => "home#dashboard"
  end
  
  resources :users
  resources :storagespaces, :as => 'storage_spaces'
  get 'search' => 'search#index'
  get '/map' => 'storagespaces#map'

  get 'admin' => 'admin#index'
  get "/login" => redirect("/users")
 
end