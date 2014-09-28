Title: CSS and content-outwards versus layout-inwards design
Topics: css
Date: 2014-09-27T13:30+01:00

I had a moment of existential panic this week over an esoteric technical point
t do with out outsourced stylesheets: our builder has set the default box
model to not be `content-box` but `border-box`!  The difference represents the
final end of the original vision of CSS as a content-outwards style language.

By **content-outwards** I mean the way that style sheets were originally
conceived in the content-focussed committees of the W3C in ancient times. The
idea is you start with a piece of text and then describe how you want it laid
out, using a few CSS clauses like the following:

    font-family: alegreya;
    font-size: 12pt;
    width: 36em;

Obviously here the 36em is intended to be the width of the text—the *content*
of the box.

<blockquote>
<link href='http://fonts.googleapis.com/css?family=Alegreya' rel='stylesheet' type='text/css'>
<div style="font: 9px/12px alegreya; width: 36em">
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum tellus tortor, bibendum at sodales ut, convallis eget felis. Praesent volutpat pretium leo eget mollis. Donec et commodo urna, non maximus sem. Integer id dapibus sem, aliquam venenatis nunc. Vestibulum venenatis velit ex, nec lobortis magna bibendum in. Praesent placerat lectus in augue pharetra sodales at aliquet eros. Duis non posuere purus, id varius elit. Nullam mattis, sapien ac dictum vehicula, elit ex efficitur nisl, id dictum justo eros sed elit. Curabitur sit amet tortor quis ex efficitur blandit. Morbi urna eros, blandit at fringilla non, fringilla in eros.
</div>
<svg width="324px" height="18px" viewPort="0 0 324 18">
    <defs>
        <marker id="Triangle"
                viewBox="0 0 12 10"
                refX="12" refY="5"
                markerWidth="6"
                markerHeight="6"
                orient="auto">
            <path d="M 0 0 L 12 5 L 0 10 z" />
        </marker>
    </defs>
    <line x1=0.5 y1=0 x2=0 y2=18 stroke="#000" stroke-width=1 />
    <line x1=323.5 y1=0 x2=323.5 y2=18 stroke="#000" stroke-width=1 />
    <line x1=178 y1=8.5 x2=323 y2=8.5
        stroke="#000" stroke-width=1 marker-end="url(#Triangle)" />
    <line x1=146 y1=8.5 x2=1 y2=8.5
        stroke="#000" stroke-width=1 marker-end="url(#Triangle)" />
    <text x=162 y=12 text-anchor="middle" font-size=9 font-family="Helvetica Neue, Arial, Helvetica, sans-serif">36em</text>
</svg>
</blockquote>


Equally obviously, if you add a frame to the text then the width of the framed
content will be wider than the width of the content. Because we have an
[infinite canvas][1] we a free to add a frame to the text without worrying
about running outof paper. The text might be framed using a CSS snippet like this:

    padding: 2em 3em 4em;
    border: 0.25em solid #900;

The resulting box is (0.25&thinsp;em + 3&thinsp;em + 36&thinsp;em + 3&thinsp;em + 0.25&thinsp;em) = 42.5&thinsp;em wide.

<blockquote>
<link href='http://fonts.googleapis.com/css?family=Alegreya' rel='stylesheet' type='text/css'>
<div style="font: 9px/12px alegreya; width: 36em; padding: 18px 27px 36px; border: 2px solid #900;">
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum tellus tortor, bibendum at sodales ut, convallis eget felis. Praesent volutpat pretium leo eget mollis. Donec et commodo urna, non maximus sem. Integer id dapibus sem, aliquam venenatis nunc. Vestibulum venenatis velit ex, nec lobortis magna bibendum in. Praesent placerat lectus in augue pharetra sodales at aliquet eros. Duis non posuere purus, id varius elit. Nullam mattis, sapien ac dictum vehicula, elit ex efficitur nisl, id dictum justo eros sed elit. Curabitur sit amet tortor quis ex efficitur blandit. Morbi urna eros, blandit at fringilla non, fringilla in eros.
</div>
<svg width="382px" height="36px" viewPort="0 0 382 36">
    <defs>
        <marker id="Triangle"
                viewBox="0 0 12 10"
                refX="12" refY="5"
                markerWidth="6"
                markerHeight="6"
                orient="auto">
            <path d="M 0 0 L 12 5 L 0 10 z" />
        </marker>
    </defs>
    <g transform="translate(29 0)">
        <line x1=0.5 y1=0 x2=0 y2=18 stroke="#000" stroke-width=1 />
        <line x1=323.5 y1=0 x2=323.5 y2=18 stroke="#000" stroke-width=1 />
        <line x1=178 y1=8.5 x2=323 y2=8.5
            stroke="#000" stroke-width=1 marker-end="url(#Triangle)" />
        <line x1=146 y1=8.5 x2=1 y2=8.5
            stroke="#000" stroke-width=1 marker-end="url(#Triangle)" />
        <text x=162 y=12 text-anchor="middle" font-size=9 font-family="Helvetica Neue, Arial, Helvetica, sans-serif">36em</text>
    </g>
    <g transform="translate(0, 18)">
        <line x1=0.5 y1=0 x2=0 y2=18 stroke="#000" stroke-width=1 />
        <line x1=381.5 y1=0 x2=381.5 y2=18 stroke="#000" stroke-width=1 />
        <line x1=211 y1=8.5 x2=381 y2=8.5
            stroke="#000" stroke-width=1 marker-end="url(#Triangle)" />
        <line x1=171 y1=8.5 x2=1 y2=8.5
            stroke="#000" stroke-width=1 marker-end="url(#Triangle)" />
        <text x=191 y=12 text-anchor="middle" font-size=9 font-family="Helvetica Neue, Arial, Helvetica, sans-serif">42&frac12;em</text>
    </g>
