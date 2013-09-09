class AdminController < ApplicationController
  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end
end
