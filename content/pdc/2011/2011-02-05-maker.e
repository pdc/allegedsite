Title: Minecraft Texture Maker
Date: 2011-02-05
Topics: minecraft python
Image: ../2010/groovystipple-64x64.png

I have started working on a little utility program for assembling
[Minecraft][] texture packs. Its working title is
[Minecraft Texture Maker][]. With it I an do mundane tasks like assembling the files in a
directory in to the ZIP archive that gets published, and also create new
texture packs by remixing existing ones. I have a vague ambition to
elaborate it in to a web app for remixing packs, but it is useful
already.

Building Texture Packs
======================

Packs are created using *recipes* written in a fairly simple-minded
syntax: [JSON][]. For example, to build GroovyStipple, I use this
recipe:

    {
      "label": "GroovyStipple R7",
      "desc": "A high-visibility, unrealistic look",
      "mix": {
        "pack": {"file": "GroovyStipple"},
        "files": [
          "gui/*.png",
          "item/*.png",
          "mob/*.png",
          "news.txt"
          "pack.png",
          "terrain.png"]}}

This goes in a file `groovystipple.json`. The graphics
files—`terrain.png` and the rest—go in a directory `GroovyStipple`
(the *source pack*, referred to in the `pack` line). Then I can build the pack with the
command like this:

    maketexture texturepacks/groovystipple.json

The recipe for SmoothStipple is a little more complex, because it has
its own `terrain.png` and `pack.png`, but gets everything else from
GroovyStipple:

    {
      "label": "SmoothStipple R7",
      "desc": "A high-visibility, unrealistic look",
      "mix": [
        {
          "pack": {"file": "GroovyStipple"},
          "files": [
            "gui/*.png",
            "item/*.png",
            "mob/*.png",
            "news.txt"]},
        {
          "pack": {"file": "SmoothStipple"},
          "files": [
            "pack.png",
            "terrain.png"]}]}

The folders `GroovyStipple` and `SmoothStipple` contain the graphics
files but are not complete packs in themselves. The program takes care
of creating `pack.txt`, for example.

Remixing Texture Packs
======================

Many packs have alternative versions of some of the textures.
[Frenden][] has alternative cobble textures, not to mention two darker
shades of wood for people who do not like the look of the default planks
texture. Texture maker recipes can build a new `terrain.png` by
rearranging the existing one:

    {
      "label": "Frenden 6A (alt cobble)",
      "desc": "Uses alternative cobble and dispenser textures",
      "mix": {
        "pack": {
          "file": "Frenden6_1a.zip",
          "maps": {
            "terrain.png": [
              {
                "source_rect": {"width": 256, "height": 48},
                "cell_rect": {"width": 16, "height": 16},
                "names": [
                  "grass", "stone", "dirt", ...
                  "cobble", "bedrock", "sand", ...
                  "gold_ore", "iron_ore", "coal_ore", ... ]},
              {
                "source_rect": {"x": 64, "y": 160, "width": 256, "height": 32},
                "cell_rect": {"width": 16, "height": 16},
                "names": ["cobble1", "planks1", "planks2", "dispenser1"]}]}},
        "files": [
          "*.png",
          {
            "file": "terrain.png",
            "replace": {
              "cells": {
                "cobble": "cobble1",
                "dispenser": "dispenser1"}}},
          {
            "file": "mob/zombie.png",
            "source": "mob/zombieBlue.png"}]}}

(The elipses ‘`...`’ show where I have abbreviated the list of names.) In this recipe, the `maps`
section says how to find named textures in `terrain.png`, and the
`replace` section tells it to replace the usual `cobble` texture with
the one named `cobble1`, and so on.

The result ([Frenden6_1a_alt.zip][]) is a new texture pack
that can be copied in to Minecraft’s special folder, giving a choice of
looks:

<div class="image-full-width">
    <a href="frenden-1.png"><img src="frenden-1-220w.png" alt="(screenshot)" width="220" /></a>
    <a href="frenden-2.png"><img src="frenden-2-220w.png" alt="(screenshot)" width="220" /></a>
</div>

The standard pack is on the left; the alternates pack on the right. (Click to see larger.)

I use similar scripts to keep the [‘alt’ versions of GroovyStipple and SmoothStipple][1] up to date.

Status
======

As of 5 February 2011 I have the basics of recipes working and a simple
script that loads a recipe and creates the pack. I have not yet added
support for automatic installation (that is, I need to add a `setup.py`
file), so for now it is only useful to Python programmers. I plan to add
a basic `setup.py` real soon now to see whether other texture-pack
designers find it useful. There is a [wiki][] with the roadmap, such as
it is.

  [Minecraft]: http://minecraft.net/
  [JSON]: http://json.org/
  [Frenden]: http://www.minecraftforum.net/viewtopic.php?f=25&t=46707
  [Minecraft Texture Maker]: https://github.com/pdc/minecraft-texture-maker
  [wiki]: https://github.com/pdc/minecraft-texture-maker/wiki
  [Frenden6_1a_alt.zip]: http://static.alleged.org.uk/pdc/2011/Frenden6_1a_alt.zip
  [1]: 01/31.html