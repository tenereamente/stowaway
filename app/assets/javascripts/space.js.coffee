# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("#space_tag_list").select2({tags:[]})
  #$("#space_country").select2();
  $("#space_monthly_price").bind "slider:changed", (event, data) ->
    $("#monthly_price_label").html("$" + data.value)

  $(".book-it-button").click (event) ->
    token = (res) ->
      input = $('<input type=hidden name=stripeToken />').val(res.id)
      $('form').append(input).submit() 

    price = parseInt($(event.target).data("price"))

    StripeCheckout.open
      key: $(event.target).data("stripe_public_key")
      address: false
      amount: 100 * price
      currency: 'usd'
      name: 'Monthly storage rental'
      description: $(event.target).data("address")
      panelLabel: 'Checkout'
      token: token
    return false