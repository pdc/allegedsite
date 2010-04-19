<!-- -*-HTML-*- -->
<entry date="20031123" icon="../tarot/vi-lovers-64x64.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>Alleged Tarot brush-up</h>
  <body>
    <p>
      I have been tweaking the formatting of the <a
      href="../tarot/">Alleged Tarot</a> section of my site.   Apart from
      replacing the style sheet, thus giving it a completely different
      appearance, I have also divided the pages in to 
      <abbr title="Scalable Vector Graphics">SVG</abbr> and <abbr
      title="Portable Netwoerk Graphics">PNG</abbr> sections.
      Before this, the index pages for the different formats were
      mixed up together on the introductory page.
    </p>
    <p>
      I have also enhanced the <a href="../tarot/png.html">PNG
      index</a> so that each thumbnail now links to a page with the
      big image and the same commentary as the matching SVG page.
      This is because I am now less optimistic that viewers can or
      will install an SVG viewer plug-in just to read my humble
      pages.  Most of the traffic to my web site goes to that page, so
      it might as well have something more interesting on it.
    </p>
    <p>
      I have made one other change: I&nbsp;no longer use
      HTML&nbsp;4&rsquo;s <code>object</code> element to embed SVG
      graphics in web pages.  The last straw was Apple Safari&rsquo;s
      habit of crashing after visiting a few pages that used
      <code>object</code>.  The never-standardized tag
      <code>embed</code> works consistently in all browsers that can
      embed graphics at all.
    </p>
    <p>
      This is very disappointing for me.  In 2000 it seemed to be that
      mark-up divided neatly in to 20th-century and 21st-century code.
      In the old century there was HTML and (amongst other things)
      <code>embed</code>; in the new, XML-savvy, century there would
      be <code>XHTML</code> and <code>object</code>.  I&nbsp;really
      would prefer to use the <code>object</code> element, but when
      even browsers written <em>this year</em> cannot manage to
      implement it without crashing, then I&nbsp;cannot.  If we take
      five years as the cut-off point where we cease to consider a
      given web browser release when making decisions about mark-up,
      then Safari means the twenty-first century has been put back to
      2008.  Which is a great pity.
    </p>
  </body>
  <dc:subject>tarot</dc:subject>
  <dc:subject>svg</dc:subject>
</entry>
