<!-- -*-HTML-*- -->
<entry date="20030606" icon="picky-80x80.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1">
  <h>Fixed a bug when starting new panel</h>
  <body>
    <p>
      The <a href="http://caption.org/picky/">Picky Picky Game
      prototype</a> stopped working this morning because of a bug in
      the code that sets up a new panel (and this morning is when the
      new round begins).  I was able to patch the running version from
      work during lunch, and have now done a proper fix on my
      development system at home.
    </p>
    <p>
      I&nbsp;was able to fix it from work because I&nbsp;do all the
      work on <a href="http://www.humboldt.co.uk/">Adrian&rsquo;s</a>
      server (the one hosting <a
      href="http://caption.org">caption.org</a>) via <abbr
      title="secure shell">SSH</abbr>, and someone at work had kindly
      downloaded a copy of <a
      href="http://www.pobox.com/~anakin/">Simon Tatham</a>&rsquo;s <a
      href="http://www.chiark.greenend.org.uk/~sgtatham/putty/">PuTTY</a>
      program to our file server.  Once I had connected to the server,
      the problem was easily fixed with a one-line change in vi (my
      broken script had helpfully produced a standard Python error
      message with back-trace).  This was probably as pleasant a
      debugging experience as one can expect.  Yay, Python.
    </p>
    <p>
      I have also added code to convert URLs entered as
      <code>www.foo.com</code> in to <code>http://www.foo.com/</code>
      (without which the links in web pages will not work).
    </p>
  </body>
  <dc:subject>picky</dc:subject> 
</entry>
