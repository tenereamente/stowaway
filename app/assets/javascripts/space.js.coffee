# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("#space_tag_list").select2({tags:[]})
  #$("#space_country").select2();
  $("#space_monthly_price").bind "slider:changed", (event, data) ->
    $("#monthly_price_label").html("Monthly Fee $" + data.value)
