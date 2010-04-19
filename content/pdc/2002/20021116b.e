<!-- -*-HTML-*- -->
<entry date="20021116" icon="../2003/picky-80x80.png">
  <h>EAGAIN, again</h>
  <body>
    <p>
      I&nbsp;throught I&rsquo;d try out a different CGI framework, such
      as <a href="http://jonpy.sourceforge.net/">jonpy</a>, and this
      requires Python 2.2.  So I&nbsp;have now installed
      Python&nbsp;2.2 (carefully installing GNU db, expat, etc. first
      so these modules will be built).  During its self-tests,
      I&nbsp;noticed that <code>test_socket.py</code> takes 2&frac12;
      minutes (to do something that should take approximately no
      time).  Come to think of it, initiating connections to my Linux
      box from Jeremy&rsquo;s <abbr title="Microsoft Windows
      NT">NT</abbr> box also takes an inordinate amount of time.  That
      might be why initiating HTTP connections to my
      <code>thttpd</code> instance also takes an inordinate amount of
      time, so long that <code>thttpd</code> kills the CGI rather than
      waste any more time.  In other words, my CGI problems may mostly
      stem from a broken network stack.  Teriffic.  This is a
      variation on <a
      href="http://www.joelonsoftware.com/articles/LeakyAbstractions.html">Joel
      Spolsky&rsquo;s law of leaky abstractions</a>: I would like to
      be able to believe in POSIX&rsquo;s abstraction of sockets as
      being a lot like a file, but sadly it is all frinked up.
      Another reason to spend a week or two installing <a
      href="http://www.debian.org/">Debian</a> some time.
    </p>
    <p>
      I&nbsp;think the way forward for now is probably to ignore the
      network problems and cross my fingers when I&nbsp;install it on
      the actual server.  Given that fairly thorough search of the WWW
      and Netnews reveals no discussion of the sort of problems
      I&rsquo;ve been having, I&nbsp;am fairly sure it is some
      freakish glitch in my computer...
    </p>
  </body>
  <dc:subject>picky</dc:subject>
</entry>
