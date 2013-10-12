# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("#space_tag_list").select2({tags:[]})
  #$("#space_country").select2();
  $("#space_monthly_price").bind "slider:changed", (event, data) ->
    $("#monthly_price_label").html("$" + data.value)

  $("#space_environment_indoor").click (event) ->
    # hide the outdoor options, show the indoor
    $.showIndoorOptions()
    $.hideOutdoorOptions()
    $("label#indoor_button_label").toggleClass('active', true)
    $("label#outdoor_button_label").toggleClass('active', false)


  $("#space_environment_outdoor").click (event) ->
    # hide the indoor options, show the outdoor
    $.showOutdoorOptions()
    $.hideIndoorOptions()
    $("label#outdoor_button_label").toggleClass('active', true)
    $("label#indoor_button_label").toggleClass('active', false)

  $("#space_type_attic").click (event) ->
    $("label#attic_button_label").toggleClass('active', true)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("#access_button_group").show()

  $("#space_type_garage").click (event) ->
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', true)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("#access_button_group").show()


  $("#space_type_spare_room").click (event) ->
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', true)
    $("label#basement_button_label").toggleClass('active', false)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("#access_button_group").show()

  $("#space_type_basement").click (event) ->
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', true)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("#access_button_group").show()


  $("#space_type_driveway").click (event) ->
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', true)
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("#access_button_group").show()



  $("#space_type_covered").click (event) ->
    $("label#covered_area_button_label").toggleClass('active', true)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("#access_button_group").show()


  $("#space_type_uncovered").click (event) ->
    $("label#uncovered_area_button_label").toggleClass('active', true)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("#access_button_group").show()

  $("#space_access_limited").click (event) ->
    $("label#limited_button_label").toggleClass('active', true)
    $("label#by_appointment_button_label").toggleClass('active', false)
    $("label#anytime_button_label").toggleClass('active', false)

  $("#space_access_appointment").click (event) ->
    $("label#limited_button_label").toggleClass('active', false)
    $("label#by_appointment_button_label").toggleClass('active', true)
    $("label#anytime_button_label").toggleClass('active', false)

  $("#space_access_anytime").click (event) ->
    $("label#limited_button_label").toggleClass('active', false)
    $("label#by_appointment_button_label").toggleClass('active', false)
    $("label#anytime_button_label").toggleClass('active', true)

  $("#climate_checkbox_label").click (event) ->
    $(event.target).toggleClass('active')

  $("#lockable_checkbox_label").click (event) ->
    $(event.target).toggleClass('active')

  $("#attended_checkbox_label").click (event) ->
    $(event.target).toggleClass('active')

  $.showOutdoorOptions = ->
    $("#what_kind_of_space").show()
    $("#outdoor_button_group").show()

  $.showIndoorOptions = ->
    $("#what_kind_of_space").show()
    $("#indoor_button_group").show()

  $.hideOutdoorOptions = ->
    $("#outdoor_button_group").hide()

  $.hideIndoorOptions = ->
    $("#indoor_button_group").hide()

  $(".book-it-button").click (event) ->
    token = (res) ->
      input = $('<input type=hidden name=stripeToken />').val(res.id)
      $('form').append(input).submit() 
      # TODO send the space ID and token in to the charges controller
      # we pull the price from the database inside the charges controller rather
      # than trusting the price to be sent in from a form. Hi haters!

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