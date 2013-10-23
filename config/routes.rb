StowAway::Application.routes.draw do
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  resources :users do
    resources :charges
    resources :spaces, only: [:index]
  end

  post '/api/stripe_webhook' => 'webhook#record_stripe_webhook' 
  
  resources :spaces

  get 'terms' => 'home#terms'

  get 'search' => 'search#index'

  get 'admin' => 'admin#index'
  get '/admin/billing_events' => 'admin#billing_events'
  get "/login" => redirect("/users/sign_in")
 
  mount Blogit::Engine => "/blog"
end