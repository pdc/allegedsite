Title: Texturejam Vision
Date: 2011-06-25
Topics: texturejam minecraft
Image: dirt_jam.png

I am making some changes to the way the [Texturejam][] web app works to
improve the clarity of attribution in remixed texture packs. Here’s how
the new system works (or will work, when it is done), and why.

Background: Texture Packs and Attribution
=========================================

Texture packs are collections of image files. Images are created by
artists using tools like [Adobe Photoshop][2] or [Acorn from Flying Meat][1].
While the artists allow others to download their packs and use them to play Minecraft,
they generally want to be assured that (a)&nbsp;they credit for their work,
(b)&nbsp;other people do not pass of their work as their own.

It gets more complicated when someone wants to create a variation on someone else’s pack. This can be

- because they want to use a pack designed for Minecraft Beta 1.2 in Minecraft Beta 1.6,
- because they want to exploit alternative tiles the artist drew,
- because they want to tweak or recombine textures from multiple packs (‘best-of’ packs).

With conventional tools, the only way to do this is to open up the files
in an image editor. This is problematic for some punters—they don’t have
Photoshop, or don’t have the skillz—and creates a problem of
attribution: the resulting graphics files have no way to indicate who
created which texture.

You see the evidence of this problem in anguished threads in the Minecraft forums
(at the time I write this the server is down).

Texturepacker
=============

The [Texturepacker][] library is supposed to be a solution to this
problem by allowing the creation of remix packs by combining the
unmodified original pack (or packs) with a *recipe*. This mostly
addresses the attribution issue: the recipe writer can claim authorship
of the recipe, while still acknowledging ownership of the source packs.

The problem with this is the recipe format—while based on plain text—is
a little bit elaborate. What we need is a UI for creating recipes.

Texturejam, a UI for Texturepacker
==================================

This is where the [Texturejam][] web site comes in. It does not (yet)
have a way of creating arbitrary recipes; instead I have been working on
the two most
useful special cases:

- upgrading old packs to work with new Minecraft releases, and
- using alternative textures in packs that have them.

The first of these works by using a set of recipes hand-crafted by me to
work with a special ‘component’ texture pack called Patches, which
contains just those tiles that have been added for the new versions. The
second works by using a *map* (which tells it what alternative tiles are
available) to generate a form automatically. You click on the form to
choose which alts to switch in and which to leave as their default.
Texturejam then creates a recipe for you based on your choices.

Texturejam, Ownership, and Attribution
======================================

The first version of these two features required that things created by
users of the site (the recipes and remix packs) all be tagged with who
created them—this way the owner of the remix can edit the description if
it no longer makes sense. This means you have to log in. This is problematic for two reasons.

- First, it is a barrier to entry. I tried to make logging in as
  painless as possible by exploiting Twitter’s system instead of
  creating my own. But it is still a problem if you have to log in
  before you have even tried to make something.

- Second, because the person who created the remix is arbitrarily given
  ownership of the remix it obscures the correct attribution of the
  remix (which is still mostly the work of the original artist). It also
  creates needless duplication if more than one person asks for the same
  remix.

For these reasons I am working towards not requiring the generated
recipes and remixes to be stored in the database at all—removing the
need to give anyone ownership over them.

For example, the form for creating alt packs has been simplified: the
label and description fields have been dropped, and instead they will be
generated automatically. Internally there has been changes so that
instead of creating a recipe, the information needed to recreate the
recipe is encoded in the URL. Here’s an example:

    http://texturejam.org.uk/altpacks/8/releases/36/eldpack-v35-alt-a__a.zip

The 8 identifies the map, the 36 the source pack (Eldpack), and the
`a__a` part says to use the alt tile for the first and fourth items in
the list of alts, and to leave the second and third as defaults.

For the upgrade recipes, I have started moving towards a similar system.
On the front page, you now see a simpler list of upgraded packs. You can
see more info on a new [Sources page][3]. The idea is, instead of
creating remixes explicitly, to infer which upgrade recipe to use based
on the Minecraft release the source pack supports. This will remove the
need to create the remixes as database objects in their own right.

Future Work
===========

I need to follow through on the changes made for upgrade packs.

Next, I need to work out how to keep the list of sources up-to-date.
There are several lists of texture packs out there on the web, and I
need to gather information from all of them and merge it in to my
database.

In the distant future I plan to come up with a UI for mixing multiple
packs together to support the desire for ‘best of’ packs. It will also
allow people to make their own upgrade recipes that use nicer substitute
textures than the ones I use. So far it is not even worked out on paper, so don’t hold your breath. :-)



  [1]: http://flyingmeat.com/acorn/
  [2]: http://flyingmeat.com/acorn/
  [3]: http://texturejam.org.uk/sources/
  [Texturejam]: http://texturejam.org.uk/
  [Texturepacker]: http://pdc.github.com/texturepacker/