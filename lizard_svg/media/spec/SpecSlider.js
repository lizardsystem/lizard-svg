(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  describe('Initialize Slider object', function() {
    return it('Slider object should exist', __bind(function() {
      return expect(window.Slider.name).toEqual("Slider");
    }, this));
  });
}).call(this);
