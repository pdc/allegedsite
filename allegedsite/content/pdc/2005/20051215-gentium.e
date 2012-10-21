Date: 20051215
Title: Experiments with Gentium
Icon: ../icon-64x64.png
Topics: typography type-design gentium css
Href: http://scripts.sil.org/gentium

I followed a link from [reddit][] to [25 Best License-Free Quality
Fonts][1] to [Gentium][], a typeface noteable for its inclusion of *all*
the latin characters in Unicode 4.1, one of only a few fonts that can
boast this and are available for Mac OS *and* Microsoft Windows.  I have
been inspired by this to redesign my web pages (yet again) to use this
typeface.

All the Latin you Can Eat
-----

You may be wondering what the fuss is about when I say all of the latin
script; wasn't Latin written with just the capital letters *A*--*Z*
(minus *J* and *W*)? Well, yes, but we use 'latin' to mean all the
scripts descended from that alphabet, which means modern fonts all
include national letters like German eszet <i>&szlig;</i>, Iceland's <i>&eth;</i> and
<i>&thorn;</i>, and some special letters that originated as ligatures like
<i>&oelig;</i> and <i>&aelig;</i>, not to mention preformed combinations of letters
with marks above and below (<i>&eacute;</i>, <i>&ccedil;</i>, etc.). That covers much
of Europe, but it turns out that the linguists who created alphabets for
African languages had something of a rush of blood to the head and
devised [all sorts][U0180] of exciting new letter variations to
represent the local phonemes, so Gentium has <i>&#x0180;</i>,
<i>&#x0188;</i>, <i>&#x0195;</i>, <i>&#x0263;</i>, <i>&#x01A3;</i>,
<i>&#x01AA;</i>, <i>&#x01BA;</i>, <i>&#x021D;</i>, <i>&#x01F7;</i>,
<i>&#x01BE;</i>,  and a whole lot more (actually, not all of those are African;
some are used in Anglo-Saxon).  On my system, the only other
font including these characters in Lucida Grande (which is not
available on Windows).  On Windows, I expect they are in Arial Unicode or
Lucida Sans Unicode, which are not available on Mac OS X. 

There are
other cross-platform fonts available with very large repertoires, such
as CODE2001, [Cardo][], [Junicode][], and others, mainly aimed at
scholarly publishing.  Gentium concentrates on the latin scripts, with
some digressions in to its close cousins, Greek and (in future
versions) Cyrillic.  I think this makes sense, rather than trying to
cram in mediocre versions of other writing systems in to one big font.

Gentium is freely
distributable and can be used anywhere: you can download the font and install it on your PC, Mac,
or Unix box *right now*, and even produce modified versions, according
to the [SIL Open Font Licence][OFL]:

> The OFL allows the licensed fonts to be used, studied, modified and
> redistributed freely as long as they are not sold by themselves. The
> fonts, including any derivative works, can be bundled, embedded,
> redistributed and sold with any software provided that the font names
> of derivative works are changed. The fonts and derivatives, however,
> cannot be released under any other type of license.

Some of the other aformentioned fonts are restricted to non-commerical work,
or require payment, or have other restrictions. 


Type Design Inspires Typography
-----

Gentium is unusual amongst megafonts in that has its own visual
identity, rather than being Times (or Arial, or Bembo) with lots of
extra letters added.  That's the real reason why I am using it: I don't actually need to
be able to include African and Vietnamese text on my site on a regular
basis, but I like the way Gentium looks.

> The design is intended to be highly readable, reasonably compact, and visually attractive. 
> The additional 'extended' Latin letters are designed to naturally harmonize 
> with the traditional 26 ones. Diacritics are treated with careful thought and
> attention to their use. Gentium also supports both ancient and modern Greek,
> including a number of alternate forms. These fonts were originally the product
>  of two years of research and study by the designer at the University of Reading,
>  England, as part of an MA program in Typeface Design.

One decision [Victor Gaultney][2] made was to have capital letters that
are smaller than usual. It is usual in serif fonts to have ascenders of
lower case letters like *b* and *l* be fractionally taller than capital letters;
Gentium makes this difference stronger: AbCdEfGhIjKlMnOpQrStUvWxYz. This
makes it look nicer in Languages like German that use many Capital
Letters because every Noun is capitalized. It also suits text with lots
of TLAs such as my rants about SVG and HTML and XSLT and XML and MU. 

A week or two ago I read the introduction to [The Elements of
Typographic Style Applied to the Web][3] and this prompted me to ponder
the typography of my site anew. I was considering modifying my set-up so
I could convert all-capital words in to small caps, in the way some
print magazines do. This would have been consistent with my use of
old-style figures (by specifying [Hoefler Text][6] and [Hightower
Text][4]), but the use of small caps never seems quite right to me: you
end up with USA in little caps and Britain with a big cap and it just
seems odd. On the other hand, the uneven rhythm caused by lots of
capitals also looks wrong. With Gentium, the problem is solved without
my doing anything!

Another side-effect of this is that all-capitals text looks unusually
pleasant. I have therefore felt emboldened to use all-caps as emphasis
for headings in my Gentium redesign. The narrow, calligraphy-influenced
design reminds me of [Rustica Capitals][5], a style used in ancient
Rome.


