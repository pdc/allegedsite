Title: How to fail to change fonts in librsvg2
Image: ../icon-64x64.png
Date: 20041101
Topics: svg debian

On Debian GNU/Linux I am attempting to use <code>[librsvg2][lr]</code> to render a
few small images (because Mozilla-based browsers cannot display SVG),
and the wrong font is being used. How do I find out how to correct this?

Here is a sample file. First, the SVG version ([source code: `tag.svg`][4]):

<blockquote>
    <div>
        <embed src="tag.svg" type="image/svg+xml" 
			width="240" height="120" alt="" />
    </div>
</blockquote>

The font-family attribute specifies 'Helvetica, Arial, sans-serif'. 
In Adobe's SVG Viewer 3.0 it looks like this:

<blockquote>
    <div>
        <img src="tag-adobe.gif" alt="taG" />
    </div>
</blockquote>

This uses the font Helvetica; you can tell by looking for the flat top
on the *t*, the curly tail on the *a*, and the spur (beard) on the *G*. 
Batik works fine, but chooses to use Arial rather than Helvetica:

<blockquote>
    <div>
        <img src="tag-batik.png" alt="taG" />
    </div>
</blockquote>

You can tell it's Arial from the slanted *t*, the less-curled tail on
the *a*, and the beardless capital *G*. Finally, here's the `librsvg2`
version:

<blockquote>
    <div>
        <img src="tag-rsvg.png" alt="taG" />
    </div>
</blockquote>

I don't know what font this is, but it is neither Arial nor Helvetica.
More significantly, it has different font metrics.
(I think it is Bitstream Vera Sans, the default sanserif font.)

In this particular instance, I want Helvetica (or Arial), because that
is (more or less) the font used in the Flickr logo. Also, as discussed
[yesterday][3], the difference in the metrics of the font means the word falls
off the edge of the picture. Now, neither Helvetica nor Arial are free
software, although for a while Microsoft were allowing people to
download Arial gratis, but there are other metrically compatible
sanserif fonts. I seem to remember using URW Gothic in TeX back in the
early 1990s, and Debian has a `fc-list` command whose output includes
references to this font; does that mean it is installed in a way that
`rsvg` can use it? If so, couldn't it be aliased to Helvetica for the
sake of simplifying cross-platform SVG? 

The `librsvg2` web page has nothing to offer on configuring the way it finds fonts. 
This library is based on [Ralph Levien's][2] library [Libart][la]; 
perhaps there will be some clues there? There are some references to
fonts -- unfortunately the first one Google found for me was about [how
the SVG specification makes implementing text needlessly
complicated][1]! Oh, well. 


  [la]: http://www.levien.com/libart/
  [lr]: http://librsvg.sourceforge.net/
  [1]: http://www.levien.com/svg/shame.html
  [2]: http://www.levien.com/
  [3]: 10/31.html
  [4]: tag.svg
