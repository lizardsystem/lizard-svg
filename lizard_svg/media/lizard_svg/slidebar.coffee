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
  constructor: (@itemId, @text) ->
    @waiting = 0
    @managed = []
    @re = {}
    @slider = $('#' + @itemId).slider
      value: 0
      orientation: "horizontal"
      step: 60
      length: 660
      slide: @onSlide
      change: @onChange

  setMin: (min) ->
    $('#' + @itemId).slider("option", "min", min)

  setMax: (max) ->
    $('#' + @itemId).slider("option", "max", max)

  onSlide: (event, ui) =>
    $('#' + @text).text (new Date(ui.value)).isoFormat()
    for item in @managed
        if item.group == "content"
            continue

        latest = item.value.findLastObservationBefore(ui.value)
        @setAttribute(item.key, item.group, latest.value)
    null

  setAttribute: (itemId, attribute, value) ->
    item = $( '#' + itemId.replace(/(:|\.)/g,'\\$1') )
    if attribute == "::color"
        @setAttribute(itemId, "style:stroke", value)
        @setAttribute(itemId, "style:marker-end", value)
        @setAttribute(itemId, "style:marker-start", value)
    else if attribute.indexOf(":") == -1
        item[0].setAttribute(attribute, value)
    else
        re = @re[attribute]
        parts = attribute.split(":")
        styleOrig = item.attr(parts[0])
        item.attr(parts[0], styleOrig.replace(re, "$1#{value}"))

  onChange: (event, ui) =>
    that = this
    mutanda = [i.key for i in @managed when i.group == "content"].join(",")
    $.get "/api/update/",
        timestamp: (new Date(ui.value)).isoFormat()
        keys: mutanda,
        (data) -> that.onChangeFinalize data

  onChangeFinalize: (data) ->
    for key, value of data
        $("#" + key.replace(/(:|\.)/g,'\\$1'))[0].childNodes[0].nodeValue = value

  manageObject: (group, item) ->
    if group == "::color"
        @re["style:stroke"] = new RegExp("(stroke:)[^;]+", "g")
        @re["style:marker-end"] = new RegExp("(marker-end:url\\(#)[^-]+", "g")
        @re["style:marker-start"] = new RegExp("(marker-start:url\\(#)[^-]+", "g")
    if group.indexOf(":") != -1
        parts = group.split(":")
        @re[group] = new RegExp("(" + parts[1] + ":)[^;]+", "g")
    that = this
    that.waiting += 1
    $('#' + @text).text "queued requests: " + that.waiting
    $.get "/api/bootstrap/?group=#{group}&item=#{item}",
      (data) ->
        that.managed.push
          key: item
          value: data
          group: group
        that.waiting -= 1
        if that.waiting == 0
          that.manageObjectFinalize()
        else
          $('#' + @text).text "queued requests: " + that.waiting

  manageObjectFinalize: ->
    @onChange(null, value: 0)
    @onSlide(null, value: $('#' + @itemId).slider("option", "min"))

window.Slider = Slider

String.prototype.endsWith = (suffix) ->
    this.indexOf(suffix, this.length - suffix.length) isnt -1

Array.prototype.findLastObservationBefore = (lookfor) ->
        # assumes the array contains a time series
        # compare .timestamp field with lookfor
        # return last item not following lookfor
        left = 0
        right = this.length

        while right > left + 1
          middle = Math.floor (right + left) / 2
          if this[middle].timestamp <= lookfor
            left = middle
          else
            right = middle

        this[middle]

pad = (n) ->
  if n < 10 then '0' + n else n

Date.prototype.isoFormat = () ->
  @getUTCFullYear() + "-" + pad(@getUTCMonth() + 1) + "-" + pad(@getUTCDate()) + "T" + pad(@getUTCHours()) + ':' + pad(@getUTCMinutes()) + ':' + pad(@getUTCSeconds())
