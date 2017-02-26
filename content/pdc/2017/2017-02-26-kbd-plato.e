Title: Plato, a Python module for plotting plates
Date: 2017-02-26
Topics: keyboard svg dxf python

As part of my new hobby to build a computer keyboard, I have to draw
the instructions for the cutting of the plate the switches are held in (see [previous][] post for more on
what the plate is).
Rather than learn how to install and use a CAD system to do this, I
have written a Python module to do it for me.

This software does the same thing as online services like the [swillkb Plate &
Case Builder][] and [Keyboard CAD Assistant][]: it takes the serialized
data from the [Keyboard Layout Editor][] and writes DXF and SVG files
that might be converted in to instructions for a CNC mill or laser cutter.
The diagram looks something like this:

<div class="image-full-width">
    <img src="x1-20170226-plate.svg" style="width: 100%" alt="(diagram)">
</div>

Part of the motivation for rolling my own rather than exploiting the
Swill version was that I plan to use acrylic or wood rather than metal for the
plate: this means I need to create an ‘under-plate’ support layer. This has
almost the same design but is thicker (say 3&thinsp;mm rather than 1&middot;5&thinsp;mm) with a few cutouts that allow the switches
to clip on to the top layer. Something like this:

<div class="image-full-width">
    <img src="x1-20170226-under.svg" style="width: 100%" alt="(diagram)">
</div>

Ideally for strength the plate and under-plate support would be
machined out of one piece of acrylic (or wood) but if that proves
infeasible I can laser cut them separately and glue the layers
together.

The DXF version is hard to display if you don’t have CAD software,
which is where the SVG file is convenient—it can be loaded in to your
favourite web browser and you should be able to zoom and pan with your
browser’s ususal controls. I have also made it use lines whose
thickness corresponds to the width of the laser beam, so they should
give an idea of the level of detail that is or is not possible.

The package—which is not yet in any kind of finished form—is called
Plato and you can read the [code on GitHub][].

  [previous]: 02/11.html
  [Keyboard CAD Assistant]: http://www.keyboardcad.com/
  [Keyboard Layout Editor]: http://www.keyboard-layout-editor.com/
  [swillkb Plate & Case Builder]: http://builder.swillkb.com/
  [code on GitHub]: https://github.com/pdc/keyboard-plato
