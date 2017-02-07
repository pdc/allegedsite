Title: Keyboard Goals
Topics: keyboard electronics diy
Date: 2017-02-05

My new hobby is building a computer keyboard (see [previous article][]
for more about building keyboards in general).

The pay-off for building your own is you get to make something not
normally available off the shelf. What do I hope to make my new
keyboard like?


Aesthetics
========

I generally prefer key caps with
spherical tops (as opposed to the more conventional cylindrical top
surface) and centred legends (rather than letters being printed in the
top left corner of the cap).

<div class="image-full-width">
    <a href="https://deskthority.net/workshop-f7/beamspring-usb-controller-t6044.html" title="Beamspring USB Controller on Deskthority forum"><img src="https://webwit.nl/input/ibm_beam_spring/rojon/1.jpg" alt="(photo)" width="540"></a>
</div>

I am more interested in colours that I can imagine fitting in calmly in
to the a home office or sitting room, rather than looking like a prop
from a science-fiction video game. But spherical caps are really only
available as group buys, so I am choosing amongst the options available
rather than specifying a custom colour scheme of my own.

To that end I have jumped on group buys for [Q-Series SKIDATA][] and
[SA Dasher][]. Both of these colour-ways are inspired by
keyboards of data terminals I have never heard of before, but that is
neither here nor there. I don’t plan on styling my keyboard look like a
[SKIDATA terminal][]; the orange-on-black key caps should look fine
paired with a case in some not-glossy black material (wood or acrylic
is most likely)

The usual way to make a case by hand results in a rectangular slab. It
would be possible to contrive a wedge-shaped case by making the sides
separately, and conventionally keyboards have an upwards slope.
Nevertheless for better ergonomics I plan to make a flat slab, and to
make the slab as thin as possible, squeezing the necessary circuitry in
to a minimum amount of space. If I want to add a slope later with
little feet they will be easy to retrofit.


Layout
====

I prefer smaller keyboards, with the minimum number of keys needed to
type the full ASCII repertoire without weird contortions (I don’t yet
feel able to commit to retraining myself to use 40% layouts). The Mac
UI allows me to do without the satellite clusters of numeric numpads
and navigation keys. Omitting these—with the exception that I do want
to have dedicated arrow keys—allows for a more compact design and
reduces the amount you have to react to use the mouse.  (For work I
have a TKL because the Eclipse IDE needs more keys.)

I have opinions about keyboard layouts.

<div class="image-left">
    <img src="iso-uk-129x177.png" alt="" width="129" height="177">
</div>

I prefer the ANSI style of
horizontal Return key as opposed to the vertical ISO style. I dislike the way the UK layout on PC keyboards has `@` swapped with `"` and a odd combination of `#~`.

<div class="image-right">
    <img src="backspace-150-140w.png" alt="" width="140" height="140">
</div>

I don’t
like it when an ordinary key (such as the `\ |` key)
is stretched to make the layout rectangular.

Splitting the left shift
key to squeeze in a key to the left of `Z` irks me, especially when it is
paired with a gigantic right shit key that I never use. The key to the left
of the `1 !` key should be Escape, and definitely not some random symbols
needed by no-one (`§ ±` on the Mac, `¬` on PCs). I prefer the bottom row
(with the space bar) to *not* be the full width, so the array of keys
is not just a rectangular block. I rather like the look of old-timey
keyboards with the modifier keys sized according to importance without
being stretched in odd ways to make the overall shape a tidy rectangle.

I have been fiddling with a [Keyboard Layout][] for the first build,
which I am going to call X1 until I think of a better name. This is
what I have come up with so far:

<div class="image-full-width">
    <img src="kbd-x1-1-540w.png" width="540" height="189" alt="(diagram)">
</div>

I have two sets of caps on order so it seems like a good idea to make
two different keyboards; for the SKIDATA set I am planning on a 60%
layout with an ISO return key. It started out weirder, but after a lot
of iterations this has ended up increasingly similar to Apple UK
layout. The main remaining oddity is the split spacebar bodged out of
the 2¼-unit-wide Enter key and 2¾-unit right shift key. The left half
of the spacebar might become a super-large ⌘ key on the Mac.

