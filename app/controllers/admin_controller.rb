class AdminController < ApplicationController
  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @waiting_users = User.invitation_pending
  end
end
