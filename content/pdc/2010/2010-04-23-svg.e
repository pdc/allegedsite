Title: Self-Curation and the Fall and Rise of SVG
Topics: svg meta
Date: 2010-04-23

I have started converting my weblog to use a new Django-based system.
The old system used text files, one per entry, to generate static HTML;
the new system uses the same text files as before—warts and all.

<div class="svg svg-left image-left framed framed-4u">
    <embed src="../2001/jeremy-and-damian.svg" type="image/svg+xml"
        width="215.788" height="278.979" />
</div>
Along the way I am uncovering old articles about SVG. Back in 2000, XML
was the future—XHTML was going to replace HTML, SVG was going to replace
Flash, and so on. 

Alas! SVG on the web got set back severely when the working group got
obsessed with mobile phones, and Mozilla Firefox broke compatibility
with Adobe’s SVG Viewer plug-in. It survived, strangely enough, as a
system for producing icons on Gnome and KDE. Since then there has been a
slow, slow, slow, patchy, and slow process of reimplementing SVG on the
web, this time as code in the browser itself, which is nice in some
ways, but it is not a drop-in replacement for old sites using SVG. For
example, to be consistent with how HTML works, SVG images are now
treated as scrollable documents rather than like resizable images. They
also have opaque backgrounds. It follows that almost everything in old
posts of mine like [SVG works with FireFox 1.0 on Mac OS X][1] is
incorrect.

My plan going forward is to modify those pages that include SVG images
to allow for differences in the way embedded SVG works as best I can.
This will be tricky in cases where I used [declarative animation][2] (SMIL). The stick-figure portrait above 
has a simple animation detector: if Jeremy’s hair is purple, you don’t have animation.
If it is green or blue, then stare fixedly at it for five minutes and you should see it gradually change colour.
This shows declarative animation—SMIL—is alive in your browser.
On my Mac, SMIL is alive in Apple Safari and Google Chrome. Alas, not Mozilla Firefox, though
there is even a claim on the Mozilla
Developer Connection that there will be
[SVG animation (SMIL) in Firefox 3.7][10], so I better check again in 2012.


  [1]: ../2004/11/14.html
  [2]: http://www.w3.org/TR/SVG/animate.html
  [10]: https://developer.mozilla.org/en/SVG_animation_(SMIL)_in_Firefox
  [11]: http://webkit.org/blog/138/css-animation/