class ChargesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      if @user.stripe_customer_id
        @customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
        @subscription = @customer.subscription
      end
      @spaces = @user.rentals
    end
  end
  def new
  end

  # We have plans for every $5 increment, named as 10_monthly, 15_monthly, etc.
  # so that we don't have to spend a ton of time pre-creating the plancs, just
  # create them on the fly as needed.
  def get_or_create_plan(price)
    plan = Stripe::Plan.retrieve("#{price}_monthly")
  rescue
    plan = Stripe::Plan.create(
      :amount => price * 100, # convert from dollars to cents to match stripe API
      :interval => 'month',
      :name => "#{price} monthly",
      :currency => 'usd',
      :id => "#{price}_monthly"
    )
  end

  def create
    @space = Space.find(params[:space_id])
    @amount = @space.monthly_price * 100 # price is stored in dollars, convert to cents
    # exception catching is disabled here because we don't have extensive error handling
    # protocols defined yet. It is better to not catch the exceptions and let them go
    # up the stack to be logged in sentry rather than catching and ignoring them here.
    begin

      plan = get_or_create_plan(@space.monthly_price)
      
      # TODO: consider moving to stripe connect to enable more of a marketplace model where the
      # stripe customer is on our top-level account and can purchase from multiple providers.
      # Currently a customer can only rent a single space.

      customer = Stripe::Customer.create(
        email: current_user.email, 
        card:  params[:stripeToken],
        plan:  plan
      )

      # save customer ID in the user record, mark the space as booked
      current_user.update_attribute(:stripe_customer_id, customer.id)
      @space.update_attribute(:available, false)
      @space.renters << current_user

      # add last month rent as a deposit on the invoice
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => "Stowaway.co last months rent for #{@space.normalized_address}",
        :currency    => 'usd'
      )

      redirect_to space_path(@space), alert: 'Congratulations, you have booked this space'

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to space_path(@space)
    end

      #puts "Status is: #{e.http_status}"
      #puts "Type is: #{err[:type]}"
      #puts "Code is: #{err[:code]}"
      # param is '' in this case
      #puts "Param is: #{err[:param]}"
      #puts "Message is: #{err[:message]}"
    #rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
    #rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
    #rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
    #rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
    #rescue => e
    # Something else happened, completely unrelated to Stripe
    #end

    
  end

end
