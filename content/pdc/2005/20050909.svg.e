Title: First Impressions of Firefox 1.5 BETA1
Date: 20050909
Topics: svg firefox
Icon: ../icon-64x64.png

As of today, there is light at the end of the tunnel: the beta of
Mozilla Firefox 1.5 not only has SVG support, said SVG support is
switched on, and even works a bit.  

I am afraid this note mainly
concentrates on the bad news (things that don&rsquo;t work).  I plan to
write more when I have had a chance to try out some of the new
possibilities and adapt my existing SVG projects to exploit them.

Omissions
-----

These are listed on the [Mozilla SVG status page][7].

Declarative animation is not supported ([bug 216462][216462]): you can
see this in the Flickr badge on my [home page][3]. Viewed via Adobe SVG
Viewer, you will see the last few images of mine from Flickr fade in and
out. In Firefox, you just see a black background with my icon in the top
corner, and a couple of spurious scrollbars.

Second, SVG fonts are not supported ([bug 119490][119490]).  I used those in the [Alleged
Tarot][4] to render the titles of the cards.   For example, in [The
Lovers][5], at the bottom-left corner we should see the title of the card
in a unicase font peculiar to this series.  On Windows this is replaced
with Helvetica, which does not look as bad as all that.  On Mac OS X, I
seem to be missing the text altogether: even the text that does not use
special fonts.

Tweaks required
-----

There is a peculiar hack used by Adobe to make SVG files look less
bulky: if it detects that the file contains a Zip archive, it unpacks
the archive and uses the contained file.  Mozilla supports a more
approach: it displays a yellow box complaining of an XML parsing error. 
The solution is [described on the Mozilla SVG Wiki][1]: program your
web server to corretly label `.svg` files as having
`Content-Encoding:gzip` and they work.  I had to add to my site&rsquo;s
`.htaccess` file, but now SVG files *do* display.

Layout Trouble
-----

There are a couple of layout problems in Firefox with regard to
SVG files embedded with an `embed` tag.  The first is that the presence
of `embed` throws their paragraph-layout system in to some sort of fit:
witness these two screen grabs:

  * [Safari 1.0](safari-1.0.png)
  * [Firefox 1.5 BETA1](firefox-1.5b1.png)
  
The [page in question][2] uses HTML code as follows:

    <p>
	<embed src="../2004/firefox-logo.svgz" 
	    type="image/svg+xml" 
	    width="120" height="120" alt="(logo)" 
	    align="left" />
	The FireFox logo to the left of this paragraph is ...
    </p>
  
The Safari capture uses the Adobe SVG Viewer plug-in.  The graphic is
shown floated left within the paragraph as expected.  There is some
space around the embed because of a CSS rule:
 
    p embed[align='left'] {
	    margin: 0.25em 0.5em 0.25em 0;
    }

All in all, it behaves pretty much as an image would, which is more or
less what I expect. The Firefox paragraph goes very weird. The left
margin is lost (notice how the *T* of *The* is to the left of the *d* of
*displayed*, and exactly matches the right edge of the column with the
*#* in it), and once it is past the embedded image it slurps all the way
over to the left edge of the viewport. The margin between this paragraph
and the next one is also gone.

A Whole New Viewport Problem
-----

Another weird thing I see is that the graphic has scrollbars. My `embed`
tag specifies width 120 and height 120 whereas the SVG file gives its
natural dimensions as width 132&middot;72, height 127&middot;219. Firefox shows the
image at its natural size and adds scrollbars. I had expected the image
to be displayed with the standard SVG viewport rules, under which the
image would have been scaled until it fit in to the
120-pixel-by-120-pixel box I specified.

To see this effect even more strongly, visit the [Alleged Tarot][6] front
page.  The left picture should show a card scaled down to thumbnail
size, but instead shows only its top-left corner, plus scrollbars.

I assume the reason for this is that `embed` is being treated as an
`iframe` containing another browser document, as opposed to being part
of this page.  (Update: this is Mozilla Bug [288276][].)

Another consequence of this is that, when I click on a
`a` tag in the SVG document, the page I linked to replaces the SVG file,
not the whole page!  To see this, click on the Flickr badge; in Safari
this replaces the whole page, in Firefox the Flickr page gets embedded
where the SVG was.  



Moving On
-----

I don&rsquo;t want to give the impression that all is gloom, however.
Getting SVG integrated in the Mozilla is an impressive pice of work,
especially given how few developers have actually been working on it,
and considering that they are attempting to do SVG the hard way, by
integrating it in to Mozilla's existing HTML + MathML layout engine,
rather than write a standalone plug-in that goes its own way.  The
result is that it has taken a long time, but the combination of SVG with
Mozilla&rsquo;s existing XML-based features (like XUL and XBL) could make for
some powerful synergy in the future. 


  [1]: http://wiki.mozilla.org/SVG:MIMEType#The_Apache_.htaccess_File
  [2]: ../2004/11/14.html
  [3]: http://www.alleged.org.uk/pdc/
  [4]: http://www.alleged.org.uk/pdc/tarot/
  [5]: http://www.alleged.org.uk/pdc/tarot/vi-lovers-card3.svgz
  [6]: http://www.alleged.org.uk/pdc/tarot/
  [7]: http://www.mozilla.org/projects/svg/status.html
  [272288]: https://bugzilla.mozilla.org/show_bug.cgi?id=272288 "Allow SVG source for svg:image"
  [119490]: https://bugzilla.mozilla.org/show_bug.cgi?id=119490 "Implement SVG fonts (Bugzilla)"
  [216462]: https://bugzilla.mozilla.org/show_bug.cgi?id=216462 "Implement SVG (SMIL) Animation"
  [288276]: https://bugzilla.mozilla.org/show_bug.cgi?id=288276 "The width and height of SVG embeded by reference isn't overriden"
  [267664]: https://bugzilla.mozilla.org/show_bug.cgi?id=267664 "anchor doesn't handle event"
  [294932]: https://bugzilla.mozilla.org/show_bug.cgi?id=294932 "Link  around SVG graphics objects doesn't work."
