class ChargesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
  end

  def create
    # Amount in cents
    @space = Space.find(params[:space_id])
    @amount = @space.monthly_price * 100 # price is stored in dollars, convert to cents
    
    plan = Stripe::Plan.retrieve("#{@space.monthly_price}_monthly")
    # TODO: try-except to detect when the plan doesn't exist and create a snowflake plan on the fly

    # TODO: check to see if the current user already has a customer ID, if so, use that one rather
    # than creating a new one.

    customer = Stripe::Customer.create(
      email: current_user.email, 
      card:  params[:stripeToken],
      plan:  plan
    )

    # TODO add last month rent as a deposit on the invoice?

    # TODO save customer ID in the user record, mark the space as booked

    #charge = Stripe::Charge.create(
    #  :customer    => customer.id,
    #  :amount      => @amount,
    #  :description => 'Rails Stripe customer', # TODO
    #  :currency    => 'usd'
    #)

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path # TODO redirect to a better spot
  end

end
