class HomeController < ApplicationController
  def index
    @users = User.all
    # select pre-launch layout if nobody logged in
    if user_signed_in?
      render :layout => "application"
    else
      render :layout => "prelaunchlayout"
    end
  end
end
