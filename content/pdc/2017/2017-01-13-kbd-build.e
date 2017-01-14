Title: Thinking about Building a Keyboard
Date: 2017-01-13
Topics: keyboard electronics diy

Wouldn’t it be fun to build a computer keyboard from scratch? Well,
maybe so. Here are some links to resources that might be useful to
someone considering such a folly.

To be clear, this would not be a cost-saving measure; it is only worth
doing if your goal is the project, or you put a lot of value on being
able to design your own physical layout.

The basic requirements are

* a *plate* in to which the switches are clipped or glued,
* the microcontroller with appropriate software,
* the electronic circuity that allows the microprocessor to detect which keys are pressed, and,
* a case to hide its nakedness from the world.


Plate
=====

The plate has holes in to which the key switches are clipped.

<div class="image-right">
    <a href="https://geekhack.org/index.php?topic=82916.0@">
        <img src="http://i.imgur.com/ITDvQBt.png" width="300" alt="HHKB (Alps mounts) on GeekHack">
    </a>
</div>

It is made from a stiff and strong enough material to hold the key switches in place.
Steel, aluminium, and acrylic are common DIY materials.
See this [discussion of plate materials][].

The usual approach for small-batch and one-off production is generally laser cutting
(or similar techniques like cutting with high-pressure
water-jets and CNC routers). There are proptyping services online to which you can
email CAD files and receive your plate in the post. There may also be local
services (e.g., in Oxford there is [Oxford Hackspace][]).

If drawing a design from scratch seems too much like hard work,
there is shortcut available: design a layout in the
[Keyboard Layout Editor][] and then paste the data file in to the
[Swillkb Plate & Case Builder][]. (For Alps-format switches some finessing will be required.)

For various layouts there are open-hardware plans online already, for
example the [GH60 design][] (60% layouts with MX-format switches) and
[60% Alps plate designs][]. Some of these are available ready-made from
various suppliers.


Microcontroller
===============

A common solution is a USB-based microcontroller called a [Teensy][] running the [TMK firmware][].


Matrix
======

<div class="image-right">
  <a href="http://blog.komar.be/how-to-make-a-keyboard-the-matrix/" title="The matrix">
    <img src="http://blog.komar.be/wp-content/uploads/2013/09/f.png" width="300" alt="(diagram)">
  </a>
</div>

The switches need to be wired together in a way that lets the
microcontroller work out which ones are pressed. Using a [matrix][]
means you need only _N_ + _M_ pins on the microcontroller to test
_N_×_M_ key switches.
The circuit can be hand-wired (see [BrownFox step by step][]) or a PCB.

It is possible to
[create a PCB by hand][], but it will more conventionally be bought from a
prototyping service (as with the plate, you will need to supply a PCB
design file that you create yourself or snaffle from one of the
keyboard forums). Some conventional layouts have open-hardware designs
and can be bought online, sometimes partially soldered.


Case
====

A straightforward custom case can be made as a sandwich of a base,
one or more side pieces, and the top plate. The
[Swillkb Plate & Case Builder][] can generate plans for cutting these pieces out of wood,
acrylic, or metal.

There are a variety of cases designed to match the one in the popular
60%-sized [Poker keyboard][] series. This means that it may make sense
to design your 60% keyboard to also fit with this case format, thus
allowing you to buy fairly fancy-pants anodized aluminium cases.


Decision time
============

Here are some early decisions to make when planning such a project.

Kit or not?
-----------

There are commercially available kits based on designs emerging from
keyboard hobby forums. Here are some examples:

* [GH60][]: 60% reference design with kits available from several vendors
* [Infinity 60%][]: Input Club’s take on a 60% keyboard
* [Clueboard][]: 60% + arrow keys
* [WhiteFox][]: 65% [designed by Matt3o][]
* [Infinity ErgoDox][]: Input Club’s take on an ergonomic split keyboard
* [Minivan][]: 40% layout with fancy cases available

Some of these are only on sale periodically as group buys, but they
also have CAD files for people who want to create variants or just
build from scratch. There are also freely available designs for other
layouts.


Type of switch mount
--------------------

