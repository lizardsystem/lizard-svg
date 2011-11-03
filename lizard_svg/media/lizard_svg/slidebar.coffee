###
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
###

getObjectClass = (obj) ->
    if (obj && obj.constructor && obj.constructor.toString)
       arr = obj.constructor.toString().match(
            /function\s*(\w+)/);

        if (arr && arr.length == 2)
            return arr[1]

    return undefined;


class Slider
  constructor: (@itemId) ->
    @waiting = 0
    @managed = []
    @stroke_re = new RegExp("stroke:[^;]+;", "g");
    @slider = $('#' + @itemId).slider
      value: 0
      orientation: "horizontal"
      min: 0
      max: 255
      length: 255
      animate: true
      slide: @onSlide
      change: @onChange

  onSlide: (event, ui) =>
    for item in @managed
        key = item.key
        for candidate in item.value
          if candidate.timestamp > ui.value
            break
        @setStyleStroke(key, candidate.color)
    null

  onChange: (event, ui) =>
    that = this
    rioolgemalen = [{key: i.key} for i in @managed when i.key.indexOf("pomprg") == 0]
    #$.get "/api/update/?keys=#{rioolgemalen}",
    #    (data) -> that.onChangeFinalize data
    $.post "/api/update/",
        timestamp: ui.value
        keys: rioolgemalen,
        (data) -> that.onChangeFinalize data

  onChangeFinalize: (data) ->
    for key, value of data
        key = key.substr(4)
        $("#" + key)[0].childNodes[0].nodeValue = value

  manageObject: (item) ->
    that = this
    that.waiting += 1
    $.get "/api/bootstrap/?item=#{item}",
      (data) ->
        that.managed.push
          key: item
          value: data
        that.waiting -= 1
        if that.waiting == 0
          that.manageObjectFinalize()

  manageObjectFinalize: ->
    @onChange(null, value: 0)
    @onSlide(null, value: 0)

  setStyleStroke: (itemId, value) ->
    item = $("#" + itemId)
    styleOrig = item.attr('style')
    item.attr('style', styleOrig.replace @stroke_re, "stroke:#{value};")


$('document').ready ->
  window.slider = new Slider('mySliderDiv')
  for element in $("path")
    if element.id.indexOf("leiding") == 0
      window.slider.manageObject(element.id)
  for element in $("circle")
    if element.id.indexOf("pomprg") == 0
      window.slider.manageObject(element.id)
