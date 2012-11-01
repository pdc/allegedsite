<!-- -*-HTML-*- -->
<entry date="20030514" icon="picky-80x80.png">
  <h>ZODB: don&rsquo;t forget to close connections</h>
  <body>
    <p>
      I have converted the Picky Picky Game so that it can run as a
      <a
      href="http://www.python.org/doc/current/lib/module-BaseHTTPServer.html"><code>BaseHTTPServer</code></a>
      server as an alternative to as a 
      <abbr title="Common Gateway Interface">CGI</abbr> script, in
      order to avoid the performance penalty caused by starting up
      fresh Python processes for each request.  But I&nbsp;discovered
      that the sevrer would lock up from time to time.
    </p>
    <p>
      <a href="con-close.html">Closing your connections</a>
    </p>
  </body>
  <dc:subject>zodb</dc:subject>
  <dc:subject>picky</dc:subject>
  <dc:subject>approvalvote</dc:subject>
</entry>
