StowAway::Application.routes.draw do
  
  
  get '/admin/billing_events' => 'admin#billing_events' # TODO move to rails_admin custom action
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

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

  get "/login" => redirect("/users/sign_in")
 
  mount Blogit::Engine => "/blog"
  
  get '/orders/subregion_options' => 'orders#subregion_options'
end