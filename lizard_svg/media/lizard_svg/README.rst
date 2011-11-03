Place your css/js files and your images here.

Components
==========

this directory contains javascript components, programmed in
coffeescript.  they attempt being generic.

Slider
======

description
-----------

a ``Slider`` object is associated to a jQuery slider control.  it
reacts on the two events ``onSlide`` and ``onChange`` of the jQuery
slider control.  a ``Slider`` object *manages* objects.  objects can
be managed in different ways:

* **attribute** (for example ``y="..."``)
* **style** (``fill="..."``, part of the ``style`` attribute)
* **content** (alter ``nodeValue`` of included ``textNode``)

during sliding managing is done using internal information.  

as result of a change, the Slider object will query the data source to
get the information that has to be reflected in the managed objects.

usage
-----

* create a new ``Slider`` informing the constructor about where to
  place the related jQuery ``slider``.
* inform the new object about the DOM elements to be managed.
* interact with the ``slider`` and let the ``Slider`` do its work.

methods
-------

constructor(@itemId)

  create a new slider associating it to an element.

manageObject(group, item)

  add an object to one of the groups of managed objects.

onSlide(event, ui)

  loop over the different types of managed objects and update them
  using already available information.  this influences the
  **attribute** and **style** groups.

onSlide(event, ui)

  ask the data source for updated information.  this influences the
  **content** group.

onChangeFinalize(data)

  this is a callback function, 
