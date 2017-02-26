Title: Plate plotting
Topics: keyboard diy cnc
Date: 2017-02-11

My new hobby is building a computer keyboard (see previous articles
for more about [building keyboards][] and [keyboard goals][]).
I have ordered in components such as key caps, key switches, and a lifetime supply of 1N4148 diodes, but there is one part I have to work out how to build for myself—the plate.


What is plate?
==============

In commercial keyboards, the switches may be PCB- or plate-mounted. The
former are held in place by being sodlered to the PCB; in the latter
they are clipped in to a metal mounting plate (or ‘frame’) as well as
attached to the PCB (see the [Cherry web site][] for diagrams).

A conventional mechanical keyboard is typically constructed with the
plate at a shallow angle in a plastic case that rises above the plate
so the top of the case is flush with the key caps and the switches are hidden from view.

<div class="image-full-width">
    <img src="plate0.svg" width="540" height="280" alt="(diagram)">
</div>

In this side view I am only showing two rows of keys; there should really be five rows.


My weird plate
==============

Since I will be hand-wiring it there will be no PCB, so the plate is
the main structure of the keyboard. It will also be the top surface of
the case—the keys will appear to be floating above the case.

<div class="image-full-width">
    <img src="plate1.svg" width="540" height="280" alt="(diagram)">
</div>

In this side view the plate (in orange) extends across the top of the
case and has holes cut in to it in to which the switches are clipped.
Because it is made of acrylic (or polycarbonate or wood—to be determined) it needs additional
thickness to make it stiff enough. My plan is to cut slightly
larger holes through the additional thickness so that the switches can
clip on to the ridge at the top of the hole. To achive this I plan to
use the [CNC milling machine][] at [Oxford Hackspace][].

For the sides of the case there are two options:

1. Use the [laser cutter][] to cut a rectangular ring and then stack this and the bottom layer, the whole sandwich held together with bolts through from top to bottom.
2. Alternatively the plate and case sides could be
made in one go by hollowing out a thicker slab of material (say 10&thinsp;mm to allow 5&thinsp;mm for the wiring).

The advantage of the single-piece solution is that it should be stronger.

My research on off-the-shelf over-the-internet plastic acquisition suggests two main candidates:

* acrylic is available in tinted colours, so I could have a translucent orange
  plate to show off my black-and-orange SKIDATA key caps,
  but available in at most 5&thinsp;mm thickness.
* polycarbonate is stronger and stiffer, and solid polycarbonate is
  available in 10&thinsp;mm and 12&thinsp;mm thickness, but it is
  only available in clear.

With the inside surfaces all determined by the milling process, there
is a risk that a fully transparent case would look terrible. Or it
might show off the internal wiring in an exceptionally cool way. It is
difficult to predict. My current leaning is towards using transparent
orange acrylic, on the grounds that it might look interesting and if it
looks lousy I can always paint it black!


Risks and uncertainties
====

The main risk here is whether the plate material will be strong enough
given it isn’t steel or aluminium (since Oxhack don’t have a way to cut
metal yet), and how tight the fit will be. I can try to mitigate this
by drilling a test plate with variously slighly bigger or smaller holes
to see how what fits best.

The main uncertainties are (a) exactly what software I will use to
generate the files to feed the CNC software (b) exactly what material
is best, both aesthetically and engineering-wise—acrylic,
polycarbonate, wood, etc.


  [building keyboards]: 01/13.html
  [keyboard goals]: 02/05.html
  [Cherry web site]: http://cherryamericas.com/product/mx-series/
  [Oxford Hackspace]: https://oxhack.org
  [CNC milling machine]: http://wiki.oxhack.org/wiki/Roland_MDX-40_CNC_Mill
  [laser cutter]: http://wiki.oxhack.org/wiki/Silvertail_A0_Laser_Cutter


