Topics: texturejam
Title: Attribution and Identification
Date: 2011-09-27

I want to make it so artists can say whether they want to allow their texture
packs to be remixed and specifically whether Texturejam is allowed to
allow visitors to download remixed packs. To do this I need to be able
to identify the pack in question. Even if we assume honest dealing from
all the people involved, this is a tricky problem.

# Identification

The first problem is identification: texture packs do not have unique
identifiers. One of the most definitive lists of packs is probably the
[listings post][1] on Minecraft forums. Packs have names and a URL
labelled ‘Download Texture Pack’ which is actually a post elsewhere on
the forum. Packs are generally identified by the forum thread where they
were introduced—new releases are announced by editing the top post of
the thread. Because the forum includes the post title in the URL, the
URL generally changes with every release.

This leaves names, and problem there is that names can mutate during the
lifetime of the pack as well—there is a convention of sometimes naming the pack
variously ‘Warpspasm’s Pony Pack’, ‘ponypack by W@rpsp@sm’ or just ‘PonyPack’,
which is OK so long as no-one else thinks to name their pack Pony Pack. We can
up to a point have the computer guess whether two names name the same thing, but
it is likely to be hit-or-miss.

Identification matters because if Texturejam can’t tell whether pack X and pack Y are the
same pack, it can’t know whether permissions given to X apply to Y.

# Attribution

I don’t want Tetxurejam to pass off one person’s work as someone else’s, which
is why the source packs have their own pages on Texturejam with links to the
forum posts that identify the original creator. For example, page for
[Tungsten’s Texpack + Patches][2] links to the page for [Tungsten’s Texpack][3],
which links to Tungsten’s [forum post][4] as best I can. Where the pack has a
proper home page we link to that too.

The trick here is that few packs have dedicated home pages, and forum-post URLs
change. My plan for trying to address this is to add artists’ pages to
Texturejam. This will allow for several URLs to be used to identify the
artist, and for links to their Twitter or Minecraft Forums identity. The
downside is that it is yet another page on the internet that needs
updating.

# Keeping Up-to-date

Keeping the list of source packs on Texturejam up-to-date is important
because it determines whether to offer a patched version of a pack based
on which Minecraft version the pack is designed for. If it has
out-of-date info it will offer a patched version when it should not.

I can’t expect pack artists to keep their details up-to-date on
Texturejam, even if they knew about Texturejam. Even if they wanted
to, most artists barely have time to update a forum post, let alone
edit information on the half-a-dozen other sites with lists of texture
packs. And there are not enough people who know about Minecraft texture
packs to make the critical mass needed to run a wiki. 

This leaves the automation approach—writing programs to download lists
of packs and parse them for information about versions and download
links. There are a difficulties with this approach. The lists are
designed for human readers, not machines. As discussed earlier,
identification of packs is tricky, which means that we may know that
Turtle Pack supports Beta 1.9 but not know that this is the same pack as
Snaggletooth’s Turtles Pack. There is extra complication added by the
practice of wrapping the download and home-page URLs via parasitic sites
like Mediafire and Adfly—a human can click through and sigh and tut and
moan at the extra advertisements, but it is not so easy for a program
trying to gather information.

# Death of the Web Predicted

Twenty years ago the vision for the Web was of resources freely shared,
properly identified, with stable URLs and clear attribution expressed in
metadata easily parsed by machines so as to enabled new and unexpected
ways of combining and reusing those resources. The publication of texture
packs in Minecraft illustrates as well as anything how it is possible to
take every aspect of best practice and run in the opposite direction as
fast as possible.

I had all sorts of ambitions for Texturejam—I wanted to design a way for
pack authors to map their alternate tiles and generate configurators
automagically, that sort of thing. Unfortunetely time that might have
been spent on that is instead being spent on parsing forum posts, reverse-engineering
Mediafire’s obfsucated JavaScript code and generally doing a lot of
extra work
just to let Texturejam do the limited things it already does.


  [1]: http://www.minecraftforum.net/topic/10790-texture-pack-central-mods-list/
  [2]: http://texturejam.org.uk/remixes/14/
  [3]: http://texturejam.org.uk/sources/15/
  [4]: http://www.minecraftforum.net/topic/99173-tungstens-texpac-v1/
