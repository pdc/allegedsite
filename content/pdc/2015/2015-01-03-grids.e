Title: Responsive Grids of Cards with Less CSS
Date: 2015-01-03
Topics: css less

One of the problems with CSS is that you can do most layouts in many different
ways, because most layouts only work by accident.  The trick is to find a way
to get the effect you want that is reasonably clear to future readers of the
code and adaptable to different viewport widths without introducing an
excessive number of overriding definitions.

[Less][4] is a CSS preprocessor. It acts as an extension to the CSS syntax. The main features I am using on this page are:

- [Variables][5]
- [Nested rules][6]

The Less fragments in this article can be straightforwardly turned in to CSS if you are not using Less.



# Grids Intro

Skip this section if you already know CSS!

A common design pattern in sites is laying out ‘cards’ in a grid or fitted
together in some similar masonry-like pattern. There is no CSS directive that
says ‘lay these out in a grid’; instead we must  abuse the `float` property,
originally designed to insert a diagram in to science papers with the text
flowing around it.  If we get the widths, heights and margins of the cards
just right, the floating algorithm will lay them out the way we want. Getting
the calculations wrong by a single pixel’s width generally destroys the layout
and looks like a total mess.

The HTML can be anything you like but it seems to me the semantic approach is
to use `ul` and `li` elements, since the grid is really just a list of items
laid out in a particular way:

    <ul class="card-list">
        <li>
            <div class="card">…</div>
        </li>
        <li>
            <div class="card">…</div>
        </li>
        …
    </ul>

The CSS sets them all to float left and be 1/3 the width of the available
space. When using Less you can make this relationship explicit by using nested
definitions and the `percentage` function:

    .card-list {
        margin: 0 auto;
        padding: 0;
        width: 600px;

        > li {
            display: block;
            float: left;
            margin: 0;
            padding: 0;
            width: percentage(1/3);
        }
    }

This lays out the items in a grid with no gaps: see [example&nbsp;1][1]. (For this
example I am using big numbers to stand in for the real content, which might
be a picture and link to another site or a short article or whatever.)

Suppose the PSD you are trying to match shows gaps between the cards. Suppose
further that under interrogation the designer has admitted that the intention
is that the gutter between cards should be fixed in size (since it depends on
the text size) and the cards be the same width as each other. The simplest way
to achieve this is to make the size of the containing box wider than the
visible width of the grid:

    @gap: 30px;

    .card-list {
        …
        width: (600px + @gap);

        >li {
            …
        }
    }

    .card {
        margin: (@gap / 2);
    }

Extending the width of the list container means we can set the margins to be
symmetrical and consistent.  The extra space is invisible to the viewer.  See
[Example&nbsp;2][2]



# Responding to Viewport Width

Now we want to adapt this idea to work with different viewport sizes. The
first thing to do is interrogate the designer some more to get them to specify
minimum and maximum desirable sizes for the cards. (Generally you have to do
this by measuring their iPhone mock-ups since designers cannot communicate
using language.)  If a grid item contains a paragraph of text then this might
be 240&thinsp;px to 440&thinsp;px, say, whereas if it contains a picture it
might be entirely rigid so as to avoid rescaling the image.

With Less we can state these assumptions explicitly. Let’s assume for now that
the gap remains consistent and that the minimum outer gutter is _gap_/2.

    @gap: 30px;
    @card-min: 160px;
    @card-max: 200px;

In our example, the values of _card-min_ and _card-max_ are quite close
together because we want the cards to be roughly square in proportion.

Starting from the smallest viewport size and working upwards, we can see that
the minimum width at which there will be two cards per row is 2 &times; (_gap_
+ *card-min*). Within that range, the widest the container can be is the width
of a single card: (_gap_ + *card-max*).  We can generalize this to 2 and
3-column layouts. Our imaginary designer has divulged that in this page the
maximum number of cards per row should be 3 (since our six cards will always
make a grid that way).

With Less we can embed the media-queries within the description of
`.card-list` so that the entire story of how the it changes is in one place:

    .card-list {
        margin: 0 auto;
        padding: 0;

        >li {
            display: block;
            float: left;
            margin: 0;
            padding: 0;
        }

        // Adjust number of cards per row according to viewport size:
        @media (max-width: (2 * (@card-min + @gap) - 1px)) {
            max-width: (@card-max + @gap);

            > li {
                width: 100%;
            }
        }
        @media (min-width: (2 * (@card-min + @gap)))
                and (max-width: (3 * (@card-min + @gap) - 1px)) {
            max-width: (2 * (@card-max + @gap));

            > li {
                width: percentage(1/2);
            }
        }
        @media (min-width: (3 * (@card-min + @gap))) {
            max-width: (3 * (@card-max + @gap));

            > li {
                width: percentage(1/3);
            }
        }
    }

This is [Example&nbsp;3][3]. If you are reading this on desktop you can drag
the border of your browser around to see the different layouts. On Google
Chrome there is an option to emulate different phone layouts.

I have designed the media queries to be non-overlapping (which is why I
subtract 1&thinsp;px in the _max-width_ constraints—browsers round to the
nearest pixel before making the comparison, so fractional pixels caused by
retina displays are not an issue).  This has a couple of nice properties, one
of which is that we are not relying on the CSS cascade to overriding one `max-
width` specification with another, which is probably fractionally more
efficient.

You will also notice that I don’t have a phone, pad, and desktop layout;
instead the size and layout of the grid is defined by the needs of the content
and the available space. As it turns out on an iPhone 5 you see one card per
row in portrait and two in landscape, whereas if you have an iPhone 6 Plus you
will see two across in portrait and three in landscape—it adapts to the
greater available space on the larger viewport.



# More Complicated Margins

The biggest assumptions left are these:

- it is acceptable for the invisible outer gutter around the matrix of cards to have width _gap_/2;

- the height of the cards are all the same.

But that’s a story for another time.


  [1]: http://static.alleged.org.uk/pdc/2015/grid1.html
  [2]: http://static.alleged.org.uk/pdc/2015/grid2.html
  [3]: http://static.alleged.org.uk/pdc/2015/grid3.html
  [4]: http://Lesscss.org/
  [5]: http://Lesscss.org/features/#features-overview-feature-variables
  [6]: http://Lesscss.org/features/#features-overview-feature-nested-rules
