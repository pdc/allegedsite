<!-- -*-HTML-*- -->
<entry date="20021114" icon="../2003/picky-80x80.png">
  <h>CGI upload woes</h>
  <body>
    <p>
      On <a href="11.html#e20021111">Monday</a> I&nbsp;was troubled by
      <code>EAGAIN</code> interruptions when reading in a CGI
      script&rsquo;s data.  It turns out Python has a <code>cgi</code>
      module already.  But when I&nbsp;tried creating a script that
      used that, it failed to work with <a
      href="11.html#e20021108">Opera&rsquo;s boundary-less
      multipart</a> (the built-in <code>cgi</code> module uses the
      <code>multifile</code>, which I&nbsp;tried and rejected
      earlier).
    </p>
    <p>
      I&nbsp;have tried looping until <code>EAGAIN</code> does not
      happen&mdash;but I&nbsp;put a limit of 10 iterations so as not
      to chew up the CPU.  No dice.  I&nbsp;have also tried using the
      <code>fcntl</code> module to remove the <code>O_NONBLOCK</code>
      flag from stdin.  The result is that instead of crashing with
      <code>EAGAIN</code> it waits indefinitely (and gets interrupted
      by <code>thttpd</code>&rsquo;s watchdog timer).
    </p>
    <p>
      The upshot of this is that I&nbsp;have the beginnings of a CGI
      script that works if I&nbsp;connect to it from the same machine the
      server is running on, but not if I&nbsp;connect to it from a
      different machine (an NT box) on the same network.
      The thing is, I&nbsp;<em>know</em> that people have successfully
      written CGI programs in Python, and none of the examples
      I&nbsp;find on-line have any mention of these phenomena.  
    </p>
  </body>
  <dc:subject>cgi</dc:subject>
  <dc:subject>picky</dc:subject>
</entry>
