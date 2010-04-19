<!-- -*-HTML-*- -->
<entry date="20021107" icon="../2003/picky-80x80.png">
  <h>Picky, Skin, SaxLifter</h>
  <body>
    <p>
      Found some time to continue <a href="10.html#e20021031">work on
      the Picky Picky Game</a>.  I&nbsp;have something which, given a
      graphics file, writes it in to the correct place in the
      directory structure.  Tonight&rsquo;s task was a routine for
      generating the index page, based on the pictures stored so far.
      In the eventual web application, this routine will be invoked in
      <abbr title="Common Gateway Interface">CGI</abbr> scripts
      whenever a new picture is added or vote recorded.  For the
      present I&nbsp;can just run the Python script (one of the ways
      in which creating web apps in Python is less hassle than, say,
      <abbr title="Microsoft&reg; ActiveX Server
      Pages">ASP</abbr>&nbsp;.Net or <a
      href="../wp/wc.html">webclasses</a>).
    </p>
    <p>
      The index page format is mainly controlled through a
      &lsquo;skin&rsquo; file <code>index.skin</code>.  This has most
      of the HTML, with special XML tags for interpolating the dynamic
      content.  This way hopefully Jeremy will be able to hack the
      HTML without touching any of the application code.  (The
      immediate inspiration for the term <em>skin</em> comes from the
      <a href="http://helma.org/">Helma Object Publisher</a> system,
      which does something similar, but using JavaScript.)
    </p>
    <p>
      The picture metadata is written in <abbr title="Extensible
      Mark-up Language">XML</abbr> which is straight&shy;forward
      enough except that Python&rsquo;s native 
      <abbr title="Simple API for XML">SAX</abbr> support is broken:
      it does not support <abbr title="Extensible
      Mark-up Language">XML</abbr> namespaces!  I&nbsp;have fixed this
      with my own  <abbr title="Simple API for XML">SAX</abbr> filter
      dubbed <code>SaxLifter</code>: it processes
      <code>startElement</code> events by scanning the attributes for
      namespace prefixes, maintaining a stack of namespace mappings,
      and generating <code>startElementNS</code> events.  Presumably
      if I&nbsp;were using the XML-SIG or 4Thought enhancements to
      Python things would work better.  Sigh.
    </p>
    <p>
      The overall strategy is to generate as much static HTML as
      possible&mdash;that is, instead of creating the HTML for the
      list of pictures afresh each time someone visits the site (which
      is what PHP and ASP, etc., do), I&nbsp;intend to generate it
      only when a new picture is added to the list.  Since adding
      pictures will happen much more rarely than viewing the list,
      this reduces the overall load on the web server.  The aim is to
      use <abbr title="Common Gateway Interface">CGI</abbr> only in
      the pages that make a change (adding a picture or voting).
    </p>
  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>xml</dc:subject>
  <dc:subject>sax</dc:subject>
</entry>
