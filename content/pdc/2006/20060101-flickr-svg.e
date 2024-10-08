Title: Flickr Badge in SVG
Topics: svg flickr make xsltproc
Icon: flickr-100x100.png
Date: 20060101

In October 2004 I added a Flickr 'badge' to my home page. Now that
someone's asked me how this is done, I am going to explain in a
reasonable about of detail how the SVG file is generated automatically
from information on Flickr.  Even if you don't feel a pressing need to
create a SVG file celebrating your Flickr photos, the techniques
described herein are fairly widely applicable if you happen to maintain
your own web site.

Getting Flickr Information as XML
-----

I want to generate the Flickr badge automatically from my most recent
photos on [Flickr][].  Since the [SVG][] format is based on [XML][], so the first approach I would
try is to get the information as XML somehow, and then convert that to
SVG using [XSLT][].  So how do I do that?

The [Flickr FAQ list][] points to the [Flickr badge wizard][]. The
wizard works by asking you some questions and then giving you an HTML
fragment to insert on your web page. Picking apart the HTML fragment, I
discovered a URL that returns the information I want. I was able to
confirm this by visiting the URL in my web browser.  It does not quite return XML, however, but something like this:

    document.write('<a href="http://www.flickr.com/photos/pdc/66501836/"><img src="http://static.flickr.com/35/66501836_2e53f137c7_m.jpg" class="flickrimg" id="flickrimg1" /></a>');
    document.write('<a href="http://www.flickr.com/photos/pdc/66501835/"><img src="http://static.flickr.com/29/66501835_50d58d3831_m.jpg" class="flickrimg" id="flickrimg2" /></a>');
    document.write('<a href="http://www.flickr.com/photos/pdc/66501834/"><img src="http://static.flickr.com/26/66501834_1890d20731_m.jpg" class="flickrimg" id="flickrimg3" /></a>');
    document.write('<a href="http://www.flickr.com/photos/pdc/66501833/"><img src="http://static.flickr.com/34/66501833_fd0187210a_m.jpg" class="flickrimg" id="flickrimg4" /></a>');
    document.write('<a href="http://www.flickr.com/photos/pdc/66501832/"><img src="http://static.flickr.com/28/66501832_1c9fe98e1a_m.jpg" class="flickrimg" id="flickrimg5" /></a>');

It has the XML I want, but wrapped up in JavaScript coating. So I saved
it as `flickr-badge.js` (`.js` for JavaScript). It was easy enough to
write a [Python][] program `flickr-badge-to-xml.py` that strips off the
JavaScript and converts this to an XML document:

    #!/usr/bin/python
    
    import sys
    
    fileName = sys.argv[1]
    input = open(fileName, 'r')
    text = input.read()
    input.close()
    
    text = text.replace("document.write('", '')
    text = text.replace("');", '')
    
    print '<badge xmlns="tag:alleged.org.uk,2004:flickr">'
    print text
    print '</badge>'
    
I tested this by using typing in a command like

    python flickr-badge-to-xml.py flickr-badge.js | less

The output of this program is an XML document that feeds in to the next
step.

**Note.** *I think the Flickr badge generator produces different HTML
from what it produced back in October 2004, and the new HTML uses a new
URL for obtaining the image data.  So if I were doing this all from
scratch some of the above details might now be different.*


Converting XML to SVG with XSLT
-----

[XSLT][] is a system for describing a transformation from one XML format
to another one---in this case, from the XML format I just made up in the
previous step in to SVG.  (I could use the exact same system to generate
an XHTML document instead, for example.)  The XSLT language itself is an
XML format, and as a result is verbose and a little difficult to read if
you are not used to it. Unless you are an avid XML fan, you will want to
skip the rest of this section.


We start with a 'blank' XSLT file:

    <xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:flickr="tag:alleged.org.uk,2004:flickr"
                xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="1.0"
                exclude-result-prefixes="flickr">
        <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    </xsl:transform>
        
The namespace introduced with
`xmlns:flickr="tag:alleged.org.uk,2004:flickr"` is the one used in my
ad-hoc XML format; the URL uses the [Tag URI scheme][] ([RFC 4151][]).
The `xsl:output` element's `indent` attribute is set to `no` because
some SVG renderers include newlines between `text` tags and their
contents as extra whitespace, which disrupts the layout. I no longer
include `doctype-system` and `doctype-public` attributes; SVG
implementations do not use them and future versions of SVG do not permit
them.

