Title: Experiments with Large Banner Photos
Topics: photography css
Date: 2014-07-26

It has become fashionable to head an article with an edge-to-edge banner
photo. I have been thinking about how I might make this work with as little
CSS and JavaScript as possible.

# The Problem

It is easy to design a mock-up with a landscape picture stretched acrtoss the
top. The trick for the person building the page is that you don’t know how
wide the viewport will be: your page might be being viewed on anything from a
phone with a nominal 320-px-wide display to a desktop screen that is
1920&thinsp;px wide.  Even this broad range omits the 2560-px Apple 30&Prime;
display, on the grounds that surely no-one runs web browsers full-screen on
such a beast, and tiny screens like my old phone (240&thinsp;px).

Here is a range of screen sizes. I have given the sizes in CSS units (px), which is the same as pixels for desktop monitors but one-half the actual pixel count on Apple’s Retina displays. To reduce the number of sizes I have only included screens on current Apple devices:

<blockquote>
<svg width=482 height=282 viewport="-1 -1 482 282">
    <g transform="scale(0.25)" stroke="#123" stroke-width="4" fill="none">
        <rect x=0 y=0 width=1920 height=1080 fill="#FAFBB0" stroke="none"/>
        <rect x=0 y=0 width=1920 height=400 fill="#AB0" stroke="none"/>
        <!-- Thunderbolt, 27" iMac 2560x1440 -->
        <!-- HD, 21.5" iMac 1920x1080-->
        <rect x=0 y=0 width=1920 height=1080  fill="none"/>
        <!-- 15" MacBook Pro, 13" MacBook Air -->
        <rect x=240 y=0 width=1440 height=900 fill="none"/>
        <!-- 13" MacBook Pro -->
        <rect x=320 y=0 width=1280 height=800 fill="none"/>
        <!-- 11" Macbook Air 1366x768 -->
        <rect x=277 y=0 width=1366 height=768 fill="none"/>
        <!-- iPad 1024x768 -->
        <rect x=448 y=0 width=1024 height=768 fill="none"/>
        <rect x=576 y=0 width=768 height=1024 fill="none"/>
        <!-- iPhone 1136x640 -->
        <rect x=676 y=0 width=568 height=320 fill="none"/>
        <rect x=800 y=0 width=320 height=568 fill="none"/>
    </g>
</svg>
</blockquote>

The green rectangle represents a banner photo that is 400px tall, a big dramatic banner with the title of the article or portfolio or whatever superimposed. (The iPhone-sized screen would need a different layout, but we can treat that as a special case.)

The simplest way to do this is to make the banner background be a very wide
strip 1920&thinsp;px or more wide and 400&thinsp;px tall. All of the image
outside of the viewport will be clipped in the usual way. Only the middle is
guaranteed to be visible, so a symmetrical, centred composition is required.
I have created [a simple demostration page][Experiment 0] to try out the
banner at different widths.  You can change the width of the first one by
varying your window width (if you are viewing it on a desktop or notebook
computer).

There are two main problems with this approach. First, you need a very wide
image—not an issue it it is commissioned for the banner, but it might make
using an image that starts more conventionally cropped difficult. Second, the
slice does not narrow down to a decent portrait-style composition.


## Responsive Composition

Here is an approach that uses a taller image, closer to the original
proportions, and a couple of extra CSS properties, the well-known
`background-position` and the less-well-known
magical value `cover` for `background-size`.
I have created a test page, [Experiment I][]. It has CSS along these lines:

    background-image: url(bg-1920a.jpeg);
    background-position: 67% 67%;
    background-size: cover;

The special value **`cover`** for `background-size` means that when the page is
wide it scales the image to just as wide as the page and then clips the top
and bottom, and when it is narrower it scales the picture to the height of the
banner area and then clips the sides.


<blockquote>
<svg width=482 height=282 viewport="-1 -1 482 282">
    <g transform="scale(0.25)" stroke="#123" stroke-width="4" fill="none">
        <rect x=0 y=0 width=1920 height=1080 fill="#AB0" fill-opacity="0.5" stroke="none" />
        <rect x=0 y=300 width=1920 height=480 fill="#AB0"/>
        <text x=16 y=360 font-size="52" stroke="none" fill="#123">1920&#xD7;480</text>
        <text x=16 y=60 font-size="52" stroke="none" fill="#123">1920&#xD7;1080</text>
    </g>