Concocting a New Style-Sheet
-----

When I tried experimentally switching to specifying Gentium in my
existing light-on-dark stylesheet, I discovered it just looked wrong.
Gentium's calligraphic influences stand out oddly when reversed out; it
looks much happier in a more conventional black-on-white setting. So I
started a fresh stylesheet with

    * {
        margin: 0;
        padding: 0;
    }
    
    body {
        font-size: 100%;
        font-family: "Gentium", "GentiumAlt", serif;
    }

and went on from there.  Following on from the calligraphy idea, I
plonked down a buff colour as background, with black text and a sort of
faded red for emphasis.  Using green (rather than blue) for links
reflects the fact that green ink is another traditional highlight
colour.

Earlier versions had the body text enclosed in
a rectangle, but I took that out.  In similar vein, the boxes of links
and similar junk have have no borders an d are separated out by
whitespace instead.  Instead of my slightly unsatisfactory attempts to
get CSS floating to arrange the boxes automatically side by side in wide
windows and above each other in narrow ones, I now have turned them in
to solid rectangles (not stacked like bullet points) which expand
arbitrarily to fill the space.  For a bunch of undifferentiated links, I
think this works rather well.  The combination of orange and mixed
greens is a little seventies, but what the hey.

As mentioned earlier, I use all-caps and faded red for headings; apart
from the reasons given earlier, there is also the issue that Gentium has
no bold weight available as yet!


Compatibility
-----

So, gentle reader, if you want to see this page as I think it looks
best, visit the [Gentium][] web site and download and install the font
(presuming you are not using a work PC which forbids such behaviour). 

In Firefox 1.5 (Mac OS X) I see strange layout, where the word space between italic
and roman text is wrong, leading to overlaps:

<blockquote>
    <div>
        <img src="gentium-ff.png" alt="(screen grab)" />
    </div>
</blockquote>

Safari 2 does not have the same trouble:

<blockquote>
    <div>
        <img src="gentium-safari.png" alt="(screen grab)" />
    </div>
</blockquote>

For now I plan to ignore the problem, in the hopes that it will go away
by itself.  I hope it does not represent a bug in the font files.

I intend to test on Windows browsers tomorrow.

**Update (16 December).**  I've now checked it in Firefox running on
Windows XP, and it does not have the same overlapping-text problem.
here's a screen grab:

<blockquote>
    <div>
        <img src="gentium-ff-win.png" alt="(screen grab)" />
    </div>
</blockquote>

Windows does not use anti-aliasing on the font at this size, so it looks
a little more ragged than on the Mac.  

I need to make some changes to the CSS to suit Microsoft Internet
Explorer since it does not understand [CSS2][]'s <code>[max-width][7]</code>
property (I always forget to allow for that). Also, MSIE does not
understand selctors with `>` in them, which means the paragraphs are all
completely unstyled!

I have now modified my pages to work in IE. First off, the tag-line
paragraph now has an `id` attribute, so it can be selected with

    p#tagline { ... }
    
rather than

    #body>p { ... }
    
Second, I have added an IE-specific stylesheet using the newly noticed
[IE-specific conditional comments syntax][8], as follows:

    <!--[if lte IE 6]>
    <link rel="stylesheet" type="text/css" href="../2005/gentium-ie6.css" title="Gentium" />
    <[endif]-->

Note I have limited this override to IE versions &le;6; I am allowing
for the possibility that IE&nbsp;7 will fix these bugs.  This is an
important principle: when adding code to cope with bugs in browsers,
err on the side of assuming future browsers are less buggy than old
ones.  Do not repeat the mistake of the ASP .NET team, who hard-coded in
to their software an assumption that all versions of Mozilla would be
identical to Netscape 4.x---which means ASP .NET will not serve modern
HTML to Mozilla or Firefox.

**Update (17 December).**  I have decided that Bugzilla bug [283902][]
is the closest match to my layout glitches, and I have created a
cut-down version of this page as a [test case][9] with a [screen
grab][10] where you can compare the Safari and Firefox rendering.










  [reddit]: http://reddit.com/
  [gentium]: http://scripts.sil.org/gentium
  [0180]: http://www.unicode.org/charts/PDF/U0180.pdf
  [cardo]: http://scholarsfonts.net/cardofnt.html
  [junicode]: http://www.engl.virginia.edu/OE/junicode/junicode.html
  [OFL]: http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&item_id=OFL
  [css2]: http://www.w3.org/TR/REC-CSS2/cover.html#minitoc
  [283902]: https://bugzilla.mozilla.org/show_bug.cgi?id=283902
  [1]: http://www.alvit.de/blog/article/20-best-license-free-official-fonts "Vitaly Friedman's blog"
  [2]: http://www.sil.org/~gaultney/research.html
  [3]: http://webtypography.net/
  [4]: http://www.fontbureau.com/fonts/Hightower/styles
  [5]: http://www.crazydiamond.co.uk/fonts/rustic.html
  [6]: http://www.typography.com/catalog/hoeflertext/
  [7]: http://www.w3.org/TR/REC-CSS2/visudet.html#min-max-widths
  [8]: http://www.quirksmode.org/css/condcom.html
  [9]: gentium-test.html
  [10]: gentium-test.png
