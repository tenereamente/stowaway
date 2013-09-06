class SpacesController < ApplicationController
  def index
    @users = User.all
  end
end
