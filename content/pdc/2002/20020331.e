<!-- -*-HTML-*- -->
<entry date="20020331" icon="../jrd/icon-64x64.png">
  <h>Jeremy&rsquo;s Weekly Strip completes its first year</h>
  <body>
    <p>
      Jeremy&rsquo;s completed the first year of her <a
      href="../jrd/tws.html">Weekly Strip</a>: the first strip
      was <a href="../jrd/20010402.html">Monday 2&nbsp;April 2001</a>,
      the 52nd will be <a href="../jrd/2002/20020402.html">Tuesday
      2&nbsp;April 2002</a> (which she assembled before disppearing to
      Amsterdam for Easter).
    </p>

    <p>
      To mark the occasion I&nbsp;am belatedly overhauling the Tcl
      scripts used to generate the HTML pages that form the index for
      the strips.  Careful readers will have noticed that the <a
      href="../jrd/tws-2001.html">old index page</a> had the year 2001
      in its URL, despite including all the 2002 strips as well.
      Basically my indexing script was all organized around generating
      a single index page.  I&nbsp;have now refactored the whole
      shebang so that not only are there now per-year index pages, all
      the ones for years beyond 2001 have their own directories (e.g.,
      the index for 2002 is <a
      href="../jrd/2002/"><code>/jrd/2002/</code></a> instead of being
      <code>/jrd/tws-2002.html</code>).  There was a little jiggery-pokery
      required to ensure that <em>existing</em> pages do not move to
      different URLs (to avoid breaking any links or bookmarks other
      people might have).  Thus last week&rsquo;s strip remains at URL
      <a href="../jrd/20020326.html"><code>/jrd/20020326.html</code></a>,
      and this week&rsquo;s <a
      href="../jrd/20020402.html"><code>/jrd/2002/20020402.html</code></a>.
      
      
    </p>
  </body>
</entry>
