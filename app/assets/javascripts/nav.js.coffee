$(document).ready ->
  $(".menu-link").bigSlide(side: 'right')

  $("nav#menu a").click (event) ->
    $('.menu-link').trigger('click')