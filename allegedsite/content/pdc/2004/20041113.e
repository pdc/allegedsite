Title: Percy Street badge
Date: 20041114
Keywords: percy
Icon: ../icon-64x64.png

I created the new Percy Street graphic last night. Since I keep the info
about what graphics files go in which pages in an XML file, it is easy
to do this using XSLT&mdash;this is how the HTML pages are generated as
well. When  there is a new last page, the link graphic will be updated automagically. 
I spent some time trying to use `animateColor` to animate the
highlight when you move the mouse over the links, but in the end there
were always problems with the animation being restarted and stuff so I
settled for the simpler option, `set`.

I discovered to my suprise that the `a` (link anchor) elements, used to
make links in the same way `a` elements work in HTML, interpret partial
URI references relative to the hosting HTML page, not relative to the
SVG file. This matters because the SVG file is actually in
`../../2005/percy/teaser.svg` and is embeded in a page `/pdc/index.html`.
I had expected that a link to `percy-23.html` to navigate to
`../../2005/percy/percy-23.html`; instead it went to `/pdc/percy-23.svg`,
which does not exist. This is inconsistent with the treatment of `image`
elements, for which URI references are interpreted relative to the SVG
file (just as well, since otherwise most SVGs would lose their images).
After poking about in the 
the [SVG 1.1 specification][7], I see it cites [XMLBase][8], which I
think would mean that links out of an SVG document are interpreted
relative to the document's URL. Something for the clever programmers
working on [Adobe SVG Viewer][9] to worry about for version 6.

**Update (10 Dec. 2005).** *Percy Street* is now drawn under the
pseudonym Leckford. See [Leckford's LiveJournal][1] for updates.

  [7]: http://www.w3.org/TR/SVG/struct.html#xlinkRefAttrs
  [8]: http://www.w3.org/TR/xmlbase/
  [9]: http://www.adobe.com/svg/
  [1]: http://www.livejournal.com/users/leckford/
