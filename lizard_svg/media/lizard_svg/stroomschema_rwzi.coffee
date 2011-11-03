
$('document').ready ->
  window.slider = new Slider('mySliderDiv')
  svg = document.getElementsByTagName("svg")[0]
  for element in svg.getElementsByTagName("*")
    try
      if element.id.indexOf(":flow.indicator") > 0
        window.slider.manageObject("style:stroke", element.id)
      if element.id.indexOf(":pomp.indicator") > 0
        window.slider.manageObject("style:stroke", element.id)
      if element.id.indexOf(":pomp.inzet") > 0
        window.slider.manageObject("content", element.id)
