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
    @re = {}
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
        if item.group == "content"
            continue
        key = item.key
        for candidate in item.value
          if candidate.timestamp > ui.value
            break
        @setAttribute(key, item.group, candidate.value)
    null

  setAttribute: (itemId, attribute, value) ->
    item = $( '#' + itemId.replace(/(:|\.)/g,'\\$1') )
    if attribute == "color"
        @setAttribute(itemId, "style:stroke", value)
        @setAttribute(itemId, "style:marker-end", value)
    if attribute.indexOf(":") == -1
        item[0].setAttribute(attribute, value)
    else
        re = @re[attribute]
        parts = attribute.split(":")
        styleOrig = item.attr(parts[0])
        item.attr(parts[0], styleOrig.replace(re, "$1#{value}"))

  onChange: (event, ui) =>
    that = this
    mutanda = [{key: i.key} for i in @managed when i.group == "content"]
    $.post "/api/update/",
        timestamp: ui.value
        keys: mutanda,
        (data) -> that.onChangeFinalize data

  onChangeFinalize: (data) ->
    for key, value of data
        $("#" + key.replace(/(:|\.)/g,'\\$1'))[0].childNodes[0].nodeValue = value

  manageObject: (group, item) ->
    if group == "color"
        @re["style:stroke"] = new RegExp("(stroke:)[^;]+", "g")
        @re["style:marker-end"] = new RegExp("(marker-end:url\\(#)[^-]+", "g")
    if group.indexOf(":") != -1
        parts = group.split(":")
        @re[group] = new RegExp("(" + parts[1] + ":)[^;]+", "g")
    that = this
    that.waiting += 1
    $.get "/api/bootstrap/?group=#{group}&item=#{item}",
      (data) ->
        that.managed.push
          key: item
          value: data
          group: group
        that.waiting -= 1
        if that.waiting == 0
          that.manageObjectFinalize()

  manageObjectFinalize: ->
    @onChange(null, value: 0)
    @onSlide(null, value: 0)

window.Slider = Slider

String.prototype.endsWith = (suffix) ->
    this.indexOf(suffix, this.length - suffix.length) isnt -1
