class SpaceController < ApplicationController
  def index
    @users = User.all
  end
end
