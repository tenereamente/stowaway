class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # select pre-launch layout if nobody logged in
  layout :layout

  def layout
    if user_signed_in?
      "application"
    else
      "prelaunchlayout"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

end
