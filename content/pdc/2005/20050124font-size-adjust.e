Title: No font-size-adjust yet
Topics: css safari mozilla
Icon: ../icon-64x64.png
Date: 20050124

Today I have tweaked the CSS for the new look slightly: subheadings
within articles no longer live in the left margin, and italics have gone
a little curlier. 

I decided to try doing something silly with the type face, which is
to
mix a sanserif body font with italics from a completely different
family. This is partly because the italics for Futura are extremely
subtle, and also seem out of scale with the roman, and partly as a sort
of stylistic flourish.

Here's what it looks like on my system: 

<blockquote>
<img src="futura+cochin.png" width="354" height="115" alt="(screen
shot)" border="1" />
</blockquote>

Most of the words are in Futura Medium (if your computer happens to have
that font). The italics ('and other packages...') are [Cochin
Italic][2]. The trick is, Cochin has a smaller _x_-height than Futura
(at least, than the version 
shipped with Mac OS X: [versions closer to the 1928 original][3] would
have a smaller _x_-height). As a result, if you juxtapose 10-point
Futura Medium and Cochin Italic, the lowercase letters will be different
sizes.

When I wrote style files for TeX, I solved this problem by creating
boxes with an _x_ in in each font, so as to measure their respective
heights, and magnify the smaller font accordingly.
[CSS2 has an equivalent of this][4]: the property `font-size-adjust`. In this
case I think I should be able to put the following in my CSS:

<pre>
em, i, cite {
	font-family: NONEXISTENT, Cochin, serif;
	font-size-adjust: 0.470;
	font-style: italic;
}
</pre>

The value 0&middot;470 is the _x_-height of Futura (which I found by Googling
for <code>[futura XHeight AFM][5]</code>). Cochin has an _x_-height of 0&middot;392, so
this should have the effect of magnifying it by
0&middot;470/0&middot;392 = 1&middot;20. 

But, alas! no web browser I have tried this in groks `font-size-adjust`,
so this has no effect. For now I am fudging this by replacing
`font-size-adjust` with `font-size: 1.20em` (in other words, magnifying
the font unconditionally). On computers with both Futura and Cochin
available, this works fine. On computers that must substitute other
fonts, the sizes will probably be even more out of whack than before.

Really what I should do is choose a different set of fonts.

**Update** (2005-02-06).  I have now given up on using Futura as body
font because I cannot specify it in a cross-platform fashion. Also, I
was struggling to come up with a sensible typographic alternative to use
for computer text. 
Instead I
am using a very conventional combination of serif font for the body,
with sanserif for computer text and headings.  



  [2]: http://www.linotype.com/12889/cochinbolditalic-font.html#more
  [3]: http://www.castletype.com/screen_showings/futura_ct_medium.html
  [4]: http://www.w3.org/TR/REC-CSS2/fonts.html#font-size-props
  [5]: http://www.google.co.uk/search?hl=en&q=futura+AFM+XHeight&btnG=Search
