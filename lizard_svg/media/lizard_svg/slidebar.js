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
  var Slider, getObjectClass, pad;
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
    function Slider(itemId, text) {
      this.itemId = itemId;
      this.text = text;
      this.onChange = __bind(this.onChange, this);
      this.onSlide = __bind(this.onSlide, this);
      this.waiting = 0;
      this.managed = [];
      this.re = {};
      this.slider = $('#' + this.itemId).slider({
        value: 0,
        orientation: "horizontal",
        step: 60,
        length: 660,
        slide: this.onSlide,
        change: this.onChange
      });
    }
    Slider.prototype.setMin = function(min) {
      return $('#' + this.itemId).slider("option", "min", min);
    };
    Slider.prototype.setMax = function(max) {
      return $('#' + this.itemId).slider("option", "max", max);
    };
    Slider.prototype.onSlide = function(event, ui) {
      var item, latest, _i, _len, _ref;
      $('#' + this.text).text((new Date(ui.value)).isoFormat());
      _ref = this.managed;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (item.group === "content") {
          continue;
        }
        latest = item.value.findLastObservationBefore(ui.value);
        this.setAttribute(item.key, item.group, latest.value);
      }
      return null;
    };
    Slider.prototype.setAttribute = function(itemId, attribute, value) {
      var item, parts, re, styleOrig;
      item = $('#' + itemId.replace(/(:|\.)/g, '\\$1'));
      if (attribute === "::color") {
        this.setAttribute(itemId, "style:stroke", value);
        this.setAttribute(itemId, "style:marker-end", value);
        return this.setAttribute(itemId, "style:marker-start", value);
      } else if (attribute.indexOf(":") === -1) {
        return item[0].setAttribute(attribute, value);
      } else {
        re = this.re[attribute];
        parts = attribute.split(":");
        styleOrig = item.attr(parts[0]);
        return item.attr(parts[0], styleOrig.replace(re, "$1" + value));
      }
    };
    Slider.prototype.onChange = function(event, ui) {
      var i, mutanda, that;
      that = this;
      mutanda = [
        (function() {
          var _i, _len, _ref, _results;
          _ref = this.managed;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            i = _ref[_i];
            if (i.group === "content") {
              _results.push(i.key);
            }
          }
          return _results;
        }).call(this)
      ].join(",");
      return $.get("/api/update/", {
        timestamp: (new Date(ui.value)).isoFormat(),
        keys: mutanda
      }, function(data) {
        return that.onChangeFinalize(data);
      });
    };
    Slider.prototype.onChangeFinalize = function(data) {
      var key, value, _results;
      _results = [];
      for (key in data) {
        value = data[key];
        _results.push($("#" + key.replace(/(:|\.)/g, '\\$1'))[0].childNodes[0].nodeValue = value);
      }
      return _results;
    };
    Slider.prototype.manageObject = function(group, item) {
      var parts, that;
      if (group === "::color") {
        this.re["style:stroke"] = new RegExp("(stroke:)[^;]+", "g");
        this.re["style:marker-end"] = new RegExp("(marker-end:url\\(#)[^-]+", "g");
        this.re["style:marker-start"] = new RegExp("(marker-start:url\\(#)[^-]+", "g");
      }
      if (group.indexOf(":") !== -1) {
        parts = group.split(":");
        this.re[group] = new RegExp("(" + parts[1] + ":)[^;]+", "g");
      }
      that = this;
      that.waiting += 1;
      $('#' + this.text).text("queued requests: " + that.waiting);
      return $.get("/api/bootstrap/?group=" + group + "&item=" + item, function(data) {
        that.managed.push({
          key: item,
          value: data,
          group: group
        });
        that.waiting -= 1;
        if (that.waiting === 0) {
          return that.manageObjectFinalize();
        } else {
          return $('#' + this.text).text("queued requests: " + that.waiting);
        }
      });
    };
    Slider.prototype.manageObjectFinalize = function() {
      this.onChange(null, {
        value: 0
      });
      return this.onSlide(null, {
        value: $('#' + this.itemId).slider("option", "min")
      });
    };
    return Slider;
  })();
  window.Slider = Slider;
  String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
  };
  Array.prototype.findLastObservationBefore = function(lookfor) {
    var left, middle, right;
    left = 0;
    right = this.length;
    while (right > left + 1) {
      middle = Math.floor((right + left) / 2);
      if (this[middle].timestamp <= lookfor) {
        left = middle;
      } else {
        right = middle;
      }
    }
    return this[middle];
  };
  pad = function(n) {
    if (n < 10) {
      return '0' + n;
    } else {
      return n;
    }
  };
  Date.prototype.isoFormat = function() {
    return this.getUTCFullYear() + "-" + pad(this.getUTCMonth() + 1) + "-" + pad(this.getUTCDate()) + "T" + pad(this.getUTCHours()) + ':' + pad(this.getUTCMinutes()) + ':' + pad(this.getUTCSeconds());
  };
}).call(this);
