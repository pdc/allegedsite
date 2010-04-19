<!-- -*-HTML-*- -->
<entry date="20030519" icon="picky-80x80.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1">
  <h>CGI vs. If-Modified-Since and other stories</h>
  <body>
    <p>
	I demonstrated the 
	<a href="http://caption.org/caption-cgi/hello.cgi/sample/">Picky Picky Game prototype</a>
	to the
	<a href="http://caption.org/">CAPTION</a> committee.  The
	main trouble was picture resources not being
	downloaded, or, oddly, vanishing when one refreshed the
	page. It worked better on
	the dial-up than the broadband connection (though Jo
	blames that on
	<abbr title="Microsoft Internet Explorer (Windows)">IE</abbr>&nbsp;6
	being set up to cache nothing). 
	I&nbsp;resolved to make an effort to sort out
	caching&mdash;or at least, the things my server needs to
	do to enable caching to work smoothly.
    </p>
    <p>
	So, in my development system at home,
	I&nbsp;added <code>If-Modified-Since</code> and
	<code>If-None-Match</code> (etag) support to the routine
	that fetches picture data out of the database. I&nbsp;also
	added an <code>Expires</code> header set, as 
	<a
	href="http://ietf.org/rfc/rfc2616.txt">RFC&nbsp;2616</a>
	demands, approximately one year in to the future.
	Result: none of the pictures appear.
    </p>
    <p>
	The problem is 
	that the web server I&nbsp;am using at home always
	returns status code 200 for <abbr title="common gateway
	interface">CGI</abbr> scripts (it ignores the
	<code>Status</code> pseudo-header). As a result, my clever
	304  (&lsquo;Not modified&rsquo;)  responses result in
	apparently zero-length data. Argh!
    </p>
    <p>
	When I&nbsp;worked this out, I&nbsp;though I&nbsp;would
	demonstrate to Jeremy that it worked in the stand-alone server (which
	does not use CGI). But Lo! all the pictures failed to
	appear once more. So did the page itself. What gives?
    </p>
    <p>
	This time the trouble was its logging
	function&mdash;it tried to resolve the client <abbr
	title="internet protocol">IP</abbr>
	address. Now, I&nbsp;thought that the address used by my
	PowerBook did have reverse look-up in my local 
	<abbr title="Domain Naming-Service">DNS</abbr>, but
	in any case, the server should not be indulging in DNS
	look-ups given that on my system that is a blocking
	operation that tends to mean the program locks up for 75
	seconds. Luckily <code>BaseHTTPServer</code> makes it
	easy to override the function that indulges in DNS
	queries and it all now runs smoothly.
    </p>
    <p>
	On the positive side, I have made one cache-enhancing
	change that has worked, albeit only for the old panels
	(which saved their images as separate disc files rather
	than in <abbr title="Z Object Database">ZODB</abbr>). 
	Simply put, there is another base <abbr title="Uniform
	Resource-Locator">URL</abbr>
	used (in addition to the base of the web application and
	the base URL for static files), and this one is for
	picture files. This means that these old pictures are
	now, once again, served as static files, with etags
	and caching the responsibility of my host
	<abbr title="Hypertext Transfer Protocol">HTTP</abbr> server,
	not me.
    </p>
  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>cgi</dc:subject>
</entry>
