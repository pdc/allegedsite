Title: Migrating my website workspace, part 2
Image: ../icon-64x64.png
Date: 20041031
Topics: svg python debian http

I am still in [the process of converting my website-maintaining
scripts][4]
to work on [Debian GNU/Linux][2] rather than [Mac OS X][3]. Last episode left me
with a conundrum as how to convert SVG files to PNG for the sake of
browsers that cannot display SVG properly.

This afternoon I revamped my Python script `fetch.py`, used to get
copies of certain external web pages, such as the Atom feed from Flickr.
Fetch already keeps [SHA(1)][sha] hashes of the downloaded resources in
a persistent file, so that the local copies are written ony if the
resource changes; this prevents gratuitous 'recompilation' when I use
Make to rebuild the relevant output files. I extended it to also store
the `Last-Modified` and `ETag` headers, and to reuse these values (as
<code>[If-Modified-Since][ims]</code> and <code>[If-None-Match][inm]</code> headers) the next
time that URI is requested. If the servers return [304][304], this
throws an exception; all I needed to do was make the handler set the
data to None and make the rest of the script skip the saving-to-file
part. Python's shipping 'with batteries' made adding support for
<code>[gzip][gzip]</code> compression easy (insert an <code>[Accept-Encoding][ae]</code>
header in the request and check for <code>[Content-Encoding][ce]</code> in the
response).

With all this in place, it was simple enough to modify my SVG-generating
script so that, when before it would have written a URL of an image in
to the file, it instead fetched the resource to a local file and
subsitituted the name of the file. The result is an SVG that the `rsvg` program can
handle correctly.

The next step was a little annoying. I have not installed `rsvg` on my
Mac OS X machine; Fink does not support it (at least not in Stable), and
I cannot be bothered trying to build it myself. Instead I created a
driver program `svgtopng` that works out which out of Batik and `rsvg`
is available, and creates the correct command-line automatically.  (I
could have done this as a shell script, but in the end it was easier
todo *this* in Python too.)  This way I modify my Makefiles to use
`svgtopng` and it works whether I am on Ariel or Tranq.

There is one little bitty problem: the outputs do not match. Here is the
rendering done with Batik on the Mac:

<blockquote>
    <div>
        <img src="flickr-ariel-20041031.png" width="100" height="50" alt="" />
    </div>
</blockquote>

The version generated with `rsvg` has the image too small (leaving a gap
down one side) and the text has fallen off the side of the icon:

<blockquote>
    <div>
        <img src="flickr-tranq-20041031.png" width="100" height="50" alt="" />
    </div>
</blockquote>

The second of these problems is probably fixable by including more
synonyms for Helvetica (Debian systems doubtless include the URW fonts, which
are metrically compatible). The first may mean that I need finally to
give up on using the <code>[preserveAspectRatio][1]</code> attribute to control how the
aspect ratio is preserved, and do it myself by doing all the positioning
calculations myself. Grrump.

  [1]: http://www.w3.org/TR/SVG/coords.html#PreserveAspectRatioAttribute
  [2]: http://debian.org/
  [3]: http://www.apple.com/uk/macosx/
  [4]: 10/30.html
  [inm]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.26
  [ims]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.25
  [304]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.3.5
  [sha]: http://www.python.org/doc/current/lib/module-sha.html
  [gzip]: http://www.python.org/doc/current/lib/module-gzip.html
  [ae]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
  [ce]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.11
