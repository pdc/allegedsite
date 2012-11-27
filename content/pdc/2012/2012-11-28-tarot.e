Title: Attic Pluck: Alleged Tarot 2002
Topics: tarot svg python make
Date: 2012-11-28

It has taken only ten years but we now have SVG support as good as it was ten
years ago using Adobe’s SVG Viewer plug-in in Netscape 4. I have decided it is
about time I resurrected my 2002 project, the Alleged Tarot.

(Yes, this is yet another post about the site itself. I need to get out more.)

<div class="image-full-width" style="padding: 1.23em 0;  height: 137px">
    <img src="http://alleged.org.uk/pdc/tarot/0-fool-100w.png" style="margin: 0 10px 0 10px" width="100" height="137" alt="(0. The Fool)">
    <img src="http://alleged.org.uk/pdc/tarot/iiii-emperor-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(IV. The Emperor)">
    <img src="http://alleged.org.uk/pdc/tarot/viii-justice-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(VIII. Justice)">
    <img src="http://alleged.org.uk/pdc/tarot/xii-hanged-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XII. The Hanged Man)">
    <img src="http://alleged.org.uk/pdc/tarot/xvi-tower-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XVI. The Tower)">
</div>

What Has Gone Before
====================

It has been moderately interesting revisiting code I wrote 10 years ago. Back then
I generated my site pages using [TclHTML][1], a package for generating HTML
documents using the tool command language [Tcl][2]. I drew the card images
using Adobe Illustrator running on my 1997 [Apple Macintosh Perform
5260/120][3].
The `.ai` files were transferred to my Linux desktop and
converted to [SVG][4] using a lash-up of software the details of which I
forget. Since I can no longer run Illustrator, these are effectively the
source files now. A Tcl program [mkcard3.tcl][5] munges these to add the card
descriptions and interactive elements. This whole elaborate scheme is
automated through a program called Make (young folk can try to imagine Rake or
Ant before they invented Ruby or XML).

<div class="image-full-width" style="padding: 1.23em 0;  height: 137px">
    <img src="http://alleged.org.uk/pdc/tarot/wands-ace-100w.png" style="margin: 0 10px 0 10px" width="100" height="137" alt="(0. The Fool)">
    <img src="http://alleged.org.uk/pdc/tarot/wands-4-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(IV. The Emperor)">
    <img src="http://alleged.org.uk/pdc/tarot/wands-5-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(VIII. Justice)">
    <img src="http://alleged.org.uk/pdc/tarot/wands-7-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XII. The Hanged Man)">
    <img src="http://alleged.org.uk/pdc/tarot/wands-queen-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XVI. The Tower)">
</div>

Because in 2002 SVG was still a slightly obscure, emergent standard, supported only if you had
taken the trouble to install Adobe’s plug-in, I also provided a version using
PNG files. The ancient software on the Mac could not generate PNGs, only an
obsolete format called Targa, so another chain of converters was originally
used to get them sorted as well. To make things more interesting, the
conversion from Illustrator’s CMYK colourspace to  RGB was a bit weird and had
to be adjusted as well.

So What Went Wrong?
===================

The Mozilla project wanted to relase version 1.0, which would freeze the API
used for plug-ins. In order to have an API they coild commit to supporting
forever, they made changes from the 0.9 version which broke Adobe’s
plug-in—worse, the breakage was something that caused a crash, with no way to
check for compatibility beforehand. Adobe abandonned work on the plug-in.  SVG
was banished to the outer darkness, handing Macromedia an
effective monopoly on vector graphics online.

<div class="image-full-width" style="padding: 1.23em 0;  height: 137px">
    <img src="http://alleged.org.uk/pdc/tarot/cups-ace-100w.png" style="margin: 0 10px 0 10px" width="100" height="137" alt="(0. The Fool)">
    <img src="http://alleged.org.uk/pdc/tarot/cups-3-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(IV. The Emperor)">
    <img src="http://alleged.org.uk/pdc/tarot/cups-7-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(VIII. Justice)">
    <img src="http://alleged.org.uk/pdc/tarot/cups-ten-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XII. The Hanged Man)">
    <img src="http://alleged.org.uk/pdc/tarot/cups-king-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XVI. The Tower)">
</div>

Five years later a new strange browser war broke out as the Mozilla, Webkit,
and Opera camps attempted to outdo each other with implementing and extending forgotten web standards.
SVG was added to one of the Acid tests and lo! corporate ego achieved what
years of pleading by standards bodies and potentials users had failed to do,
and SVG was widely implemented.

Apart from Microsoft Internet Explorer, of course.

So in 2012 the situation is that SVG is now a slightly obscure, emergent
standard. My pages using SVG should now work again, but for one feature
Adobe’s plug-in supported that modern implementations do not: compressed SVG
files with a `.svgz` extension. The reason for this is that HTTP supports
compression on the wire, so downloading a `.svg` file takes no more time than
its compressed equivalent (since they are both compressed during transit), and
whether it is stored compressed is a local matter: there is no reason to bake
it in to the file format. So the first step in resurrecting my SVG
illustrations is replacing all the `.svgz` files and links to them.

Fixing It
=========

