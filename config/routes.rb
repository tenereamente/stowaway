StowAway::Application.routes.draw do
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  resources :users do
    resources :charges
  end
  
  resources :spaces do
    resources :listings
  end

  # post launch, this will be served on root instead of the prelaunch page
  get 'home' => 'home#home'

  get 'search' => 'search#index'

  get 'admin' => 'admin#index'
  get "/login" => redirect("/users/sign_in")
 
end