Apart from determining which types of switch you can choose between,
this will determine details of how the plate and PCB (if there is one) will be designed.

Cherry MX has the most off-the-shelf support in terms of switches and
custom keycaps.

Alps-style switches (whether salvaged original Alps or Matias’s
compatible switches) are preferred by people who like Alps-style
switches, but you are buying in to a lifetime of searching for
second-hand caps and other parts.

Other switch formats—like Cherry ML and the various unique formats used
by buckling springs—also exist but will be even more challenging to
source parts for.


Physical layout
---------------

There are plenty of standard layouts available off-the-shelf, and you
may well want to conform to one of these because it is the layout you
are used to. On the other hand, one driver for building your own is to
use a layout that is *not* commercially available, or an experimental
ergonomic layout.

As discussed above, there may be advantages to contriving to use a size
that fits an off-the-shelf case like the Poker or Minivan.

The other main limitation on physical layout is availability of
suitable key caps.

<div class="image-right">
  <a href="https://deskthority.net/workshop-f7/refining-a-compact-layout-t5266.html" title="From Refining a compact layout by Matt3o">
    <img src="http://i.imgur.com/sibEIvs.png" alt="(diagram)" width="300">
  </a>
</div>

For example, Matt3o’s [Steely][] neatly fits a 65%
layout in a 60% case, but requires a 1-unit Tab and 1.75-unit Return
key, which are not included in standard key-cap sets. Group buys for
custom key caps often include special outlier sets of oddly-sized
modifier keys for the benefit of people with less-standard layouts. So
you might want to aim for a layout that is non-standard but not *too*
non-standard.


Status
======

At the time of writing about the only positive step I have taken apart
from fiddling with the [Keyboard Layout Editor][] and reading keyboard
forums is that I have a set of key caps on order and have acquired some
sample switches to fiddle with while I daydream of custom keyboard layouts.



  [BrownFox step by step]: https://deskthority.net/workshop-f7/brownfox-step-by-step-t6050.html
  [Minivan]: https://thevankeyboards.com
  [designed by Matt3o]: http://matt3o.com/whitefox-the-making-of/
  [WhiteFox]: https://input.club/whitefox/
  [Infinity 60%]: https://input.club/devices/infinity-keyboard/
  [Infinity ErgoDox]: https://input.club/devices/infinity-ergodox/
  [Key64]: https://www.key64.org
  [Brownfox step by step]: https://deskthority.net/workshop-f7/brownfox-step-by-step-t6050.html
  [Steely]: https://deskthority.net/workshop-f7/custom-65-finally-finished-t5663.html
  [Poker keyboard]: https://mechanicalkeyboards.com/shop/index.php?l=product_list&c=159
  [create a PCB by hand]: https://geekhack.org/index.php?topic=51427.0
  [GH60 design]: https://geekhack.org/index.php?topic=34959.0
  [60% Alps PCB design]: https://geekhack.org/index.php?topic=69740.0
  [60% Alps plate designs]: https://geekhack.org/index.php?topic=82916.0
  [Clueboard]: https://clueboard.co/parts/
  [Swillkb Plate & Case Builder]: http://builder.swillkb.com
  [Keyboard Layout Editor]: http://www.keyboard-layout-editor.com
  [Oxford Hackspace]: https://oxhack.org
  [discussion of plate materials]: https://deskthority.net/workshop-f7/plate-materials-t12755.html
  [Matt3o recommends aluminium over steel]: https://deskthority.net/group-buys-f50/laser-cut-prototyping-mini-gb-t6102.html
  [Howto]: http://blog.komar.be/projects/how-to-make-a-keyboard/
  [GH60]: http://blog.komar.be/projects/gh60-programmable-keyboard/
  [builder]: http://builder.swillkb.com
  [matrix]: http://blog.komar.be/how-to-make-a-keyboard-the-matrix/
  [DIY PCB]: https://deskthority.net/workshop-f7/hhfox-aka-diy-pcb-t6905.html
  [cable]: https://clarkkable.com
  [TMK firmware]: https://geekhack.org/index.php?topic=41989.0
  [Teensy]: https://www.pjrc.com/teensy/index.html
