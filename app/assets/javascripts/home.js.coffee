# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###
document.addEventListener "click", (->

  red = Math.round(Math.random() * 255)
  green = Math.round(Math.random() * 255)
  blue = Math.round(Math.random() * 255)
  rgb = "rgb(" + red + "," + green + "," + blue + ")"
  crossfade = "all"
  document.body.style.backgroundColor = rgb
  document.body.style.transition = crossfade
), false
###