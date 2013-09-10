StowAway::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  get 'search' => 'search#index'
  get 'spaces' => 'storage_spaces#index'
  get 'space' => 'space#index'
  get 'listspace' => 'listspace#index'
  get 'listspace/map' => 'listspace#map'

  get 'admin' => 'admin#index'
  get "login" => redirect("users#sign_in")
 
end