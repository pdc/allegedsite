<!-- -*-HTML-*- -->
<entry date="20021111" icon="../2003/picky-80x80.png">
  <h>Picky Picky Game: Upload pictures, EAGAIN</h>
  <body>
    <p>
      I have now written a parser for HTML-4.0 file uploads (forms
      with enctype <code>multipart/form-data</code>).  It will need
      some finessing to get character encodings to work right, but for
      the simple cases I&nbsp;tried it uploaded files flawlessly, and
      moreover, plugged in to the back-end script I&nbsp;mentioned in
      <a href="11.html#e20021107">an earlier installment</a>.
    </p>

    <p>
      Alas!  When I tried uploading from Jeremy&rsquo;s NT box, my
      Python program crashed with an <code>IOError</code> exception
      with
       <code>errno=EAGAIN</code>.  I&nbsp;guess I&nbsp;need to do some
      sort of loop to fill my buffer.  Ho hum.  
    </p>
  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>cgi</dc:subject>
</entry>
