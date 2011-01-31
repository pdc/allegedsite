Title: GroovyStipple R7: Alternative Track Corners
Date: 2011-01-31
Topics: groovystipple minecraft
Image: ../2010/groovystipple-64x64.png

Mine-cart tracks in [Minecraft][] have two textures: straight track and
a 90° corner. You can run diagonal lines, and carts will happily travel
on them in a straight 45° line, but because it is rendered using corner
pieces, it looks like a wriggly line. This vexes people who do not think
that train tracks don&rsquo;t look right when they make abrupt turns. I have
created an alternative version of my GroovyStipple texture pack that
substitutes a 45° track piece for the corner.

<div class="video-full-width">
    <iframe title="YouTube video player" class="youtube-player" type="text/html" width="540" height="333" src="http://www.youtube.com/embed/jCy_Xzsxtog" frameborder="0" allowFullScreen></iframe>
</div>

This is possible partly because I have started a new project, [Minecraft Texture Maker][].
The roadmap comes  in three levels of sophistication:

- a library that manipulates textures and can assemble composite packs
  from existing source packs;

- a recipe language that specifies how to build a pack, allowing it to
  be updated automatically when its source packs are updated; and

- a web application that combines a texture pack gallery with an
  interface for building recipes.

So far I have made a start on the library and the recipe interpreter.
The interpreter works with an abstract syntax represented as Python
dictionaries, lists, numbers, and strings—an abstract syntax designed to
be easily represented in [JSON][]. The recipe for GroovyStipple with
alternative track corner currently looks like this:

    {
        "label": "GroovyStipple (alt track) R7",
        "desc": u"A high-visibility unrealistic look with 45° tracks",
        "mix": [
            {
                "pack": "groovy",
                "files": [
                    "gui/crafting.png",
                    "gui/background.png",
                    "gui/container.png",
                    "gui/crafting.png",
                    "gui/furnace.png",
                    "gui/gui.png",
                    "gui/inventory.png",
                    "item/boat.png",
                    "item/cart.png",
                    "item/sign.png",
                    "mob/cow.png",
                    "mob/creeper.png",
                    "mob/sheep.png",
                    "mob/sheep_fur.png",
                    "mob/zombie.png",
                    "news.txt",
                    "pack.png",
                    {
                        "file": "terrain.png",
                        "source": "terrain.png",
                        "map": {
                            "source_rect": {"x": 0, "y": 112, "width": 16, "height": 16},
                            "cell_rect": {"width": 16, "height": 16},
                            "names": ["track_corner"]
                        },
                        "replace": {
                            "source": "terrain.png",
                            "map": {
                                "source_rect": {"x": 64, "y": 160, "width": 16, "height": 16},
                                "cell_rect": {"width": 16, "height": 16},
                                "names": ["track_corner_alt"],
                            },
                            "cells": {"track_corner": "track_corner_alt"},
                        }
                    }
                ],
            },
        ]
    })

What is missing is a way to specify the source texture packs (the name
`"groovy"` in the above has to be linked to the source pack outside of
the recipe at present), and a command-line program for running the recipe.

About GroovyStipple
===================

GroovyStipple and its companion SmoothStipple are texture packs for
[Minecraft][]. They are compatible with Minecraft Beta 1.2. You can
download them here:

* [GroovyStipple][]
* [GroovyStipple Alt][] (45° track corners)
* [SmoothStipple][]
* [SmoothStipple Alt][] (45° track corners)

To install them, click on Mods and Textures in the Minecraft main menu,
use it to visit the textures directory and copy or move the ZIP files
there.

  [Minecraft]: http://minecraft.net/
  [groovystipple]: http://static.alleged.org.uk/pdc/2010/groovystipple.zip
  [groovystipple alt]: http://static.alleged.org.uk/pdc/2011/groovystipple_alt.zip
  [smoothstipple]: http://static.alleged.org.uk/pdc/2010/smoothstipple.zip
  [smoothstipple alt]: http://static.alleged.org.uk/pdc/2011/smoothstipple_alt.zip
  [Minecraft Texture Maker]: https://github.com/pdc/minecraft-texture-maker
  [JSON]: http://www.json.org/
