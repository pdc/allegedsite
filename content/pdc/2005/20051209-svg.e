Date: 20051209
Icon: ../icon-64x64.png
Title: More on Firefox SVG
Topics: svg firefox

Since I wrote my ['First Impressions of Firefox 1.5B1'][1], [Jeff
Schiller][2] has written a ['Guide to Deploying SVG with HTML'][3], with
some workarounds for differences between the Firefox and Adobe views of
how compound documents work. He has also [linked][5] to the [Compound
Document Formats][4] working group at the W3C, whose mission is to sort
out some of the confusion caused by the glib assumption that we can just
mix XML document formats together and Namespaces will sort it out.

He also mailed me a pointer to [SmilScript][6], a JavaScript library
(available under the Artistic licence from [Vectoreal][7]) that scans
your SVG file for SMIL declarations and then goes the specified
animation itself using the time-honoured JavaScript methods involving
timers and mutating the DOM. Alas! for at least some of my existing SVG
files (such as the Flickr badge shown on my home page), this will not
yet provide the whole answer---I use features like the `keyTimes`
attribute that SmilScript does not understand (yet).

In the meantime, I have belatedly changed my Flickr badge so that in the
absence of any declarative animation, it shows the most recent image.
This is way better than just showing a black square!

<blockquote>
 <embed src="../2004/flickr-badge.svg" type="image/svg+xml" width="120" height="120" />
</blockquote>

**Update (10 Dec.).** To get rid of the gratuitous scrollbars
(Mozilla bug [288276][]), 
I have munged the SVG for the Flickr badge so that
it starts with

    <svg xmlns="http://www.w3.org/2000/svg" 
    	xmlns:xlink="http://www.w3.org/1999/xlink" 
    	viewBox="0 0 200 200" width="100%" height="100%">

in other words, its natural height and width are both 100%. This causes
it to display correctly in Firefox 1.5, and hopefully won't break it in
Adobe SVG Viewer. It also means that if you right-click and choose
This Frame &rarr; Show Only This Frame (Firefox) or View SVG (Adobe),
then you see a gigantic badge (full window size) rather than a more
reasonable size. But that is not much of a problem.

  [1]: 09/09.html "First Impressions of Firefox 1.5 BETA1"
  [2]: http://blog.codedread.com/ "Jeff Schiller's blog"
  [3]: http://blog.codedread.com/archives/2005/12/01/guide-to-deploying-svg-with-html/
  [4]: http://www.w3.org/2004/CDF/
  [5]: http://blog.codedread.com/archives/2005/11/22/compound-document-formats-third-working-draft/ "Compound Document Formats - Third Working Draft"
  [6]: http://www.vectoreal.com/smilscript/ "Vectoreal :: SmilScript"
  [7]: http://www.vectoreal.com/
  [288276]: https://bugzilla.mozilla.org/show_bug.cgi?id=288276
