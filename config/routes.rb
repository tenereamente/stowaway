StowAway::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  get 'search' => 'search#index'
  get 'spaces' => 'spaces#index'
  get 'space' => 'space#index'
  get 'listspace' => 'listspace#index'
end