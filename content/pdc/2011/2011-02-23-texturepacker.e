Title: Texturepacker and Minecraft Beta 1.3
Date: 2011-02-23
Topics: minecraft texturepacker
Image: ../icon-64x64.png

Minecraft Beta 1.3 was released yesterday and it includes some new
items, which require support in your custom texture pack if you have
one. I was quite pleased that I was able to concoct a usable version of
my packs using my texture-pack-remixing work-in-progress, now named
[Texturepacker][1].

I started by creating an *atlas* for Beta 1.3. It looks like this:

    - file: beta1_2.tpmaps
    - terrain.png:
        - terrain.png
        - source_rect: {x: 48, y: 128, width: 96, height: 48}
          cell_rect: {width: 16, height: 16}
          names:
            - repeater
            - leaves1
            - leaves1_unfancy
            - bed_top_foot
            - bed_top_head
            - "88"
            - repeater_lit
            - "94"
            - bed_foot
            - bed_side_foot
            - bed_side_head
            - bed_head
            - "A3"
            - redstone_mask
            - redstone_line_mask
            - "A6"
            - "A7"
            - "A8"

It works by referencing the existing atlas for Beta 1.2 ([beta1_2.tpmaps][2]), and adds an
entry for `terrain.png` that adds extra entries for the new tiles.
(Except for the mysterious purple-black-and-blue tile next to the
obsidian tile, because I do not yet know what it is.)

Now I can define a version of GroovyStipple like this:

    label: GroovyStipple R8
    desc: A high-visibility, unrealistic look.
    mix:
      - pack:
          file: GroovyStipple
          maps:
            file: maps/stipple.tpmaps
        files:
          - "*.png"
          - file: terrain.png
            replace:
              pack:
                href: minecraft:bin/minecraft.jar
                maps:
                  file: maps/beta-1.3.tpmaps
              cells:
                - repeater
                - repeater_lit
                - redstone_mask
                - redstone_line_mask
                - bed_top_foot
                - bed_top_head
                - bed_foot
                - bed_head
                - bed_side_foot
                - bed_side_head

This is the recipe for mixing the new cells from the default texture pack
(which is embedded in the file `minecraft.jar` in Minecraft’s folder).
The only actually new part of the recipe is the `replace` spec.

Don‘t worry about the details of how recipes are written—apart from
anything else, I may change the syntax as I work out the details, and in
any case I plan to have most recipe-writing done via some nice web app.
What is interesting is that the above recipe could be applied to
existing Beta-1.2 texture packs to create ersatz packs that allow you to
carry on playing while you wait for the artist to draw the new graphics.

About Texturepacker
===================

[Texturepacker][1] is a Python module and program for building texture packs for Minecraft.


About GroovyStipple
===================

GroovyStipple and its companion SmoothStipple are texture packs for
[Minecraft][]. They are compatible with Minecraft Beta 1.3. You can
download them here:

* [GroovyStipple][]
* [GroovyStipple Alt][] (45° track corners)
* [SmoothStipple][]
* [SmoothStipple Alt][] (45° track corners)

To install them, click on Mods and Textures in the Minecraft main menu,
use it to visit the texturepacks folder and copy or move the ZIP files
there.

  [1]: http://pdc.github.com/texturepacker/
  [2]: https://github.com/pdc/texturepacker/blob/master/examples/maps/beta1_2.tpmaps
  [groovystipple]: http://static.alleged.org.uk/pdc/2010/groovystipple.zip
  [groovystipple alt]: http://static.alleged.org.uk/pdc/2011/groovystipple_alt.zip
  [smoothstipple]: http://static.alleged.org.uk/pdc/2010/smoothstipple.zip
  [smoothstipple alt]: http://static.alleged.org.uk/pdc/2011/smoothstipple_alt.zip
  [minecraft]: http://minecraft.net/