Title: Texturejam and Minecraft Beta 1.5 (so far)
Date: 2011-04-21
Topics: minecraft texturejam
Image: ../icon-64x64.png

I have updated [Texturejam][] to support [Minecraft][] Beta 1.5.

Basically this entails adding texture tiles for new blocks and items to
the special ‘component pack’ I use when extending existing texture packs
to support the new Beta.  There are eight new tiles.

- Powered rail
- Powered rail (lit)
- Detecture rail
- Spruce sapling
- Birch sapling
- Side grass
- Redstone A
- Redstone B

The first six of these were [tweeted by Jeb][1] ahead of the release of
1.5, so I was able to have a go at drawing the first five ahead of time.
I did not know what a power rail would look like, so I did my best to
draw a cog in the middle of a rail piece and added some redstone dust
decorations.

<div class="image-left">
    <img src="beta-15-patch.png" width="256" alt="(texture tiles)" />
</div>

I similarly guessed a detector rial would look like a rail combined with pressure plate.

I was not sure what the side-grass tile would look be. I thought it
might be a greyscale grass block with transparent parts, but it was not
until the release of 1.5 that I was sure. Once I had that I was able to
create a Texturepacker map for the new components and update the upgrade
recipes. All the ‘upgrade packs’ now work with Beta 1.5. Great!

Except when I tried trying them out I discovered that redstone had gone
strange—replaced with purple squares, for example. I checked the default
texture and discovered two empty tiles have been added in positions
adjacent to the new-style redstone tile. SO I was able to fix my recipe
by adding the two blank tiles to my component pack, updating the maps,
etc., and now the upgrades work!

At least for ‘terrain’ textures (new blocks etc.). There is still the
`items.png` to consider—and there is still a bug which causes the
descriptions of the packs to be replaced with the mysterious word
‘unjumbled’. Stay tuned …




  [Texturejam]: http://texturejam.org.uk/
  [Minecraft]: http://minecraft.net/
  [Pixelade]: http://texturejam.org.uk/remixes/32/
  [1]: https://twitter.com/jeb_/status/58821868924309504