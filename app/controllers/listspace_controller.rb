class ListspaceController < ApplicationController
  def index
    @users = User.all
  end
end
