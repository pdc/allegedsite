<!-- -*-HTML-*- -->
<entry date="20040209" icon="../1998/wp-64x64.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<h>Mozilla implements SVG while carefully remaining incompatible with the rest of the world</h>
	<body>
		<p>
			Good news, everyone!  Mozilla now has a working <abbr
			title="Scalable Vector Graphics">SVG</abbr> implementation
			thanks to <a href="http://croczilla.org/">Alex Fritze of
			croczilla.org</a>.  It even has suppport for plugging in
			platform-specific back-ends so that in principle the Mac OS X
			version might be able to exploit Quartz Extreme.  Cool!  This
			could mean a working SVG-enabled release of Mozilla sometime
			before I die of old age.
		</p>
		<p>
			<embed src="../how-tall-are-you/dec-ant-cat.svgz"
				type="image/svg+xml" width="147" height="100" align="left" />
				But does this mean that SVG-savvy Mozilla can display my <a
			href="../how-tall-are-you/">How Tall are You</a> quiz page, my
			<a href="../2001/xmas.html">2001 Xmas card</a>, or <a
			href="../tarot/">The Alleged Tarot 2002</a>?  Well, no,
			Mozilla&rsquo;s secret anti-SVG conspiracy would not allow that.
			Oh, dear me, no.
		</p>
		<p>
			Mozilla&rsquo;s campaign to discourage the support of open
			standards in vector graphics started in 2001, when the Mozilla
			feature freeze for 0.91 <a
			href="http://bugzilla.mozilla.org/show_bug.cgi?id=115528">changed
			one of the interfaces the Adobe SVG Plug-in depended on</a>,
			causing it to crash.  Adobe have no particular reason to devote
			development effort to supporting Mozilla, and as a result there
			was no SVG plug-in for Mozilla&mdash;until in 2003 Corel
			released their rival plug-in (which sadly does not support
			animation).  So even in 2004 the SVG support in Mozilla is still
			mediocre at best.  
		</p>
		<p>
			The new SVG back-end sadly does not allow Mozilla to display my
			SVG pages, because the Mozilla project subscribes to the <abbr
			title="Extensible Mark-Up Language">XML</abbr> Document Fantasy.
			In the XML Document Fantasy, the right way to display SVG is to
			embed it directly within an XML document:
		</p>
		<pre>&lt;html xmlns="http://www.w3.org/1999/xhtml"&gt;
&lt;body&gt;
...
&lt;svg xmlns="http://www.w3.org/2000/svg"
width="400" height="600"&gt;
...
&lt;/svg&gt;
...
&lt;/body>
&lt;html></pre>
		<p>
			To embed an image in a separate document,
			you use  <code>iframe</code> or <code>object</code> to display
			an XML document containing your image. 
			SVG images must be served as documents with media type
			<code>application/xml</code>.  
		</p>
		<p>
			This is an example of <dfn>namespace dispatch</dfn>, meaning
			that decisions as to which software component to dispatch
			requests to is decided based on the XML namespace of the
			<code>svg</code> element.  It requires that your XML browser be
			essentially omniscient because it needs SVG, XHTML, and MathML
			support baked in.  (Technically they could be implemented with
			plug-in modules, but because the module would need access to the
			internal repressentation of the shared XML document, the
			plug-in interface would be very complex.)
		</p>
		<p>
			<embed src="../tarot/viiii-hermit-card3.svgz"
				type="image/svg+xml" width="100" height="147" align="right" />

			Contrast this with the old-school <dfn>content-type
			dispatch</dfn> approach: when an HTML document contains
			something that isn&rsquo;t HTML, it does so by reference: the
			<code>img</code>, <code>applet</code>, <code>embed</code>, or
			<code>object</code> element has a a URL that specifies a
			resource.  The HTML renderer leaves a rectangular space on the
			screen for the alien content and leaves it to the handler for
			that content-type to fill in the space.  The handler is chosen
			based on the media type of the embedded resource (e.g., one
			plug-in handles <code>image/svg+xml</code>, and another might
			handle <code>image/png</code>).  The interface with the plug-in
			is relatively simple: a graphics context, the URL of the
			content, and any extra arguments included in the
			<code>embed</code> or <code>object</code> tag.  This simplicity
			has given rise to a large number of plug-ins for different
			formats.  
		</p>
		<p>
			All SVG content on the <abbr title="World-Wide Web">WWW</abbr>
			today is in the form of separate resources included using
			<code>embed</code> or its erratically-supported equivalent
			<code>object</code>.  It will not work in Mozilla.  And, of
			course, the demonstration pages for Mozilla&rsquo;s SVG support
			do not work in any other browser.  The conventions are mutually
			incompatible: one cannot write a <abbr title="Hypertext Mark-Up
			Language">HTML</abbr> document that works in both Mozilla and
			not-Mozilla.
		</p>
		<p>
			<embed src="../tarot/swords-ten-card3.svgz"
				type="image/svg+xml" width="200" height="294" align="left" />

			The upshot of this is that the Mozilla project is wilfully
			cutting themselves off from the mainstream of SVG practice (if
			something so obscure as SVG can be said to have a mainstream),
			and challenging the rest of the world to drop everything and do
			it the Mozilla way or not at all.   And that&rsquo;s in the
			special SVG-enabled version of Mozilla; the standard release
			does not have even that grudging support for SVG.
		</p>
		<p>
			Alex Fritze has been assigned a bug report <a
			href="http://bugzilla.mozilla.org/show_bug.cgi?id=231171">asking
			for support for <code>embed</code></a>, which would go a long
			way to bridging the gap.  He has also been requested to <a
			href="http://bugzilla.mozilla.org/show_bug.cgi?id=157514">make
			Mozilla support the <code>.svgz</code> format</a> (whereby SVG
			files are stored compressed to prevent them from being so much
			more verbose than binary formats).  It seems to me that, now the
			heavy lifting has been done, it would not be hard at all for
			Mozilla to be equipped with truly splendid support for
			SVG&mdash;assuming the will is there.
		</p>
	</body>
	<dc:subject>xml</dc:subject>
	<dc:subject>mozilla</dc:subject>
	<dc:subject>svg</dc:subject>
</entry>
