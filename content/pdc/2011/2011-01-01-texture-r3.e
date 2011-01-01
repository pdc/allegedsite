Title: GroovyStipple R3: Signs and Portents
Date: 2011-01-01
Topics: groovystipple minecraft
Image: ../icon-64x64.png

Spurred by a [comment on Reddit][1] I thought I would have a go at
adding items to my [Minecraft][] texture packs. The trick here is that the
way you do this is by taking an existing texture pack and unpacking it to
find out which files you need to modify and to try to guess the layout
of the image.


## Sign and Boat

The sign and boat have been changed to match the plank texture used
elsewhere in the texture pack.

<div class="image-full-width">
    <a href="groovystipple-10.png"><img src="groovystipple-10-220w.png" alt="(screenshot)" width="220" /></a>
    <a href="groovystipple-11.png"><img src="groovystipple-11-220w.png" alt="(screenshot)" width="220" /></a>
</div>

Here’s how I did them.

I unpacked [Frenden’s graphics pack][2] and discovered that there is a
file `items/sign.png`, which seems a likely candidate for the texture
for signs. I made a copy of the file in [Acorn][] and, in order to check
I had guess correctly which way the layout worked created a
multicoloured version which makes the mapping from flat image to 3D item
explicit:

<div class="image-full-width">
    <a href="groovystipple-sign-1.png"><img src="groovystipple-sign-1.png" alt="(sign graphics)" width="220" /></a>
    <a href="groovystipple-9.png"><img src="groovystipple-9-220w.png" alt="(sign screenshot)" width="220" /></a>
</div>

(Click on the first image to see it smaller.) Once I had that pat I draw
my own woody textures on their own layers.

<div class="image-full-width">
    <a href="groovystipple-sign-2.png"><img src="groovystipple-sign-2.png" alt="(sign graphics)" width="220" /></a>
    <a href="groovystipple-10.png"><img src="groovystipple-10-220w.png" alt="(sign screenshot)" width="220" /></a>
</div>

I am guessing that this
will be the pattern for more complicated textures: a rectangular block
is defined by the top, bottom, left, front, right and back sides in that
order.

I used the same approach with the boat texture. This one is a little
more complicated because it is not obvious at first how the boat’s shape
will be decomposed in to blocks.

<div class="image-full-width">
    <a href="groovystipple-boat-1.png"><img src="groovystipple-boat-1.png" alt="(boat graphics)" width="220" /></a>
    <a href="groovystipple-boat-3d.png"><img src="groovystipple-boat-3d-220w.png" alt="(boat diagram)" width="220" /></a>
</div>

(Once again I have blown the image up to make it visible to the human
eye. Click on it to see in its correct size.) The top part of the
texture defines a slab that is itself used four times to make the top
half of the boat. The second slab is used for the bottom of the boat.


## Better Nether

The other main difference is that I have redrawn the Nether designs.
This was partly because the red cobble texture was essentially the same
as the normal cobble, which was inconsistent with the idea that
different materials have different patterns.

<div class="image-full-width">
    <a href="groovystipple-7.png"><img src="groovystipple-7-220w.png" alt="(screenshot)" width="220" /></a>
    <a href="groovystipple-8.png"><img src="groovystipple-8-220w.png" alt="(screenshot)" width="220" /></a>
</div>

I also finally got around to visiting the Nether enough to see the
textures in action. (But I kept getting killed so I never managed to get
any of the lightstone back to my base.)


## Getting GroovyStipple

You can get the ZIP files here:

* [GroovyStipple][]
* [SmoothStipple][]

To install them, click on Mods and Textures in the Minecraft main menu,
use it to visit the textures directory and copy or move the ZIP files
there.


---

© 2011 Damian Cugley

  [1]: http://www.reddit.com/r/Minecraft/comments/eof2z/groovystipple_a_texture_pack_for_minecraft/
  [2]: http://www.minecraftforum.net/viewtopic.php?f=25&t=46707
  [Acorn]: http://flyingmeat.com/acorn/
  [Minecraft]: http://minecraft.net/
  [groovystipple]: http://static.alleged.org.uk/pdc/2010/groovystipple.zip
  [smoothstipple]: http://static.alleged.org.uk/pdc/2010/smoothstipple.zip