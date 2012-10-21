<!-- -*-HTML-*- -->
<entry date="20021207" icon="../2003/picky-80x80.png"
    href="http://wellformedweb.org/RESTLog.cgi/14">
  <h>Picky Picky Game: Refactoring the CGI scripts</h>
  <body>
    <p>
      In the process of getting the <a href="http://hoohoo.ncsa.uiuc.edu/cgi/interface.html"><abbr title="Common Gateway Interface">CGI</abbr></a> scripts to work again after
      reorganizing the libraries, I have further refactored them my
      moving the request-processing code in to the Picky Picky Game
      library, leaving the <abbr title="Common Gateway Interface">CGI</abbr> script to contain just a few
      configuration parameters and an invocation of the library
      routine.  This style is not unlike that used by Joe Gregorio in
      his <a
      href="http://wellformedweb.org/RESTLog.cgi/14">Well-Formed
      Web</a> experiment.
    </p>

    <p>
      There are various advantages to moving most
      of the code out of the <abbr title="Common Gateway Interface">CGI</abbr>s themsevles&mdash;better information
      hiding, for example (which can be considered a security feature
      as well as good programming practice).  It also allows the bulk
      of the code to be stored in byte-compiled form on disc, which
      might make processing requests a little faster.
    </p>
  </body>
  <dc:subject>picky</dc:subject>
</entry>