</svg>
</blockquote>

A lot of the quirks of CSS can be explained in terms of thinking of web pages as consisting mostly of text with a few style rules attached.

But designers don‘t worth that weay in practice.  A designer looks at the
viewport as a page of a set size, then allocates so much space for the header,
so much for the side-bar,  so much for the content, and so on. Having designed
a layout, they imagine the text being poured in to the gaps they have left for
it, thus **layout-inwards**. This is the paper-oriented model they learned
from Quark XPress or Adobe Indesign—or, more, more likely, that the designers
they learned from learned from, since the current crop of designers have never
designed for paper.

It follows that having decided on a 960-px text column with 10-px padding, it
is annoying for them to have to subtract 20&thinsp;px from 960&thinsp;px to
arrive at the content’s width of 940&thinsp;px. It is even worse if they have
to somehow subtract 20&thinsp;px from 60% if their apporoach to a liquid
layout is to divide the page up in constant proportions. Occasionally this can
require otherwise useless extra elements so you can set the width on one and
the padding on the other or something.

Rather than creating a new property `outer-width` to mean the outer width of the box, the CSS standards people chose to add a new property that changes the
meaning of the existing `width` property:

    font-family: alegreya;
    font-size: 12pt;
    width: 36em;
    padding: 2em 3em 4em;
    border: 0.25em solid #900;
    box-sizing: border-box;

The browser than adjusts the size of the content to make the outer width correct.

<blockquote>
<link href='http://fonts.googleapis.com/css?family=Alegreya' rel='stylesheet' type='text/css'>
<div style="font: 9px/12px alegreya; width: 36em; padding: 18px 27px 36px; border: 2px solid #900; box-sizing: border-box;">
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum tellus tortor, bibendum at sodales ut, convallis eget felis. Praesent volutpat pretium leo eget mollis. Donec et commodo urna, non maximus sem. Integer id dapibus sem, aliquam venenatis nunc. Vestibulum venenatis velit ex, nec lobortis magna bibendum in. Praesent placerat lectus in augue pharetra sodales at aliquet eros. Duis non posuere purus, id varius elit. Nullam mattis, sapien ac dictum vehicula, elit ex efficitur nisl, id dictum justo eros sed elit. Curabitur sit amet tortor quis ex efficitur blandit. Morbi urna eros, blandit at fringilla non, fringilla in eros.
</div>
<svg width="382px" height="18px" viewPort="0 0 382 18">
    <defs>
        <marker id="Triangle"
                viewBox="0 0 12 10"
                refX="12" refY="5"
                markerWidth="6"
                markerHeight="6"
                orient="auto">
            <path d="M 0 0 L 12 5 L 0 10 z" />
        </marker>
    </defs>
    <line x1=0.5 y1=0 x2=0 y2=18 stroke="#000" stroke-width=1 />
    <line x1=323.5 y1=0 x2=323.5 y2=18 stroke="#000" stroke-width=1 />
    <line x1=178 y1=8.5 x2=323 y2=8.5
        stroke="#000" stroke-width=1 marker-end="url(#Triangle)" />
    <line x1=146 y1=8.5 x2=1 y2=8.5
        stroke="#000" stroke-width=1 marker-end="url(#Triangle)" />
    <text x=162 y=12 text-anchor="middle" font-size=9 font-family="Helvetica Neue, Arial, Helvetica, sans-serif">36em</text>
</svg>
</blockquote>

Because of the way CSS works, the `border-box` rule may be nowhere near the
part of the CSS file you are currently looking at. It’s as if when you visit
an art gallery you need to check everywhere for a discreet notice saying
whether the sizes of paintings are of the canvas alone or include the frames. Adding `outer-width` and `outer-height` properties instead would have been much clearer.

Front-end developers get all excited about the `border-box` mode because it better
matches their layout-inwards approach. [Paul Irish’s 2012 article][2] (by a former
developer on [HTML5 Boilerplate][4]) seems to have started [a movement][3]
promoting this change, though at present neither [normalize.css][6] nor
[HTML5 Boilerplate][5] have made it default.

I think the exitensial angst is caused by the fact that as `border-box` gains
momentum I am going to have to re-examine 15 years’ worth of CSS experience
as the underlying fundamentals of what width and height mean are changed.


  [1]: http://scottmccloud.com/4-inventions/canvas/
  [2]: http://www.paulirish.com/2012/box-sizing-border-box-ftw/
  [3]: http://css-tricks.com/international-box-sizing-awareness-day/
  [4]: http://html5boilerplate.com
  [5]: https://github.com/h5bp/html5-boilerplate/issues/1496
  [6]: https://github.com/necolas/normalize.css/issues/202
  [7]: http://www.fontsquirrel.com/fonts/alegreya