The biggest compromise is fitting in the arrow keys: I have ended up
with an L-shaped rather than T-shaped arrow cluster. We will see how
badly this annoys me in the fullness of time.


Other features
==============

I don’t feel any need for backlit keys, let alone the elaborate
individually addressable RGB LEDS in each key. (Obviously if I suffer a
moment of weakness and order a set of [LightCycle Key caps][] it will
be necessary to include a translucent blue slice in the case design and
some internal lighting to give it a glow. But that is a special case.)

One thing that an Apple wired keyboard has that might be nice to
replicate, if it is easy, is a USB hub in the keyboard. This
allows your mouse to be plugged in to the keyboard and only a single
cable needs to snake back to the computer proper. This is most useful
with computers with a CPU module that sits under your desk, or course,
but with Apple getting more parsimonious with ports on newer laptops it
might be useful for them as well.


Next
====

The biggest bit of planning remaining is how to cut, build, fabricate or otherwise concoct the top plate.





  [previous article]: 01/13.html
  [Q-Series SKIDATA]: http://www.mechsupply.co.uk/product/q-series-skidata-double-shot-keyset
  [SA Dasher]: https://deskthority.net/group-buys-f50/sa-dasher-sa-dancer-keycap-sets-t11572.html
  [SKIDATA terminal]: https://deskthority.net/workshop-f7/skidata-60-t13834.html#p344069
  [LightCycle Key caps]: https://thevankeyboards.com/products/lightcycle-keycap-set
  [Keyboard Layout]: http://www.keyboard-layout-editor.com/##@_backcolor=%23CC6633&name=60%25%20with%20ISO%20return%20and%20split%20spacebar&author=Damian%20Cugley&notes=My%20attempt%20to%20make%20a%2060%25%20with%20arrows%20using%20keycaps%20from%20SKIDATA%20group-buy.%0A%0AThe%20split%20spacebar%20is%20labelled%20oddly%20because%20it%20is%20formed%20from%20the%202.25u%20ENTER%20and%202.75%20SHIFT%20keys,%20which%20as%20it%20happens%20are%20the%20two%20keys%20that%20have%20QS%20profile%20rather%20than%20Q%20profile.%20&radii=10%3B&@_c=%23222222&t=%23e86700&p=DSA&a:7%3B&=ESC&_a:5%3B&=!%0A1&=%2F@%0A2&=%23%0A3&=$%0A4&=%25%0A5&=%5E%0A6&=%2F&%0A7&=*%0A8&=(%0A9&=)%0A0&=%2F_%0A-&=+%0A%2F=&_a:7&w:2%3B&=←%3B&@_w:1.5%3B&=TAB&=Q&=W&=E&=R&=T&=Y&=U&=I&=O&=P&_a:5%3B&=%7B%0A%5B&=%7D%0A%5D&_x:0.25&a:7&w:1.25&h:2&w2:1.5&h2:1&x2:-0.25%3B&=%3B&@_w:1.75%3B&=CTRL&=A&=S&=D&=F&=G&=H&=J&=K&=L&_a:5%3B&=%2F:%0A%2F%3B&=%22%0A'&=%7C%0A%5C%3B&@_a:7&w:1.25%3B&=SHIFT&_a:5%3B&=~%0A%60&_a:7%3B&=Z&=X&=C&=V&=B&=N&=M&_a:5%3B&=%3C%0A,&=%3E%0A.&=%3F%0A%2F%2F&_a:7&w:1.75%3B&=SHIFT&=↑%3B&@_x:1.75&w:1.25%3B&=ALT&_w:1.25%3B&=&_w:2.25%3B&=ENTER&_w:2.75%3B&=SHIFT&_w:1.25%3B&=FUNC&=HOLD&_x:0.25%3B&=←&=→&_x:0.25%3B&=↓

