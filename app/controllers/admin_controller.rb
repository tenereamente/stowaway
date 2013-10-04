class AdminController < ApplicationController
  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'

    @waiting_users = User.invitation_pending.paginate(:page => params[:page], :per_page => 5)
  end

  def billing_events
    authorize! :index, @user, :message => 'Not authorized as an administrator.'

    @events = StripeEvent.all.paginate(page: params[:page], per_page: 3)
  end
end