The next step is adding a template that matches the outermost element of
the input format and generates the outer structure of the output document:

    <xsl:param name="width" select="200"/>
    <xsl:param name="height" select="200"/>
    <xsl:param name="creator" select="'Damian Cugley'"/>
    
    <xsl:template match="/flickr:badge">
        <svg viewBox="0 0 {$width} {$height}" width="100%" height="100%">
            <title>
                <xsl:value-of select="$creator"/>
                <xsl:text>&#x2019;s photos</xsl:text>
            </title>
            <desc>
                <xsl:text>Link to </xsl:text>
                <xsl:value-of select="$creator"/>
                <xsl:text>&#x2019;s photos on Flickr.com</xsl:text>
            </desc>
            <defs>
            </defs>
            <!-- content will go here -->
        </svg>
    </xsl:template>
    
The parameters `$width` and `$height` control the natural size of the
image. Originally the `width` and `height` attributes would be set to
those values as well, but using `100%` instead prevents unwanted scrollbars in Firefox
(Bugzilla bug [288276][]). 

Next we add the actual content of the document after the `defs` element:

    <xsl:param name="uri" select="'http://www.flickr.com/photos/pdc/'"/>

    <xsl:template match="/flickr:badge">
        <svg ...>
            ...
            <a xlink:href="{$uri}" target="_parent">
                <g onclick="parent.location.href='{$uri}'; return false;">
                    <xsl:apply-templates select="flickr:a/flickr:img"/>
                </g>
            </a>
        </svg>
    </xsl:template>

The link (`a` element) has a `target` attribute of `_parent`, which I
believe should cause clicking on the link in the image to replace the
parent document. But alas! Firefox 1.5 does not support this attribute
(bug [300868][]), so I also add an `onclick` attribute, which does the
same thing, except using JavaScript. This can't be on the `a` element
itself (bug [267664][]), so needs an extra `g` wrapper.
    
The line 

    <xsl:apply-templates select="flickr:a/flickr:img"/>
    
in the middle of all that is the bit that looks for images in the XML
input and generates the SVG equivalent.  Because all of this is wrapped
in the `a` and `g` elements, clicking on any of this will cause the
user's web browser to visit that page.

At this point, I needed to decide how I wanted my 'badge' laid out. The
approach I have used is fairly simple: the most recent photos are
stacked on top of each other, but are all transparent (opacity = 0&middot;0)
and one at a time is made visible (opacity = 1&middot;0).  This creates
the effect of a slideshow.

So we add a second template that matches those `flickr:img` elements:

    <xsl:template match="flickr:img">
        <image
                x="0" y="0" width="{$width}" height="{$height}"
                preserveAspectRatio="xMidYMid slice"
                xlink:href="{@src}">
        </image>
    </xsl:template>

This uses the magic of SVG's `preserveAspectRatio` conventions to take
care of scaling and cropping the photo to fill our badge's area.

This actually shows only the least-recently-added photo from the
recently-added photos list, because it is stacked on top, and is opaque.
The next step is to make a slide-show be arranging that all of them be
transparent most of the time, and take turns in becoming visible.  After
a fair amount of fiddling and head-scratching, this is what I came up
with:
    
    <xsl:template match="flickr:img">
        <xsl:variable name="i" select="count(../preceding-sibling::flickr:a)"/>
        <xsl:variable name="n" select="count(../../flickr:a)"/>
        <xsl:variable name="total-seconds"
                select="$photo-seconds + $crossfade-seconds"/>
        <xsl:variable name="photo-frac" 
                select="$photo-seconds div ($total-seconds) div $n"/>
        <xsl:variable name="crossfade-frac" 
                select="$crossfade-seconds div ($total-seconds) div $n"/>
        <image
                x="0" y="0" width="{$width}" height="{$height}"
                preserveAspectRatio="xMidYMid slice"
                xlink:href="{@src}"
                opacity="0">
            <animate attributeName="opacity" values="0;1;1;0;0" 
                    keyTimes="0;{$crossfade-frac};{$photo-frac + $crossfade-frac};{$photo-frac + 2 * $crossfade-frac};1"
                    begin="{$i * $total-seconds}s" dur="{$n * $total-seconds}" repeatCount="indefinite"/>
        </image>
    </xsl:template>

