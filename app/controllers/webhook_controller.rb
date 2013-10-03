class WebhookController < ApplicationController
  protect_from_forgery with: :null_session

  def record_stripe_webhook
    if StripeEvent.create!(event_id: params[:id], type: params[:type], data: params[:data], livemode: params[:livemode])
      # TODO handle duplicate event errors.
      # TODO figure out where the json indexes need to go
      render :json => "{\"r\": \"ok\"}"
    else
      render :json => "{\"r\": \"failed\"}"
    end
  end
end
