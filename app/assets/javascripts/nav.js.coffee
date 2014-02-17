$(document).ready ->
  $("#toggle").click (event) ->
    $("form.filter").toggle("slow")
