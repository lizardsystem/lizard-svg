class ColorTimeSeries
  constructor: ->


class Slider
  constructor: (itemId, @managed=[]) ->
    $('#' + itemId).slider
      value: 0
      orientation: "horizontal"
      min: 0
      max: 255
      length: 255
      animate: true
      #slide: @onChange
      change: @onChange

  onChange: (event, ui) ->
    console.log event, ui.value
    console.log this.managed
    for item in @managed
        setStyleSub('#leidingNieuweweg', 'stroke', '#' + dec2hex(ui.value) + '00' + dec2hex(ui.value))
    null

  manageObject: (itemId, colorSequence) ->
    that = this
    $.getJSON "http://localhost:8000/api/?item=#{itemId}",
          (data) -> that.managed.push [itemId, data]


dec2hex = (i) ->
   ((i >> 0) + 0x10000).toString(16).substr(-2)


setStyleSub = (itemId, sub, value) ->
  re = new RegExp(sub + ":[^;]+;","g");
  item = $("#" + itemId)
  styleOrig = item.attr('style')
  item.attr('style', styleOrig.replace re, "#{sub}:#{value};")


$('document').ready ->
  window.slider = new Slider('mySliderDiv')
  window.slider.manageObject('leidingNieuweweg')
  window.slider.manageObject('leidingKlaaswaal')
  window.slider.manageObject('leidingPiershil')
  window.slider.manageObject('leidingMookhoek')

