Title: Redesign for my moribund web site
Topics: css
Date: 20050122
Icon: ../icon-64x64.png

After months of apparent inactivity, you may have noticed that I have
redesigned my site. At least, I have changed the visual design: the
navigation is unchanged for now. Mostly the changes are in the CSS.

I had two things I wanted to do.
First, to create a light-on-dark design (I have long been impressed by
John Gruber's pleasingly simple design for [Daring Fireball][2]), and,
second, to work out a proper grid-based layout, one with a
minimum of lines and graphics, focussing on the text. The latter is something
I've had in mind for a while, but my interest was rekindled by [Khoi
Vinh][3]'s web site [Subtraction][4], which has a visual design based
purely on typography, with almost no graphics or even colour.

Grid design
-------

I know what little I know
about grids from when was reading up about typography back when I was a
student, and later, as I worked for the University. I did my best to
realize magazine-style layouts in [TeX][5] by writing my own output
routines. I even designed a font family, [Malvern][6] ([documentation
in TeX format][7]). The folly of youth, eh?

There are plenty of ways to lay out information on a page that do not
use an explicit grid.  Making the results harmonious and readable can be
a fine art and it probably helps to be a properly trained graphical
designer using a decent typesetting package like InDesign or Quark
XPress. Since I'm not, and I don't, I need a system.
The point of grids is that it is a system for creating page layouts
quickly without going too far wrong---important when designing
magazine pages, where deadlines are always snapping at one's heels, or
when you're an amateur like me.

The first step is changing the layout so that horizontal positions
respect a grid of 9-em-wide cells with 1 em of space between
them. (All the measurements are in em so that if you change the font
size, the layout expands or contracts accordingly.) For example, the
date to the left of the article fits in to the box that extends from 1
em to 10 em (measured from the left edge). The article text is three
cells wide, ranging from 11 em to 40 em. Depending on the width of your
browser window and the size of the font, there may be additional columns
in cells 4, 5 and 6.

Achieving this in CSS turned out to be simple enough once I had decided
to do it all through floats (there is no absolute positioning). The body
is 40 em wide and floated left; within the body, most paragraphs have 11
em of left margin, so that the text lines up with the correct imaginary
grid line. The contents of the left column are floats within the body
text; in the original layout, the date was a paragraph with class
`details`, and was shown flush-right and in a small font. Now the same
paragraph class is set to float left and given the correct width.
Because the font size is 0&middot;75 em, I have to give the width as 12
em to have the effect setting it to 9 em, my cell width.

The auxiliary info to the right of the main article automatically adapts
to your window width by forming one, two, or three columns. This works
by the simple expedient of dividing it in to bite-sized chunks and
making each of them the correct width and floated left. Because each of
the pieces is one cell wide, if they all end up being shunted to the
bottom of the page (which happens if you expand the type size enough),
they should line up tidily with the main article. This is the essence of
the grid system.

Colour scheming
-----------------

Blue has always been my signature colour (I have three brothers and
sisters, so our possessions were colour-coded to prevent arguments). The
particular dark blue I ended up using for the background is #123 (meaning the same as
\#112233, i.e., red 17, green 34, blue 51). This isn't web-safe in the
old-fashioned sense, which is something of a departure for me, but it is
[web-smart][8], meaning suitable for any display with thousands of
colours or better.
Originally the text was
also a blue colour (#CCF), but this ended up looking a little to
purplish because of the background it was on, so in the end I switched
to using pale grey for the text.

Colour scheme systems (mono, contrast, triads, etc.) are the equivalent
for colour of the grid system. The simplest (apart from monochrome) is for most of the page to be shades or tints of one colour,
and to use a single contrasting colour for highlights.
My contrast colour (used for links) is my old favourite
\#F90, which is close enough to being the mathematical complement of #123.
Visited links are the bleached-out version #FC9. For the banner at the
top of the main body of the page, I took a photo by [Jenni Scott][9] and
cropped it to approximately the right proportions and then colourized it
with a paler shade of orange (paler to allow for the darker parts of the
photo). I had to do a little slicing and dicing to change the
composition so that my face is turned towards the text rather than away
from it!

HTML changes
------

I did not quite do all this without touching the HTML. First of all, I
created this as a new CSS file rather than replacing the old one; in
Mozilla Firefox, use the View &rarr; Page Style menu to see how the page
looks in the old theme.

Second, in order to move the list of categories from the bottom of the
article to the left column, I had to move it in the HTML as well. I also
changed it from a paragraph with \[...\] wrapped around it to a set of
paragraphs and (in the case of categories) a `ul` (list). (As a result,
it looks a little odd in the old style.) I also changed the order of the
chunks that go in the right-hand side of the page, so that the Flickr
badge does not appear first: this way it does not clash with the picture
introduced at the top of the main text.

There are still a few details to sort out but I think I like the new
look so far.



  [1]: /2005/percy/
  [2]: http://daringfireball.net/
  [3]: http://www.subtraction.com/about/
  [4]: http://www.subtraction.com/
  [5]: http://www.tug.org/ "TeX Users' Group"
  [6]: http://www.tug.org/tex-archive/fonts/malvern/
  [7]: http://www.tug.org/tex-archive/fonts/malvern/doc/maman.tex
  [8]: http://www.ficml.org/jemimap/style/color/wheel.html
  [9]: http://www.comixminx.net/
