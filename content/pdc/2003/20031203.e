<!-- -*-HTML-*- -->
<entry date="20031203" icon="../tarot/wands-ten-100w.png"
 xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>Alleged Tarot brush-up (3)</h>
  <body>
    <p>
        <a href="../tarot/deal.svg?lo=celtic&amp;q=what+deal%3F">The
        SVG-powered simulated deal</a> now works on Safari.  In the
        end I&nbsp;achieved this by using the special attribute that
        signals to Adobe that it should use its own JavaScript engine,
        not its host&rsquo;s (in this case, Safari&rsquo;s).
        I&nbsp;have also belatedly switched the script to using
        <code>document.URL</code> to find its URL rather than the
        HTML-style <code>location.search</code> (which fails on Safari
        as well).
    </p>
    <p>
        Supposedly <a
	href="http://simon.incutio.com/archive/2003/11/06/easytoggle">it
	is possible to arrange for JavaScript errors to appear in the
	system console</a>; I&nbsp;enabled this option but (even when not
	using Adobe&rsquo;s engine) saw no error messages.  I&nbsp;presume
	this is because JavaScript is happening in the context of the
	SVG not the HTML, but, well, in the end it was debugging
	through <code>window.alert</code> as per usual.
    </p>
    <p>
        Safari&rsquo;s overoptimistic caching did not help.
    </p>
  </body>
  <dc:subject>tarot</dc:subject>
  <dc:subject>safari</dc:subject>
  <dc:subject>javascript</dc:subject>
  <dc:subject>svg</dc:subject>
</entry>
