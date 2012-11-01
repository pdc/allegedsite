<!-- -*-HTML-*- -->
<entry date="20021202" icon="../2003/picky-80x80.png">
  <h>Picky Picky Game: Tidying up the Python code</h>
  <body>
    <p>
      Having got the first working version of the Picky Picky Game,
      I&nbsp;have naturally now pulled it apart again.  I&nbsp;decided
      that now  it is in a state where it makes sense to try to
      package up a version for Adrian to try installing, I&nbsp;better
      think about getting the module and package names right, since it
      will be harder to change them later.  
    </p>

    <p>
      I&nbsp;have reorganized my Python classes in to their own
      package <code>pdc</code> (designed to prevent name collisions
      with WWW-oriented packages by other people).  I&nbsp;also
      changed some of the file names&mdash;so that &lsquo;<code>import
      httputils</code>&rsquo; becomes &lsquo;<code>from pdc import
      www</code>&rsquo;.  
    </p>

    <p>
      There is now a proper 
      <a href="http://c2.com/cgi/wiki?UnitTest">unit-test</a>
      suite for  the <code>www</code>
      module (which has functions like <code>urlDecode</code>, 
      <code>urlResolve</code>, and <code>xmlencode</code>).  This is
      easier to do for this odule than the others, which tend to
      involve creating scads of HTML text which will be hard to check
      for errors.  For the URL-manipulating functions, the unit tests
      turned out to be invaluable&mdash;there are a lot of corner
      cases that I&nbsp;only sorted out because I&nbsp;had tests for
      all of them.
    </p>
  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>python</dc:subject>
</entry>