The list of `xsl:variable` elements calculate the slice of time this
image should be made visible, and then we use these values in the
`keyTimes` attribute of the `svg:animate` element.  There is still one
slight problem: when it starts up, *none* of the images is
visible---which is a big problem in Firefox, which ignores the `animate`
element (bug [216462][]).  So I modified it so the `opacity="0"`
attribute is not added to the most-recent image:

    <xsl:template match="flickr:img">
        ...
        <image
                x="0" y="0" width="{$width}" height="{$height}"
                preserveAspectRatio="xMidYMid slice"
                xlink:href="{@src}">
            <xsl:if test="$i &gt; 0">
                <xsl:attribute name="opacity">0</xsl:attribute>
            </xsl:if>
            <animate ... />
        </image>
    </xsl:template>
    
Firefox users don't see the animation, but at least they see a recent
photo.

Finally, we can go back to the first template and add some extra
decorations, in the form of my userpic, and a version of the Flickr
logo:

    <xsl:template match="/flickr:badge">
        <svg ...>
            ...
            <a ...>
                <g ...>
                    <xsl:apply-templates select="flickr:a/flickr:img"/>
                    <image
                            x="1" y="1" width="48" height="48"
                            xlink:href="http://www.flickr.com/buddyicons/14145351@N00.jpg"/>
                    <rect x="{$width - 50}" y="{$height - 20}" width="52" height="22" 
                            rx="2" ry="2" fill="#FFF" opacity="0.75"/>
                    <text
                        x="{$width - 1}" y="{$height - 1}"
                        font-family="Helvetica, Ariel, sans-serif"
                        font-weight="700"
                        font-size="20"
                        text-anchor="end" stroke="none"
                    >
                        <tspan fill="#0063DC">flick</tspan><tspan fill="#FF0084">r</tspan>
                    </text>
                </g>
            </a>
        </svg>
    </xsl:template>
        
I've had some trouble identifying the font used in the Flickr logo;
[WhatTheFont][] failed to find one with that distinctive
vertical-terminated *c* and square dots on the *i*.  On the other hand,
the only sanserif fonts I can depend on on user's browsers are Helvetica
and Arial, so I specify those.

The complete XSLT program is in a file
<code>[flickr-badge-to-svg.xslt][]</code>.  I can test this using a
command like

    xsltproc flickr-badge-to-svg.xslt flickr-badge.xml > flickr-badge.svg

and then examining the file `flickr-badge.svg` in an SVG-savvy browser
(or in a text editor, to check the SVG being generated is exactly what I
expect).


Marvelous Automation with Make
-----

This makes for a nice enough badge, but when I take new photos (assuming
I buy a camera to replace the one that was stolen!) I need to do several
steps to update the badge to match the new photos:

  - visit the strange URL that gets the photo information
  - File &rarr; Save As
  - `python flickr-badge-to-xml.py flickr-badge.js > flickr-badge.xml`
  - `xsltproc flickr-badge-to-svg.xslt flickr-badge.xml > flickr-badge.svg`
  - FTP the updated files to the Alleged Literature web server.

This is tedious and error-prone; let's instead automate it using `cron` and `make`.

For the benefit of readers who are interested in SVG and XML but don't
know about `make`, I will now attempt a brief description. The `make`
command is the standard Unix tool for building programs. It has a
configuration file (called a makefile) full of little recipes. For
example, the following makefile recipe

    flickr-badge.svg: flickr-badge.xml flickr-badge-to-svg.xslt
            xsltproc flickr-badge-to-svg.xslt flickr-badge.xml > flickr-badge.svg
            
is shorthand for something like this:

> **To make:**  flickr-badge.svg
> 
> **Ingredients:** one cup of flickr-badge.xml, dash of flickr-badge-to-svg.xslt
>
> **Method:** feed `flickr-badge-to-svg.xslt` and
> `flickr-badge.xml` in to `xsltproc`. Serve immediately in
> `flickr-badge.svg`.

It's a bit like cooking, except the ingredients and outputs are always
files rather than foods and the method is a sequence of Unix commands.
The clever bit is that a recipe can have ingredients that are described
by other recipes in the makefile; `make` will take care of building
things in the correct order. It also knows not to bother making
something if it is already up to date.

The `make` command is installed as standard on Unix systems, including
Mac OS X. If you are stuck with a Windows system, you can install
various flavours of `make`, either as part of a commercal development
environment like Microsoft Visual Studio .NET 2003, or one of the
Windows ports of the GNU tools.

