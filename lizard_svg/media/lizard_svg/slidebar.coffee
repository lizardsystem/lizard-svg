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
  # for i in $(grep id=.leiding[A-Z] ./lizard_svg/templates/overzicht.svg | cut -d\" -f2 | sort); do echo "  window.slider.manageObject('$i')"; done
  window.slider.manageObject('leidingBlaaksedijk')
  window.slider.manageObject('leidingBoezemkade')
  window.slider.manageObject('leidingDegorzen')
  window.slider.manageObject('leidingHeienoord')
  window.slider.manageObject('leidingHoeksedijk')
  window.slider.manageObject('leidingIrenestraat')
  window.slider.manageObject('leidingKlaaswaal')
  window.slider.manageObject('leidingKlaaswaalNumansdorpnoord')
  window.slider.manageObject('leidingMijlpolder')
  window.slider.manageObject('leidingMijnsheerenland')
  window.slider.manageObject('leidingMookhoek')
  window.slider.manageObject('leidingNassaulaan')
  window.slider.manageObject('leidingNieuwbeijerland')
  window.slider.manageObject('leidingNieuwendijk')
  window.slider.manageObject('leidingNieuwendijkZuidbeijerland')
  window.slider.manageObject('leidingNieuweweg')
  window.slider.manageObject('leidingNumansdorp')
  window.slider.manageObject('leidingPiershil')
  window.slider.manageObject('leidingSchenkel')
  window.slider.manageObject('leidingSimonsdijkje')
  window.slider.manageObject('leidingStrijensas')
  window.slider.manageObject('leidingWestmaas')
  window.slider.manageObject('leidingWestmaasMijnsheerenland')
  window.slider.manageObject('leidingZuidbeijerland')
  window.slider.manageObject('leidingZweedsestraat')
  # for i in $(grep id=.pomprg[A-Z] ./lizard_svg/templates/overzicht.svg | cut -d\" -f2 | sort); do echo "  window.slider.manageObject('$i')"; done
  window.slider.manageObject('pomprgblaaksedijk')
  window.slider.manageObject('pomprgboezemkade')
  window.slider.manageObject('pomprgdegorzen')
  window.slider.manageObject('pomprgheienoord')
  window.slider.manageObject('pomprghoeksedijk')
  window.slider.manageObject('pomprgirenestraat')
  window.slider.manageObject('pomprgklaaswaal')
  window.slider.manageObject('pomprgmijlpolder')
  window.slider.manageObject('pomprgMijnsheerenland')
  window.slider.manageObject('pomprgmookhoek')
  window.slider.manageObject('pomprgnassaulaan')
  window.slider.manageObject('pomprgnieuwbeijerland')
  window.slider.manageObject('pomprgnieuwendijk')
  window.slider.manageObject('pomprgnieuweweg')
  window.slider.manageObject('pomprgnumansdorp')
  window.slider.manageObject('pomprgnumansdorpnoord')
  window.slider.manageObject('pomprgpiershil')
  window.slider.manageObject('pomprgschenkel')
  window.slider.manageObject('pomprgsimonsdijkje')
  window.slider.manageObject('pomprgstrijensas')
  window.slider.manageObject('pomprgwestmaas')
  window.slider.manageObject('pomprgzuidbeijerland')
  window.slider.manageObject('pomprgzweedsestraat')
