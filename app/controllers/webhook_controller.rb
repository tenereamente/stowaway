class WebhookController < ApplicationController
  protect_from_forgery with: :null_session

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