Anyway, the makefile for the badge machine is fairly straightforward:

    flickr-badge.svg: flickr-badge.xml flickr-badge-to-svg.xslt
            xsltproc flickr-badge-to-svg.xslt flickr-badge.xml > flickr-badge.svg
    
    flickr-badge.xml: flickr-badge.js flickr-badge-to-xml.py 
            python flickr-badge-to-xml.py flickr-badge.js > flickr-badge.xml

You will notice that we treat the programs used to munge the files
(`flickr-badge-to-xml.py ` and `flickr-badge-to-svg.xslt`) as
ingredients: this means that when we change these files, the SVG file is
considered out-of-date and will be rebuilt. 

On my system, the process of copying files from my build directory to
the local copy of my web site is done through a 'virtual' recipe named
`install`, which is also included in the makefile:

    install: install-flickr
    
    install-flickr: flickr-badge.svg flickr-badge-to-svg.xslt
            cp -p flickr-badge.svg $(htmlDir)
            cp -p flickr-badge-to-svg.xslt $(htmlDir)
    
The makefile now takes care of all the processing steps between getting fresh copies
of the photos list from the Flickr web site to uploading to my website.

The first step---getting the data files from `flickr.com`---uses another
program of mine, called `fetch.py`. It has a configuration file that
lists URLs that I want a copy of. It maintains its own metadata database
that lists the time each URL was last downloaded, its `ETags`, and its
MD5 digest: if the remote resource has *not* been changed since last
time, the file on disc is not changed, and that means `make` will know
not to update the output files, and that in turn stops them from being
needlessly uploaded to my web site.  

Finally, I have a `cron` script that runs `fetch.py` to freshen my
downloaded files and then invokes `make` to update anything that is
affected by the changed files (if any). In principle, it would be run
every day, say; in practice, since my PowerBook is not left running 24
hours a day, this does not work, and I instead run the script myself
when I remember to. But in principle this last step could be automated
as well.

**Update** (4 February 2006). I have renamed `fetch.py` to `wfreshen.py` to try
to make the name more likely to be unique. It is described in my [next article][].


Isn't this a Lot of Effort?
-----

I use XSLT a lot, especially at my day job (which has nothing to do with
SVG, but does use a lot of XML in various applications), so using XSLT
to generate badges is the straightforward option for me.  By the same
token, I already had a system for maintaining my web site using `make`
and `fetch.py`; slotting the Flickr badge processing in to this system
was pretty easy.  If neither of the above apply to you, then you
probably do *not* want to be running out to install `xsltproc` and GNU
`make` just to make a Flickr badge---especially as Flickr supply a
perfectly fine badge based on Macromedia Flash that requires no
programming effort on your part at all.

The advantage to me is that I can change the way my badge looks by
editing the XSLT. (Emulating the sliding tiles in Flickr's prefabricated
badge is an exercise for the reader.)  And the same techniques could be
adapted to other photolog web sites if you don't use Flickr.


  [Flickr]: http://flickr.com/ "Photo Sharing"
  [Flickr FAQ list]: http://www.flickr.com/help/photos/#53
  [Flickr badge wizard]: http://www.flickr.com/badge_new.gne
  [Python]: http://python.org/ "Python programming language"
  [svg]: http://www.w3.org/Graphics/SVG/ "Scalable Vector Graphics"
  [xml]: http://www.w3.org/XML/ "Extensible Mark-Up Language"
  [xslt]: http://www.w3.org/Style/XSL/ "Extensible Stylesheet Language"
  [Tag URI scheme]: http://www.taguri.org/
  [RFC 4151]: http://ietf.org/rfc/rfc4151.txt "The 'tag' URI Scheme"
  [288276]: https://bugzilla.mozilla.org/show_bug.cgi?id=288276 "The width and height of SVG embeded by reference isn't overriden"
  [300868]: https://bugzilla.mozilla.org/show_bug.cgi?id=300868 "target attribute not supported for SVG:a element"
  [267664]: https://bugzilla.mozilla.org/show_bug.cgi?id=267664 "anchor doesn't handle event"
  [216462]: https://bugzilla.mozilla.org/show_bug.cgi?id=216462
  [WhatTheFont]: http://www.myfonts.com/WhatTheFont/
  [flickr-badge-to-svg.xslt]: ../2004/flickr-badge-to-svg.xslt
  [next article]: 02/04.html