</svg>

<svg width=482 height=204 viewport="-1 -1 482 204">
    <g transform="scale(0.25)" stroke="#123" stroke-width="4" fill="none">
        <rect x=0 y=0 width=1440 height=810 fill="#AB0" fill-opacity="0.5" stroke="none" />80 fill="#AB0"/>
        <rect x=0 y=165 width=1440 height=480 fill="#AB0"/>
        <text x=16 y=225 font-size="52" stroke="none" fill="#123">1440&#xD7;480</text>
        <text x=16 y=60 font-size="52" stroke="none" fill="#123">1920&#xD7;1080 scaled to 1440&#xD7;810</text>
    </g>
</svg>

<svg width=482 height=122 viewport="-1 -1 482 122">
    <g transform="scale(0.25)" stroke="#123" stroke-width="4" fill="none">
        <rect x=0 y=0 width=853 height=480 fill="#AB0" fill-opacity="0.5" stroke="none" />80 fill="#AB0"/>
        <rect x=42.5 y=0 width=768 height=480 fill="#AB0"/>
        <text x=60 y=120 font-size="52" stroke="none" fill="#123">768&#xD7;480</text>
        <text x=16 y=60 font-size="52" stroke="none" fill="#123">1920&#xD7;1080 scaled to 853&#xD7;480</text>
    </g>
</svg>
</blockquote>

The `background-position` property is set to  `67% 67%`. This means that the
point in the picture where his fingers are manipulating the gold leaf appears
at the same relative position (two-thirds across and two-thirds down).

<blockquote>
<svg width=482 height=204 viewport="-1 -1 482 204">
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
    <g transform="scale(0.25)" stroke="#123" stroke-width="4" fill="none">
        <rect x=0 y=0 width=1440 height=810 fill="#AB0" fill-opacity="0.5" stroke="none" />80 fill="#AB0"/>
        <rect x=0 y=221 width=1440 height=480 fill="#AB0"/>
        <line x1=960 y1=0 x2=960 y2=542.7 marker-end="url(#Triangle)" />
        <line x1=990 y1=221 x2=990 y2=542.7 marker-end="url(#Triangle)" />
        <line x1=0 y1=542.7 x2=960 y2=542.7 marker-end="url(#Triangle)" />
        <line x1=0 y1=572.7 x2=960 y2=572.7 marker-end="url(#Triangle)" />
        <line x1=960 y1=602.7 x2=960 y2=542.7 stroke-width=1 />
        <line x1=960 y1=542.7 x2=1020 y2=542.7 stroke-width=1 />
        <text x=1030 y=434 font-size="52" stroke="none" fill="#123" >67% of viewport</text>
        <text x=930 y=360 font-size="52" stroke="none" fill="#123" text-anchor="end">67% of image</text>
    </g>
</svg>
</blockquote>

In this
case I am aiming to keep this point at one of the rule-of-thirds
intersections; for a different image (See [Experiment II][]) one would choose
these percentages differently.

## Practical?

In practice I would want to combine this technique to substitute smaller image
files for smaller screens, not in order to control the layout, but to reduce
needlessly consuming download bandwidth. The smallest screen size
(corresponding to phones) would probably require a custom backdrop treatment.

Nevertheless this approach could make it possible to have a reasonable
composition at a variety of viewport sizes with only a minimum of custom CSS
properties—those percentage lengths used for `background-position`—which might
make it possible to use it for images used for blog posts etc., without
requiring CSS code from the editor.  It might even be possible to have a crop
UI that lets the editor choose a focus point in the image to save them typing
in numbers.







  [Experiment 0]: http://static.alleged.org.uk/pdc/2014/responsivebg/x0.html
  [Experiment I]: http://static.alleged.org.uk/pdc/2014/responsivebg/x1.html
  [Experiment II]: http://static.alleged.org.uk/pdc/2014/responsivebg/x2.html
