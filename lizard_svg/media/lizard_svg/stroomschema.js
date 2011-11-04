(function() {
  $('document').ready(function() {
    var element, svg, _i, _len, _ref, _results;
    window.slider = new window.Slider('mySliderDiv');
    svg = document.getElementsByTagName("svg")[0];
    _ref = svg.getElementsByTagName("*");
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      element = _ref[_i];
      _results.push((function() {
        try {
          if (element.id.endsWith(":Q.indicator") > 0) {
            window.slider.manageObject("style:stroke", element.id);
          }
          if (element.id.endsWith(":overstort.indicator") > 0) {
            window.slider.manageObject("style:stroke", element.id);
          }
          if (element.id.endsWith(":H.meting") > 0) {
            window.slider.manageObject("height", element.id);
          }
          if (element.id.endsWith(":Status.indicator") > 0) {
            window.slider.manageObject("style:marker-end", element.id);
          }
          if (element.id.endsWith(":Pomp.inzet") > 0) {
            window.slider.manageObject("content", element.id);
          }
          if (element.id.endsWith(":VG.perc.setpoint") > 0) {
            window.slider.manageObject("content", element.id);
          }
          if (element.id.endsWith(":VG.perc.afgeleid") > 0) {
            window.slider.manageObject("content", element.id);
          }
          if (element.id.endsWith(":Q")) {
            window.slider.manageObject("content", element.id);
          }
          if (element.id.endsWith(":Q.setpoint")) {
            window.slider.manageObject("content", element.id);
          }
          if (element.id.endsWith(":neerslag")) {
            return window.slider.manageObject("content", element.id);
          }
        } catch (_e) {}
      })());
    }
    return _results;
  });
}).call(this);
