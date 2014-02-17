# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  if $('.gmaps4rails_map').length > 0

    $.updateAddressAndBounds = ->
      geocoder = new google.maps.Geocoder
      position = Gmaps.map.map.getCenter()
      bounds = Gmaps.map.map.getBounds()
      $('#address_search_bounds').val(bounds)
      geocoder.geocode({ 'location': position }, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          # alert(results[0].formatted_address)
          $('#address_search_field').val(results[0].formatted_address)
      )

    Gmaps.map.callback = () ->
      # hook the idle event rather than center changed or bounds changed to
      # avoid callback floods
      google.maps.event.addListener Gmaps.map.map, 'idle', ->
        $.updateAddressAndBounds()
        #alert('map moved, now idle')




  $("#space_tag_list").select2({tags:[]})
  $("#space_monthly_price").bind "slider:changed", (event, data) ->
    $("#monthly_price_label").html("$" + data.value)

  $("#indoor_button_label").click (event) ->
    # hide the outdoor options, show the indoor
    $.showIndoorOptions()
    $.hideOutdoorOptions()
    $("label#indoor_button_label").toggleClass('active', true)
    $("label#outdoor_button_label").toggleClass('active', false)


  $("#outdoor_button_label").click (event) ->
    # hide the indoor options, show the outdoor
    $.showOutdoorOptions()
    $.hideIndoorOptions()
    $("label#outdoor_button_label").toggleClass('active', true)
    $("label#indoor_button_label").toggleClass('active', false)

  $("#attic_button_label").click (event) ->
    $("label#attic_button_label").toggleClass('active', true)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("#access_button_group").show()

  $("#garage_button_label").click (event) ->
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', true)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("#access_button_group").show()


  $("#spare_room_button_label").click (event) ->
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', true)
    $("label#basement_button_label").toggleClass('active', false)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("#access_button_group").show()

  $("#basement_button_label").click (event) ->
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', true)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("#access_button_group").show()


  $("#driveway_button_label").click (event) ->
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', true)
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("#access_button_group").show()



  $("#covered_area_button_label").click (event) ->
    $("label#covered_area_button_label").toggleClass('active', true)
    $("label#uncovered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("#access_button_group").show()


  $("#uncovered_area_button_label").click (event) ->
    $("label#uncovered_area_button_label").toggleClass('active', true)
    $("label#covered_area_button_label").toggleClass('active', false)
    $("label#driveway_button_label").toggleClass('active', false)
    $("label#attic_button_label").toggleClass('active', false)
    $("label#garage_button_label").toggleClass('active', false)
    $("label#spare_room_button_label").toggleClass('active', false)
    $("label#basement_button_label").toggleClass('active', false)
    $("#access_button_group").show()

  $("#onetime_button_label").click (event) ->
    $("label#onetime_button_label").toggleClass('active', true)
    $("label#by_appointment_button_label").toggleClass('active', false)
    $("label#open_anytime_button_label").toggleClass('active', false)

  $("#by_appointment_button_label").click (event) ->
    $("label#onetime_button_label").toggleClass('active', false)
    $("label#by_appointment_button_label").toggleClass('active', true)
    $("label#open_anytime_button_label").toggleClass('active', false)

  $("#open_anytime_button_label").click (event) ->
    $("label#onetime_button_label").toggleClass('active', false)
    $("label#by_appointment_button_label").toggleClass('active', false)
    $("label#open_anytime_button_label").toggleClass('active', true)

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
      $(event.target).closest("form").append(input).submit()
      # TODO send the space ID and token in to the charges controller
      # we pull the price from the database inside the charges controller rather
      # than trusting the price to be sent in from a form. Hi haters!

    price = parseInt($(event.target).data("price"))

    StripeCheckout.open
      key: $(event.target).data("stripe_public_key")
      address: false
      amount: (100 * price) * 2 # convert to cents, charge first and last months rent
      currency: 'usd'
      name: 'Monthly storage rental'
      description: $(event.target).data("address")
      panelLabel: 'Checkout'
      image: $(event.target).data('image')
      token: token
    return false

  $('select#order_country_code').change (event) ->
    select_wrapper = $('#order_state_code_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country_code = $(this).val()

    url = "/orders/subregion_options?parent_region=#{country_code}"
    select_wrapper.load(url)