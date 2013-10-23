RailsAdmin.config do |config|
  config.current_user_method { current_user }
  config.main_app_name = ["Stowaway", "BackOffice"]
  config.included_models = ["Space", "User"]
  config.authorize_with do
    redirect_to root_path unless current_user.has_role? :admin
  end
  #Rails.application.reload_routes!
  config.navigation_static_links = {
    'Billing Events' => '/admin/billing_events',
    'New Blog Post' => '/posts/new'
  }
end