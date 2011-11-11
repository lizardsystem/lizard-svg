(function() {
  $('document').ready(function() {
    var element, svg, _i, _len, _ref, _results;
    window.slider = new window.Slider('mySliderDiv', 'itsTextDiv');
    window.slider.setMin(1234567890000);
    window.slider.setMax(1253567890000);
    svg = document.getElementsByTagName("svg")[0];
    _ref = svg.getElementsByTagName("*");
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      element = _ref[_i];
      _results.push((function() {
        try {
          if (element.id.indexOf(":flow.indicator") > 0) {
            window.slider.manageObject("::color", element.id);
          }
          if (element.id.indexOf(":pump.indicator") > 0) {
            window.slider.manageObject("::color", element.id);
          }
          if (element.id.indexOf(":pomp.inzet") > 0) {
            return window.slider.manageObject("content", element.id);
          }
        } catch (_e) {}
      })());
    }
    return _results;
  });
}).call(this);
