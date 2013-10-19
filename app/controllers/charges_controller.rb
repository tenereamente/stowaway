class ChargesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
  end

  def create
    @space = Space.find(params[:space_id])
    @amount = @space.monthly_price * 100 # price is stored in dollars, convert to cents
    # exception catching is disabled here because we don't have extensive error handling
    # protocols defined yet. It is better to not catch the exceptions and let them go
    # up the stack to be logged in sentry rather than catching and ignoring them here.
    begin
      plan = Stripe::Plan.retrieve("#{@space.monthly_price}_monthly")
      # TODO: catch the exception when the plan doesn't exist and create a snowflake plan on the fly?

      # TODO: consider moving to stripe connect to enable more of a marketplace model where the
      # stripe customer is on our top-level account and can purchase from multiple providers.
      # Currently a customer can only rent a single space.

      # TODO: debug customer creation
      customer = Stripe::Customer.create(
        email: current_user.email, 
        card:  params[:stripeToken],
        plan:  plan
      )

      # save customer ID in the user record, mark the space as booked
      current_user.update_attribute(:stripe_customer_id, customer.id)
      @space.update_attribute(:available, false)

      # add last month rent as a deposit on the invoice
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => "Stowaway.co last months rent for #{@space.normalized_address}",
        :currency    => 'usd'
      )
    #rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      #body = e.json_body
      #err  = body[:error]

      redirect_to space_path(@space), alert: 'Congratulations, you have booked this space'

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

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path # TODO redirect to a better spot
  end

end
