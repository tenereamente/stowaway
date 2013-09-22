class HomeController < ApplicationController
  def index
    @resource = User.new
    # select pre-launch layout if nobody logged in
    if user_signed_in?
      render 'dashboard', :layout => "application"
    else
      # For now, we send the splash page which has no nav bar
      # post-launch, this will be the sales page instead.
      render :layout => "prelaunchlayout"
    end
  end
  def dashboard
  end

  def home
  end

  def terms
  end
end
