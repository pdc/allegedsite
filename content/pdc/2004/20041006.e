Title: Website tweaks
Image: ../icon-64x64.png
Date: 20041006
Topics: xml xslt svg

I've started a gradual redesgin of my personal webspace. Anyone who
actually visits the page will have noticed I added a background pattern
taken from [Squidfingers.com][1].  I am in the process of revamping the
links to other stuff I do on-line.

Depending on your browser's page-width, the side-boxes will now be
either to the right of this column or below it if there was not space.

On my main page, <http://www.alleged.org.uk/pdc/> there is a link to my
photos on [Flickr][2].  If your browser supports embedded SVG, then you
will see a sample photo with the Flickr logo.  It is generated with
Python using [elementtree][4] to extract information from the Atom feed
supplied by Flickr. 

This SVG image will not work in
Mozilla or Mozilla Firefox (except possibly with Corel's plug-in), because the
Mozilla developers sabotaged Adobe's attempt at a plug-in.  It
will not work with Safari on Mac OS X unless you have visited
[Adobe's SVG web pages][3] and installed the plug-in yourself. (How hard
would it be for them to install the plug-in by default?)  Why are the
browser developers so eager to thwart the adoption of SVG?

I also now have a 'b-links' or 'blogmarks' box, courtesy of the
wonderful [del.icio.us][5].  This also works from a feed supplied by the
site; in this case it is in RSS 1.0 format, and I converted it to XHTML
using XSLT.  To do this I installed [libxslt][6] on my Mac with Fink;
this supplies a command-line XSLT processor that I can use in the
makefile that maintains the site.  I discovered that with output-method
`html`, it ignores the `indent="yes"` setting; changing the
output-method to `xml` allows it to generate readable XHTML.  Weird.



  [1]: http://squidfingers.com/patterns/
  [2]: http://flickr.com/photos/pdc/
  [3]: http://www.adobe.com/svg/
  [4]: http://effbot.org/zone/element-index.htm
  [5]: http://del.icio.us/
  [6]: http://xmlsoft.org/XSLT/