The first step, as mentioned, is going through the Makefile, which in this
case is [`extra.mk`][7], and find places where SVG files are compressed. I
also discovered that past me had the bright idea of making the Python program
[`mksvgindex.py`][6] produce the SVG index files already compressed, so I had
to change the program to prevent this.

<div class="image-full-width" style="padding: 1.23em 0;  height: 137px">
    <img src="http://alleged.org.uk/pdc/tarot/swords-ace-100w.png" style="margin: 0 10px 0 10px" width="100" height="137" alt="(0. The Fool)">
    <img src="http://alleged.org.uk/pdc/tarot/swords-3-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(IV. The Emperor)">
    <img src="http://alleged.org.uk/pdc/tarot/swords-5-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(VIII. Justice)">
    <img src="http://alleged.org.uk/pdc/tarot/swords-9-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XII. The Hanged Man)">
    <img src="http://alleged.org.uk/pdc/tarot/swords-knight-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XVI. The Tower)">
</div>

This at least gets it so that [the index pages][8] work no worse than they did in 2002.

At this point I discovered that the deal page was not working because it did
not exist! It seems that some time when I was rearranging my files for the
switch to a Django-powered site I left some of the files out. Not too hard to
fix, as it turned out: there was an old copy of the site with the files intact
elsewhere that I found thanks to the magic of Sherlock. As with the index
pages, I have concentrated for now on getting them working again; improving
the user experience of using the virtual tarot deck with the knowledge I have
accrued in the intervening decade I will leave for later!

Forking TclHTML
===============

The next problem I had was that the old pages are generated with TclHTML, a
package I wrote back in the late 1990s. I had to choose between redoing the
section over from scratch or getting the old software to run. Actually it
worked pretty well until I discovered that the makefile generator (`thmkmf`)
has a couple of interesting bugs.



<div class="image-full-width" style="padding: 1.23em 0;  height: 137px">
    <img src="http://alleged.org.uk/pdc/tarot/coins-ace-100w.png" style="margin: 0 10px 0 10px" width="100" height="137" alt="(0. The Fool)">
    <img src="http://alleged.org.uk/pdc/tarot/coins-5-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(IV. The Emperor)">
    <img src="http://alleged.org.uk/pdc/tarot/coins-8-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(VIII. Justice)">
    <img src="http://alleged.org.uk/pdc/tarot/coins-ten-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XII. The Hanged Man)">
    <img src="http://alleged.org.uk/pdc/tarot/coins-king-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XVI. The Tower)">
</div>

One of the problems was juggling partial paths: `srcRootDir`, the path from
the  current directory to the topmost (root) directory, `htmlRootDir`, the
path from the root directory of the source files to the deployment directory,
and `subDir`, the path from the root directory to the current directory. It
follows that when looking for an image file referenced in an `img` command, it
should look in `$srcRootDir/$htmlRootDir/$subDir`. Unfortunately past me got
it wrong in a couple of places. So I needed to fix the code and run `make` again.

This is fine but then there is a second decision point: do I deploy by
updating the source code on the server as I already do (`git pull`) and then
run the HTML generation on the server, or generate the HTML locally and then
`rsync` the results to the server? I chose the former, which (with the benefit
of hindsight) made things a bit more complicated. Now I not only had to
correct bugs in `TclHTML`, I had to make it possible to deploy the new version
to the server.

I published TclHTML to SourceForge back in the Twentieth Century, from an
email address I no longer have access to. After a bit of pondering I ended up
forking the project through  Git’s `cvsimport` command, so it can now be
installed from the [TclHTML project on GitHub][9].

Finally
=======


<div class="image-full-width" style="padding: 1.23em 0;  height: 137px">
    <img src="http://alleged.org.uk/pdc/tarot/v-pope-100w.png" style="margin: 0 10px 0 10px" width="100" height="137" alt="(0. The Fool)">
    <img src="http://alleged.org.uk/pdc/tarot/viiii-hermit-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(IV. The Emperor)">
    <img src="http://alleged.org.uk/pdc/tarot/xiii-death-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(VIII. Justice)">
    <img src="http://alleged.org.uk/pdc/tarot/xvii-star-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XII. The Hanged Man)">
    <img src="http://alleged.org.uk/pdc/tarot/xxi-world-100w.png" style="margin: 0 10px 0 0" width="100" height="137" alt="(XVI. The Tower)">
</div>

You can now visit the [Alleged Tarot][10] site and see it restored to how it looked in 2002, warts and all.


  [1]: http://sourceforge.net/projects/tclhtml/
  [2]: http://www.tcl.tk/software/tcltk/
  [3]: http://www.everymac.com/systems/apple/mac_performa/specs/mac_performa_5260_120.html
  [4]: http://www.w3.org/Graphics/SVG/
  [5]: https://github.com/pdc/allegedsite/blob/master/content/pdc/tarot/mkcard3.tcl
  [6]:https://github.com/pdc/allegedsite/blob/master/content/pdc/tarot/mksvgindex.py
  [7]:https://github.com/pdc/allegedsite/blob/master/content/pdc/tarot/extra.mk
  [8]: ../tarot/svg.html
  [9]: https://github.com/pdc/tclhtml
  [10]: ../tarot/

