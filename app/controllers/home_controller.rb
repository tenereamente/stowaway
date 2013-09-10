class HomeController < ApplicationController
  def index
    @resource = User.new
    # select pre-launch layout if nobody logged in
    if user_signed_in?
      render :layout => "application"
    else
      render :layout => "prelaunchlayout"
    end
  end
end
