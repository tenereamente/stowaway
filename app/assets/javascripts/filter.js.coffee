$(document).ready ->
  $(".toggle-topbar").click (event) ->
    $("section.top-bar-section").toggle("slow")
