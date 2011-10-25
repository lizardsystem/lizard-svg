getObjectClass = (obj) ->
    if (obj && obj.constructor && obj.constructor.toString)
       arr = obj.constructor.toString().match(
            /function\s*(\w+)/);

        if (arr && arr.length == 2)
            return arr[1]

    return undefined;


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
      slide: @onChange
      change: @onChange

  onChange: (event, ui) ->
    #console.log getObjectClass(this) // undefined
    that = window.slider
    for item in that.managed
        key = item.key
        for candidate in item.value
          if candidate.timestamp > ui.value
            break
        setStyleSub(key, 'stroke', candidate.color)
    null

  manageObject: (itemId, colorSequence) ->
    #console.log getObjectClass(this) // Slider
    that = this
    $.getJSON "http://localhost:8000/api/?item=#{itemId}",
      (data) -> that.managed.push
        key: itemId
        value: data


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

