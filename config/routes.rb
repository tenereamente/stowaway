StowAway::Application.routes.draw do
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  resources :users
  resources :space, :as => 'storage_spaces'
  
  # post launch, this will be served on root instead of the prelaunch page
  get 'home' => 'home#home'

  get 'search' => 'search#index'
  get '/map' => 'storagespaces#map'

  get 'admin' => 'admin#index'
  get "/login" => redirect("/users")
 
end