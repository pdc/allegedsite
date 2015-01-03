Title: Flexible Cards in Grids with less CSS
Date: 2015-01-03
Topics: css

One of the problems with CSS is that you can do most layouts in many different ways, because most layouts only work by accident.



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

The HTML can be anytging you like but it seems to me the semantic approach is
to use `ul` and `li` elements, since the grid is really just a list of items
laid out in a particular way:

    <ul class="number-list">
        <li>
            <div class="number">1</div>
        </li>
        <li>
            <div class="number">2</div>
        </li>
        <li>
            <div class="number">3</div>
        </li>
        <li>
            <div class="number">4</div>
        </li>
        <li>
            <div class="number">5</div>
        </li>
        <li>
            <div class="number">6</div>
        </li>
    </ul>

The CSS sets them all to float left and be 1/3 the width of the available
space. When using LESS you can make this relationship explicit by using nested
defintions and the `percentage` function:

    .number-list {
        margin: 0 auto;
        padding: 0;
        width: 600px;

        >li {
            display: block;
            float: left;
            margin: 0;
            padding: 0;
            width: percentage(1/3);
        }
    }

This lays out the items in a grid with no gaps: see [example 1][1]. (For this
example I  am using big numbers to stand in for the real content, which might
be a picture and link to another site or a short article or whatever.)

Suppose the PSD you are trying to match shows gaps between the cards. Suppoose
further that under interrogation the designer has admitted that the intention
is that the gutter between cards should be fixed in size (since it depends on
the text size) and the cards be the same width as each other. The simplest way
to achive this is to make the size of the containing box wider than the
visible width of the grid:

    @gap: 30px;

    .number-list {
        …
        width: (600px + @gap);

        >li {
            …
        }
    }

    .number {
        margin: (@gap / 2);
    }

Extending the width of the list container means we can set the margins to be
symmetrical and consistent.  The extra space is invisible to the viewer.  See
[Example 2][2]



# Responding to Viewport Width

Now we want to adapt this idea to work with different viewport sizes. The
first thing to do is interrogate the designer some more to get them to specify
minimum and maximum desirable sizes for the cards. (Generally you have to do
this by measuring their iPhone mock-ups since designers cannot communicate
using language.)  If a grid item contains a paragraph of text then this might
be 240px to 440px, say, whereas if it contains a picture it might be entirely
rigid so as to avoid rescaling the image.

With LESS we can state these assumptions explicitly. Let’s assume for now that the gap remains consistent and that the minimum outer gutter is _gap_/2.

    @gap: 30px;
    @card_min: 160px;
    @card_max: 200px;

Starting from the smallest viewport size and working upwards, we can see that
the minimum width at which there will be two cards per row is 2 &times; (_gap_
+ *card_min*). Within that range, the widest the container can be is the width
of a single card: (_gap_ + *card_max*).  We can generalize this to 2 and
3-column layouts. Our imaginary designer has divulged that in this page the
maximum number of cards per row should be 3 (since our six cards will always
make a grid that way).

With LESS we can embed the media-queries within the description of `.number-list` so that the entire story of how the it changes is in one place:

    .number-list {
        margin: 0 auto;
        padding: 0;

        >li {
            display: block;
            float: left;
            margin: 0;
            padding: 0;
        }

        // Adjust number of cards per row according to viewport size:

        @media (max-width: (2 * (@card_min + @gap) - 1px)) {
            max-width: (@card_max + @gap);

            > li {
                width: 100%;
            }
        }
        @media (min-width: (2 * (@card_min + @gap)))
                and (max-width: (3 * (@card_min + @gap) - 1px)) {
            max-width: (2 * (@card_max + @gap));

            > li {
                width: percentage(1/2);
            }
        }
        @media (min-width: (3 * (@card_min + @gap))) {
            max-width: (3 * (@card_max + @gap));

            > li {
                width: percentage(1/3);
            }
        }
    }

This is [Example 3][3]. If you are reading this on desktop you can drag the border of your browser around to see the different layouts. On Google Chrome there is an option to emulate different phone layouts.

I have designed the media queries to be non-overlapping (which is why I
subtract 1&thinsp;px in the `max-width` constraints—browsers round to the
nearest pixel before making the comparison, so fractional pixels caused by
retina displays are not an issue).  This has a couple of nice properties, one of which is that we are not relying on overriding one value with another, which is probably fractionally more efficient.

You will also notice that I don’t have a phone, pad, and desktop layout;
instead the size and layout of the grid is defined by the needs of the content
and the available space.  As it turns out on an iPhone 5 you see one card per row in portrait and two in landscape, whereas if you have an iPhone 6 Plus you will see two across in portrait and three in landscape—it adapts to the greater available space on the larger viewport.

  [1]: /fuckyeahstaticfiles/pdc/2015/grid1.html
  [2]: /fuckyeahstaticfiles/pdc/2015/grid2.html
  [3]: /fuckyeahstaticfiles/pdc/2015/grid3.html
