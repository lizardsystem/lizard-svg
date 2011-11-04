
$('document').ready ->
  window.slider = new window.Slider('mySliderDiv')
  svg = document.getElementsByTagName("svg")[0]
  for element in svg.getElementsByTagName("*")
    try
      if element.id.endsWith(":H.meting") > 0
        window.slider.manageObject("height", element.id)

      if element.id.endsWith(".indicator") > 0
        window.slider.manageObject("::color", element.id)

      if element.id.endsWith(":Pomp.inzet") > 0
        window.slider.manageObject("content", element.id)
      if element.id.endsWith(":VG.perc.setpoint") > 0
        window.slider.manageObject("content", element.id)
      if element.id.endsWith(":VG.perc.afgeleid") > 0
        window.slider.manageObject("content", element.id)
      if element.id.endsWith(":Q")
        window.slider.manageObject("content", element.id)
      if element.id.endsWith(":Q.setpoint")
        window.slider.manageObject("content", element.id)
      if element.id.endsWith(":neerslag")
        window.slider.manageObject("content", element.id)
