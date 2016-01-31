Title: Inline SVG in HTML5
Topics: svg html5 meta
Date: 2016-01-30

In my quest to reduce the bandwidth used by my blog entries, I have
reduced the user-pic from 42&thinsp;KB to 6&thinsp;KB using inline
SVG.

One of the things I wanted to do was have a border on the image that
was neither rectangular nor elliptical but instead some approximation
to a [superellipse][].

The significance of rectangles and ellipses is they are shapes you can
do easily in CSS by setting `border-radius` but having no actual
border, since CSS borders have the side effect of clipping the
content of the box.

The other usual way to do non-rectangular images it to use a PNG
file, so you can use the alpha channel to make the part of the image
outside the desired shape transparent (since JPEG does not have an
alpha channel). The downside with using this with a photograph is
that PNG does not compress photos as well as JPEG does.

My solution is to use [SVG][] to apply a clipping path to the JPEG
image, using something like this:

    <svg xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            width="100%" height="100%"
            viewBox="-1 -1 2 2">
        <defs>
            <clipPath id="s">
                <path d="M1,0 C1,1 1,1 0,1 S-1,1 -1,0 -1,-1 0,-1 1,-1 1,0Z"/>
            </clipPath>
        </defs>
        <image x="-1" y="-1" width="2" height="2" clip-path="url(#s)"
            xlink:href="byantonia-s96w.jpeg"/>
    </svg>

The gist of this is that the image has a clip path set to the one in
the `defs` section. This uses a cubic [Bézier][] (the `C` command in
the `path`) with control points at the corners of the square (3, 3)
to represent on quarter, then three `S` commands to repeat this for
the other three quarters. I can’t be bothered to work out how much
this is or isn’t a match for a genuine superellipse: it looks good
enough for my purposes.

<div class="image-near-full-width">
    <svg xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            width="200px" height="200px"
            viewBox="-40 -40 80 80">
        <path d="M30,0 C30,30 30,30 0,30 S-30,30 -30,0 -30,-30 0,-30 30,-30 30,0Z"
            stroke="#B0A" stroke-width=1 fill="rgba(176, 0, 170, 0.25)"/>
        <path d="M-40,0 H40 M0,-40 V40" stroke="rgba(0, 0, 0, 0.5)" stroke-width="0.5"/>
        <text x="31" y="6" text-anchor="begin" font-size="6" fill="rgba(0, 0, 0, 0.8)">1</text>
        <text x="-31" y="6" text-anchor="end" font-size="6" fill="rgba(0, 0, 0, 0.8)">&minus;1</text>
        <text x="-1" y="-32" text-anchor="end" font-size="6" fill="rgba(0, 0, 0, 0.8)">1</text>
        <text x="-1" y="36" text-anchor="end" font-size="6" fill="rgba(0, 0, 0, 0.8)">&minus;1</text>
    </svg>
</div>


With modern browsers this can be embedded directly in the HTML of the
page, which is convenient because it means I can use Django‘s
`static` tag to get the URL of the image file correct.

The right-sized JPEG image (96&thinsp;&times;&thinsp;96 pixels) is
5.6&thinsp;KB (compared with 42.3&thinsp;KB). The `svg` fragment is
slightly longer than the `img` tag it replaces, sadly, but only by a
few hundred bytes. Overall this shaves a little more than 36&thinsp;KB
from the first view of my blog pages.


  [superellipse]: http://www.piethein.com/page/superellipse-24/
  [SVG]: https://www.w3.org/TR/SVG/
  [Bézier]: https://en.wikipedia.org/wiki/Bézier_curve
