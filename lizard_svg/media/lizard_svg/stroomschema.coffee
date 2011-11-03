
$('document').ready ->
  window.slider = new window.Slider('mySliderDiv')
  svg = document.getElementsByTagName("svg")[0]
  for element in svg.getElementsByTagName("*")
    try
      if element.id.endsWith(":Q.indicator") > 0
        window.slider.manageObject("style:stroke", element.id)
      if element.id.endsWith(":overstort.indicator") > 0
        window.slider.manageObject("style:stroke", element.id)
      if element.id.endsWith(":H.meting") > 0
        window.slider.manageObject("height", element.id)

      if element.id.endsWith(":Status.indicator") > 0
        window.slider.manageObject("style:marker-end", element.id)

      if element.id.endsWith(":Pomp.inzet") > 0
        window.slider.manageObject("content", element.id)
      if element.id.endsWith(":VG.perc.setpoint") > 0
        window.slider.manageObject("content", element.id)
      if element.id.endsWith(":VG.perc.afgeleid") > 0
        window.slider.manageObject("content", element.id)
      if element.id.endsWith(":Q")
        window.slider.manageObject("content", element.id)
