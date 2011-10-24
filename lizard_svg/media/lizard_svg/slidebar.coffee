class Slider
  constructor: ->
    $('#mySliderDiv').slider
      orientation: "horizontal"
      min: 0
      max: 255
      animate: true
      slide: @onChange
      change: @onChange

  onChange: (event, ui) ->
    setStyleSub('#leidingNieuweweg', 'stroke', '#'+dec2hex(ui.value)+'00' + dec2hex(ui.value))
    setStyleSub('#leidingKlaaswaal', 'stroke', '#00' + dec2hex(ui.value) + dec2hex(ui.value))
    setStyleSub('#leidingPiershil', 'stroke', '#' + dec2hex(ui.value) + '00' + dec2hex(ui.value))
    setStyleSub('#leidingMookhoek', 'stroke', '#00' + dec2hex(ui.value) + dec2hex(ui.value / 2))

dec2hex = (i) ->
   ((i >> 0)+0x10000).toString(16).substr(-2)

setStyleSub = (itemId, sub, value) ->
  re = new RegExp(sub + ":[^;]+;","g");
  item = $(itemId)
  styleOrig = item.attr('style')
  item.attr('style', styleOrig.replace re, "#{sub}:#{value};")

$('document').ready ->
  window.slider = new Slider()