Title: SVG works with FireFox 1.0 on Mac OS X
Icon: ../icon-64x64.png
Topics: svg firefox 
Date: 20041114

More than once I have moaned about the lack of useful SVG support in
Mozilla browsers such as FireFox. I installed FireFox 1.0 on my PowerBook this morning,
and when I visited my front page I was surprised and delighted to see
that the SVG graphics *are* being displayed!

<embed src="firefox-logo.svgz" type="image/svg+xml" width="120"
height="120" alt="(logo)" align="left" />
The FireFox logo to the left of this paragraph is [an SVG version][1]
that weighs in at 12K bytes. Not bad for a fairly detailed image with plenty of graduated tones.
If you see a firey fox flying around a big
blue marble, then SVG works on your browser, too (otherwise FireFox
shows a yellow panel at the top of its window saying you need a
plug-in).  You can do the usual SVG stuff like dragging the mouse with
Control (or the Command key &#x2318; on a Mac) to zoom in and with Alt
(or Option &#x2325;) to pan. More importantly (from my point of view),
on [my front page][2], the [Flickr badge][3] works, complete with declarative animation.

There is one tiny annoyance: the CSS layout is ignored for `embed`
elements ([Mozilla bug 236089][5], I think).

But this is a minor niggle. I am really chuffed that SVG is displayable
on Mozilla FireFox (even if only on Mac OS X). I still have ambitions to
do a comics entirely in SVG (using some SVG-savvy drawing program rather
than crazy old Corel Painter 8). One day...




  [1]: http://svg.org/?op=displaystory;sid=2004/10/25/221710/41 
  [2]: ../
  [3]: http://www.flickr.com/
  [4]: ../../../2005/percy/ 
  [5]: https://bugzilla.mozilla.org/show_bug.cgi?id=236089
  [6]: http://www.w3.org/TR/2001/REC-SVG-20010904/linking.html#Links
  [7]: http://www.w3.org/TR/SVG/struct.html#xlinkRefAttrs
  [8]: http://www.w3.org/TR/xmlbase/
  [9]: http://www.adobe.com/svg/
