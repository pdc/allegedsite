<!-- -*-HTML-*- -->
<entry date="20021108" icon="../1998/wp-64x64.png">
  <h>Things your mother didn&rsquo;t tell you</h>
  <body>
    <p>
      Opera&nbsp;5 omits the boundary parameter when uploading files.
      Lynx&nbsp;2.8.2 does not support uploading files at all (but,
      oddly, does generate <code>multipart/form-data</code> forms
      properly&mdash;it even gives the <code>charset</code> parameter
      to the content-type of its form items).  Python&rsquo;s
      <code>multifile</code> module raises an exception on all of the
      above, for some inputs.
    </p>
    <p>
      I guess that if I want to handle uploaded images, I&nbsp;get to
      write my own <code>multipart/form-data</code> parsers from
      scratch.  I&nbsp;have already done this in C++ for work;
      I&nbsp;guess I&nbsp;can do it again in Python. Sigh.
    </p>
  </body>
  <dc:subject>opera</dc:subject>
  <dc:subject>cgi</dc:subject>
</entry>
