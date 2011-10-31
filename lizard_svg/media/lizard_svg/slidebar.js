(function() {
  /*
  #
  # This program is free software: you can redistribute it and/or modify
  # it under the terms of the GNU General Public License as published by
  # the Free Software Foundation, either version 3 of the License, or
  # (at your option) any later version.
  #
  # This program is distributed in the hope that it will be useful, but
  # WITHOUT ANY WARRANTY; without even the implied warranty of
  # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  # General Public License for more details.
  #
  # You should have received a copy of the GNU General Public License
  # along with the lizard_waterbalance app.  If not, see
  # <http://www.gnu.org/licenses/>.
  #
  # Copyright 2011 Nelen & Schuurmans
  #
  #******************************************************************************
  #
  # Initial programmer: Mario Frasca
  # Initial date:       2011-10-24
  #
  #******************************************************************************
  #
  */
  var Slider, getObjectClass;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  getObjectClass = function(obj) {
    var arr;
    if (obj && obj.constructor && obj.constructor.toString) {
      arr = obj.constructor.toString().match(/function\s*(\w+)/);
      if (arr && arr.length === 2) {
        return arr[1];
      }
    }
  };
  Slider = (function() {
    function Slider(itemId, managed) {
      this.itemId = itemId;
      this.managed = managed != null ? managed : [];
      this.onSlide = __bind(this.onSlide, this);
      this.onChange = __bind(this.onChange, this);
      this.waiting = 0;
      this.stroke_re = new RegExp("stroke:[^;]+;", "g");
      this.slider = $('#' + this.itemId).slider({
        value: 0,
        orientation: "horizontal",
        min: 0,
        max: 255,
        length: 255,
        animate: true,
        slide: this.onSlide,
        change: this.onChange
      });
    }
    Slider.prototype.initialize = function() {
      this.onChange(null, {
        value: 0
      });
      return this.onSlide(null, {
        value: 0
      });
    };
    Slider.prototype.onChange = function(event, ui) {
      var i, rioolgemalen, that;
      that = this;
      rioolgemalen = [
        (function() {
          var _i, _len, _ref, _results;
          _ref = this.managed;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            i = _ref[_i];
            if (i.key.indexOf("pomprg") === 0) {
              _results.push({
                key: i.key
              });
            }
          }
          return _results;
        }).call(this)
      ];
      return $.post("/api/update/", {
        timestamp: ui.value,
        keys: rioolgemalen
      }, function(data) {
        return that.updateLabels(data);
      });
    };
    Slider.prototype.onSlide = function(event, ui) {
      var candidate, item, key, _i, _j, _len, _len2, _ref, _ref2;
      _ref = this.managed;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        key = item.key;
        _ref2 = item.value;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          candidate = _ref2[_j];
          if (candidate.timestamp > ui.value) {
            break;
          }
        }
        this.setStyleStroke(key, candidate.color);
      }
      return null;
    };
    Slider.prototype.updateLabels = function(data) {
      var key, value, _results;
      _results = [];
      for (key in data) {
        value = data[key];
        key = key.substr(4);
        _results.push($("#" + key)[0].childNodes[0].nodeValue = value);
      }
      return _results;
    };
    Slider.prototype.manageObject = function(item) {
      var that;
      that = this;
      that.waiting += 1;
      return $.get("/api/bootstrap/?item=" + item, function(data) {
        that.managed.push({
          key: item,
          value: data
        });
        that.waiting -= 1;
        if (that.waiting === 0) {
          return that.initialize();
        }
      });
    };
    Slider.prototype.setStyleStroke = function(itemId, value) {
      var item, styleOrig;
      item = $("#" + itemId);
      styleOrig = item.attr('style');
      return item.attr('style', styleOrig.replace(this.stroke_re, "stroke:" + value + ";"));
    };
    return Slider;
  })();
  $('document').ready(function() {
    var element, _i, _j, _len, _len2, _ref, _ref2, _results;
    window.slider = new Slider('mySliderDiv');
    _ref = $("path");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      element = _ref[_i];
      if (element.id.indexOf("leiding") === 0) {
        window.slider.manageObject(element.id);
      }
    }
    _ref2 = $("circle");
    _results = [];
    for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
      element = _ref2[_j];
      _results.push(element.id.indexOf("pomprg") === 0 ? window.slider.manageObject(element.id) : void 0);
    }
    return _results;
  });
}).call(this);
