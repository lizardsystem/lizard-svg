
$('document').ready ->
  window.slider = new window.Slider('mySliderDiv', 'itsTextDiv')
  window.slider.setMin(1234567890000)
  window.slider.setMax(1253567890000)
  svg = document.getElementsByTagName("svg")[0]
  for element in svg.getElementsByTagName("*")
    try
      if element.id.indexOf(":flow.indicator") > 0
        window.slider.manageObject("::color", element.id)
      if element.id.indexOf(":pump.indicator") > 0
        window.slider.manageObject("::color", element.id)
      if element.id.indexOf(":pomp.inzet") > 0
        window.slider.manageObject("content", element.id)
