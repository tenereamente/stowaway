class ChargesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
  end

  def create
    # Amount in cents
    @amount = 500 # TODO figure out how to get amount

    # TODO create a subscription rather than one-time charge

    customer = Stripe::Customer.create(
      :email => 'example@stripe.com', # TODO current user
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer', # TODO
      :currency    => 'usd'
    )

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

  def record_stripe_webhook
    event = ActiveSupport::JSON.decode(request.body)

    if StripeEvent.create(event.id, request.body)
      # TODO handle duplicate event errors.
      # TODO figure out where the json indexes need to go
      render :json => "{\"r\": \"ok\"}"
    else
      render :json => "{\"r\": \"failed\"}"
    end
  end

end
