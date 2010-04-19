<!-- -*-HTML-*- -->
<entry date="20020508" icon="../wp/icon-64x64.png">
  <h>Fixed on Mozilla?</h>
  <body>
    <p>
      It turns out my <a href="../../">front page</a> did not work on
      Mozilla&mdash;the division containing the main text started at
      the top of the screen rather than 76px down from the top (as
      I&nbsp;has expected, given that its top margin was 76px).
      I&nbsp;changed this, but in order to test on Mozilla (which
      takes some minutes to start up on my K6/233) I&nbsp;needed to
      persuade <a
      href="http://www.acme.com/software/thttpd/">thttpd</a> to serve
      <abbr title="Cascading Style Sheets">CSS</abbr> marked as type
      <code>text/css</code>.  (This is necessary because the W3C specs
      require that web browsers believe what web servers tell them,
      and it it says a file is <code>text/plain</code> it is not a
      style sheet.)
    </p>
    <p>
      In theory I&nbsp;did this months ago
      (edit <code>mime_types.txt</code>, rebuild, reinstall).  Testing
      this is a pain as well&mdash;Mozilla 0.9.7 does not give any
      easy way to find the content-type of auxillary files, so you
      have to type HTTP requests in to TELNET by hand...  In the end
      it ocurred to me to run TELNET in an Emacs buffer so at least
      the retyping of <code>HEAD /mumble/foo/bar.css HTTP/1.0</code>
      could be done almost-automatically...  In the end it turns out
      that I&nbsp;needed to do <code>make clean</code> to force a
      complete rebuild, otherwise changes to
      <code>mime_types.txt</code> made no difference <code>:-(</code>.
    </p>
  </body>
</entry>
