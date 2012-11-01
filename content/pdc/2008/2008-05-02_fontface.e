Title: My Own Fonts!
Topics: fonts type css
Date: 2008-05-02
Icon: ../icon-64x64.png

If you are reading my front page in Apple Safari 3, then you will see the headline in a nonsensical font I just invented. This is a novelty made possible by the combination 
of two different bits of work from unrelated corners of the interwebs:
Safari’s support for the [CSS web-fonts module][1], and a web-based font editor [FontStruct][] from [FontShop][].


If you can’t see the wacky typography, here’s a screen shot to give you an idea of the delights you are missing out on:


<div style="margin: 1.2em 0 1.2em  -12em" >
<img src="smallish-screenshot.gif" width="520" height="254" alt="(screenshot)" />
</div>

A very different style from what I was using for the headlines previously—if I am going to stick to it I may need to rethink the design of the page. But for now I’ll just go in to a little mode detal about web-fonts and web font editors.

About web-fonts and @font-face
----

Web-fonts is the official name for the facility in cascading style sheets to specify fonts
as downloadable resources.

[CSS 2, chapter 15][2], published in 1998, had a system for specifying how to connect
fonts requested by `font-family` directives, using @-rule, `@font-face`. At the time (ten
years ago, now) the major browser companies were cutting deals with different font
foundries to provide the format to use for these fonts, on the ground that

- a font file might be a massive 70K bytes, so obviously you need to create a subset of
  the complete font file to reduce download times, and

- if you don’t include copy protection in your font files, then all the font designers
  will starve to death within a year.

Thus Microsoft Internet Explorer only supported a special `.eot` format that tied the font
resource to a particular URL, and only included the characters used on that page—not much
use for the ever-changing web pages of the modern world. I think Netscape Navigator
supported a special format from Bitstream, but Firefox and the other Mozilla-derived
browsers do not. Designers who still wanted control over the typeface used on their pages
had to resort to all sorts of tricks to get the effect they wanted (things like [sIFR][]).

Then the Safari team had something of [a rush of blood to the head][3] and implemented
`@font-face` in WebKit, and hence in Safari 3. An [article on A List Apart][4] describes
the system in some detail.

The main qualm for some designers is that the Safari version allows designers to specify
web-fonts in TrueType format—the same format as the fonts are stored in on your computer.
Someone reading the CSS can discover the URLs of the fonts, download them, and hence
install the fonts for free. Most commercial fonts forbid you from using them in a way that
allows recipients of your documents to recover the original font files, so you can’t use
them as web-fonts.

This leaves freely distributable fonts—such as the excellent [Gentium][]—and fonts you create yourself.  The problem with the latter being that decent font-editing software costs money, and creating a decent font takes a long time even for experts.  This is where FontStruct comes in …

FontStruct, a font edtior on the web
----

FontShop is one of the oldest, if not *the* oldest, on-line font boutiques, and for some reason they have created an on-line font editor called [FontStruct][].  Now, admittedly this is not exactly a full-featured bézier-curve-tweaking font editor; instead you assemble your glyphs from a set of bricks they supply. this makes it good at creating so-called pixel fonts, where you just use square bricks:

<div style="margin: 1.2em 0 1.2em -12em">
<object type="application/x-shockwave-flash" style="width:570px; height:90px;" data="http://fontstruct.fontshop.com/widget.swf">
<param name="movie" value="http://fontstruct.fontshop.com/widget.swf" />
<param name="wmode" value="opaque" />
<param name="bgcolor" value="#FFFFFF" />
<param name="flashvars" value="d=dD0wJmFtcDtmPTMxMjA4" />
</object>
</div>

Making full use of the differently shaped bricks allows for some pretty impressive results. Here’s one called Tight by [Wolfkrim][5] that astonished me when I first saw it:

<div style="margin: 1.2em 0 1.2em -12em">
<object type="application/x-shockwave-flash" style="width:570px; height:120px;" data="http://fontstruct.fontshop.com/widget.swf">
<param name="movie" value="http://fontstruct.fontshop.com/widget.swf" />
<param name="wmode" value="opaque" />
<param name="bgcolor" value="#FFFFFF" />
<param name="flashvars" value="d=dD0wJmFtcDtmPTI1NTA1" />
</object>
</div>

My efforts are nowhere near that level of cunning, but I have come up with a novelty font
to use in headings, which for want of a better name I called Smallish.  It started out as an attempt to do a unicase on a three-by-five matrix.  As I worked my way through the lower-case letters I started getting a little more fanciful, with the result being a bit of a mixture of styles.  I am still redesigning some of the letters.


I’m quite excited at having the opportunity to redesign my web pages to use typefaces I have designed myself—even if the designs are a little wonky!






  [1]: http://www.w3.org/TR/css3-webfonts/
  [2]: http://www.w3.org/TR/1998/REC-CSS2-19980512/fonts.html
  [3]: http://webkit.org/blog/124/downloadable-fonts/
  [FontStruct]: http://fontstruct.fontshop.com/
  [4]: http://www.alistapart.com/articles/cssatten
  [5]: http://fontstruct.fontshop.com/gallery/1/all/0/0/%22wolfkrim%22
  [FontShop]: http://www.fontshop.com/
  [sIFR]: http://www.mikeindustries.com/blog/sifr/
  [Gentium]: http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&item_id=Gentium

