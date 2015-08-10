Title: Pictures of Words
Date: 2015-08-07
Topics: idea stupid pow

Rather than bemoaning the bandwidth wasted and accessibility thwarted by the
modern habit of posting pictures of text online, often as a way to get
around the character-count limit on Twitter, let’s design an image format
designed expressly for pictures of words.

Just for fun we will call is Picture of Words, with file names ending in
`.pow`.


# Requirements

The criteria for this are simple enough:

- compact (at least when gzipped)
- easy to see how to translate to HTML and to PNG
- as safe as a bitmap image:
    - non-interactive
    - no way to embed executable code or scripts
    - no embedded numbers that can be used to break the stack of careless decoders
- formatting need not be included if writer does not want to
- formatting need not be adhered to if reader does not want to

The last point is to allow font substitution, and also for reflowing paragraphs
on differently sized screens.

Here is a list of things that are NOT required:

- sectioning
- pagination
- multi-column layouts
- layout generally

There are plenty of structured document formats out there—HTML being the
obvious option—and this format is not intending to replace them.


# How it would work

## Support in readers

Most browsers and other programs that consume or display images will have some
generic pipeline that, given a URL or file name, produces an object
representing the image. It will then add this to the display list for the page
(or whatever) and eventually display it at a particular size. Whether POW is
easy to implement or not will depend on the details of how image objects are
represented.

If image objects are raster data divorced from their original file—like
`Image` instances in [Pillow][] for example—then it will be hard to implement
POW well. The expedient solutuion will be to have the POW loader create a
high-resolution raster when it is first loaded, which gets resampled when the
image is displayed.

On the other hand, programs that understand SVG images will probably have an
image abstraction  designed  so that objects can be asked to draw themselves
at a given size without necessarily exposing a pixel-based API. POW files will
then appear as just another vector format.


## Server-side support on web sites

HTTP servers can in principle use [content negotiation][2] so that, in
principle, a browser that requests a resource backed by a POW file instead
gets an SVG or PNG equivalent.  A server could have a POW-to-PNG converter
that runs on the fly when servers do not advertise POW support.

The trick here is that most browsers rather boldly claim to accept *all* image
formats (by including `image/*` in the `Accept` header), rather than
enumerating the ones they actually can process.


## Creating POW files

Pictures of words tend to be created by screen-grabbing text displayed in a
browser. There are two ways this could be changed to make POWs easy to create:

- Browsers could have a tool for marking a section of the page and extracting it as POW or PNG;

- Pages could have JavaScript that lets the reader highlight a quote and extract it as POW.

You could also easily create a tool that takes text—either pasted from another
app or from a file—and previews it as a POW and saves it as such.

This is alas! the weakest point in any attempt to make POW an alternative to
PNGs of text: almost any method is likely to be less convenient that mashing
the screenshot key and pasting it in to a graphics editor.


# Appendix: Initial ideas for POW format

Here I am outlining the first cut of a spec for this format. While I don’t
necessarily think this will be picked up by the W3C and take over the world,
it is fun to work out how it might work.

My first thought was one could define a subset of HTML (or XML) and CSS and
then the POW file would be a ZIP archive containing 3 files `text.html`,
`text.css` and `version.txt`. The main problems with this approach are that
first, it is less compact than it might be, and second, it will tempting to
implement it in ways that invite security vulnerabilities. For this reason I am
thinking of a format that maps on to HTML but is not quite HTML.

A POW file will consist of a JSON document containing the following attributes:

- `content` (required)
- `style` (optional)

When serving these files they should use a `gzip` or similar transfer encoding
to minimize the network bandwith required.

The `content` attribute is a single string. This in turn is to be formatted
conceptually two steps: _block structure_ and _inline structure_ (borrowing terms
from CSS).


## Block structure

Block structure is denoted entirely using newline characters:

- One newline is a break within a paragraph;
- Two newlines separates paragraphs; and
- Three newlines represents a section break or big dramatic unstructured pause.

The newline sequence may be interleaved with horizontal white-space, which is
ignored. For example, here is a complete POW file containing a 2-paragraph
excerpt:

    {
        "content": "Hello world\n\nSecond paragraph"
    }

JSON does not allow newlines in strings, so the newlines are represented as `\n`.

A triple newline is used for cases when people want to leave a big gap before
the punchline of a joke. Any number of newlines over three can be treated as a
triple newline.


## Inline structure

The text of paragraphs is character data. As seen in the previous example, it
can often just be the text. It can also include simplified HTML-like tags.
More formally, a paragraph comprises one or more partial paragraphs separated
by single newlines, where a partial paragraph consists of a non-empty sequence
of any of the following:

- Any characters other than newline, `<`, or `&`;
- An start-tag like `<i>`;
- A end-tag like `</i>`; and
- The special sequences `&lt;`, `&amp;`.

A start-tag consists of the following sequence:

- Left angle bracket `<`
- The tag’s *t-name*
- Optionally one or more *c-names*, each introduced by a full stop `.`
- Right angle bracket `>`

The simplest form, `<i>` looks like an HTML tag, but note that there are no
attributes; instead, the optional c-names can be used analogously to CSS
classes, so that `<a.btn>` is a bit like `<a class="btn">`.

Tag names don’t have to be the same as HTML names.

An end-tag looks like an HTML end tag so consists of the following:

- Left angle bracket and slash `</`
- The tag’s t-name
- Right angle bracket `>`

Both t-name and c-name are case-insensitive names.

Examples:

    Text containing <i>start tag and </i>end tag.

    Text containing <hl>highlighted text <i>with italics</hl> continuing
    outside the highlighted part</i>.

    Text containing <c.red>red</c>, <c.green>green</c>,
    and <c.blue>blue</c> text.

There is no requirement that start- and end-tags be nested properly. It is
fairly easy to construct an algorithm whereby processors should convert a
paragraph into nested ranges using the following transformations:

1. `</a></b>` → `</b></a>`  (permuting adjacent end-tags)

2. `</a>`_X_`</b>` → `</b></a><b>`_X_`</b>`  (splitting overlapping range)

3. _X_`</a>` → `<a>`_X_`</a>`  (implicit start tag for unmatched end tag)

3. `</a>`_X_ → `<a>`_X_`</a>`  (implicit end tag for unmatched start tag)

Ranges to not span multiple paragraphs, but the rules for implying start and
end tags means you get an equivalent same effect.


## Style

Having greatly overthought the content format, I have not given as much
attention to the styling. It might be that a subset or profile of the CSS
syntax can be used.

Only a subset will be required because

- only inline styles are supported; and
- the only selectors are the t-names and c-names of tags (no attributes or pseudo-classes).

Given the limitations n what can be tagged, it should be enough to only allow single-tag selectors.

If there is no `style` element then it might be defaulted to something like the following:

    i, em {
        font-style: italic
    }
    b, strong {
        font-weight: bold;
    }
    tt, code {
        font-family: monospace;
    }
    u {
        text-decoration: underline;
    }
    hl {
        background-color: #FF8;
    }

Styles are optional. Font-family styles are especially optional and webfonts
(if supported at all) are probably a bad idea, since we don’t really want an
image format to be dependent on other resources and downloading fonts might
present security risks.

  [Pillow]: https://pillow.readthedocs.org/
  [2]: https://en.wikipedia.org/wiki/Content_negotiation
