class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def after_sign_in_path_for(user)
    # This would be root_path but we don't have anything there yet
    #root_path
    spaces_path
  end

  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "prelaunchlayout"
    elsif
      "application"
    end
  end
end
