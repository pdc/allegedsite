<!-- -*-HTML-*- -->
<entry date="20040214" icon="../tarot/wands-ten-100w.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>The object tag postponed</h>
  <body>
    <p>
      I have belatedly updated <a href="../2002/svg-object.html">my
      note on using <code>object</code> tags to display <abbr
      title="Structured Vector Graphics">SVG</abbr></a> to reflect my
      having <a href="../2003/11/23.html">removed <code>object</code>
      tags from the Alleged Tarot because Safari cannot cope with them.</a>.
    </p>
    <p>
      It is a sad accident of history that HTML has five different
      tags which are used to do the same task: carve out a rectangular
      section of a web page and display a different document
      (resource) there (six if you count frame-sets as HTML documents).
      In each case, there is a foreign resource, and a software
      component (call it a handler for the sake of giving it a name)
      must be found that knows how to display it:
    </p>
	<table>
		<thead>
			<tr valign="bottom">
				<th>Tag</th>
				<th>Resource type</th>
				<th>Handler</th>
			</tr>
		</thead>
		<tbody>
			<tr valign="baseline" align="left">
				<td><code>img</code></td>
				<td>
					PNG, JPEG, GIF, and sometimes other binary image
					formats
				</td>
				<td>built-in</td>
			</tr>
			<tr valign="baseline" align="left">
				<td><code>applet</code></td>
				<td>Java class file (applet)</td>
				<td>Java applet plug-in</td>
			</tr>
			<tr valign="baseline" align="left">
				<td><code>embed</code></td>
				<td>Any</td>
				<td>Plug-in, determined by media-type</td>
			</tr>
			<tr valign="baseline" align="left">
				<td><code>iframe</code></td>
				<td>HTML (or other document types?)</td>
				<td>web browser</td>
			</tr>
			<tr valign="baseline" align="left">
				<td><code>object</code></td>
				<td>
					All of the above
				</td>
				<td>
					Any of the above
				</td>
			</tr>
		</tbody>
	</table>
    <p>
      Now, there was no particular reason for <code>applet</code> and
      <code>embed</code> to exist; they do the same thing as
      <code>img</code>, the only difference being that
      <code>img</code> uses handlers compiled in to the web browser
      whereas <code>embed</code> uses plug-ins and <code>applet</code>
      the Java interpreter (often this is also a plug-in).  Using
      different element names merely exposes an implementation detail
      of that particular implementation.  Netscape could have chosen
      to extend the <code>img</code> tag to dispatch to handlers based
      on the media-type of the referenced resource.
      Apart from anything else, it would have avoided the embarrassing
      period when some web sites used <code>embed</code> to render
      <abbr title="Portable Network Graphics">PNG</abbr>s and others
      used <code>img</code>, depending on the author&rsquo;s
      browser&rsquo;s capabilities.
    </p>
    <p>
      The <code>object</code> tag in theory is a good idea, but has a
      slightly twisted history.  It originated as the ActiveX
      equivalent of <code>applet</code> (with <code>codebase</code>
      and <code>classid</code> attributes), and was later extended to
      take on the duties of <code>img</code>, <code>applet</code>,
      <code>embed</code>, and <code>iframe</code>.  This has left it
      with more than one way to indicate which plug-in is used to
      display its content.  Generally the plug-in should be implied by
      the media-type of the embedded resource (indicated with the
      <code>data</code> attribute):
    </p>
    <pre>&lt;object data="frog.swf" width="400" height="300"
        type="application/x-shockwave-flash"
>
    ...
&lt;/object></pre>
    <p>
      The browser is then responsible for locating a plug-in that
      handles this format.  
      When the <code>object</code> tag was first introduced, it used 
      attributes <code>classid</code> and <code>codebase</code> to
      identify the plug-in explicitly:
    </p>
    <pre>&lt;object classid="clsid:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        codebase="http://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        width="400" height="300" ...
>
    &lt;param name="movie" value="frog.swf" />
    ...
&lt;/object></pre>
    <p>
      The problem here is that it is tying you to a
      particular implementation of Flash, the one for Microsoft
      Windows (ActiveX).  Browsers that do not have support for
      ActiveX controls cannot use this, so cannot display the content.
    </p>
    <p>
      If I&nbsp;were king of HTML for a day I&nbsp;would deprecate
      these funky parameters; they should not be needed.  (The <a
      href="http://www.alistapart.com/articles/flashsatay/">Flash
      Satay</a> article (on A List Apart) describes this as working in
      Gecko browsers and almost working in Microsoft Internet
      Explorer.)  I would consider deprecating the <code>type</code>
      parameter as well; it causes confusion by giving authors the
      illusion of control when in fact the media-type reported by the
      server takes precedence.
    </p>
    <p>
      The <code>object</code> tag has another complication: it might
      or might not be interactive.  HTML has a mechanism for making
      simple images (like GIFs and PNGs) clickable: client-side
      image-maps.  These do not work with, say, applets, because the
      applet plug-in is responsible for handling mouse events, so the
      HTML processor never gets a chance to pass them on to the image
      map.  Presumably the handlers for these images&rsquo;
      media-types will need a special interface that allows them to
      access client-side image-map data.
    </p>
    <p>
      But alas! it will be a while before  we can use
      <code>object</code> elements everywhere, because Safari
      1.0&rsquo;s support is broken.
      The irony is that Safari handles <code>embed</code> really
      well&mdash;they display just like images included with
      <code>embed</code>, which is just as it should be (some other
      browsers get all weird and lay out pages with images handled by
      plug-ins differently from those handled internally).  If only
      <code>object</code> elements did not cause it to crash.
    </p>
    <p>
      You cannot upgrade Safari for free; versions 1.1 and 1.2 only
      work with Mac OS&nbsp;X 10.3, leaving older Macs running 10.2
      stranded with Safari version 1.0.  The rule of thumb seems to be
      that we stop worrying about support on a given web browser
      version after
      it has been abandoned for five years;
      Safari was released in 2003, so its bugginess has to be taken
      into account until 2008.  Pity.
    </p>
  </body>
  <dc:subject>svg</dc:subject>
  <dc:subject>html</dc:subject>
  <dc:subject>safari</dc:subject>
</entry>
