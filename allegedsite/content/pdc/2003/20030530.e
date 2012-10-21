<!-- -*-HTML-*- -->
<entry date="20030530" icon="picky-80x80.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1">
  <h>Remember my details</h>
  <body>
    <p>
      I have added JavaScript to the upload form <a
      href="http://caption.org/picky/">Picky Picky Game on
      caption.org</a> to optionally remember your details for next
      time (using a cookie).  This way you don&rsquo;t have to enter
      your URL each time you upload a new panel.
    </p>
    <p>
      Debugging JavaScript without a JavaScript debugger is a real
      pain in the arse, and illustrates how subtle aspects of language
      design affect the experience of working in that language.  There
      is one crucial difference between Python and JavaScript.  In
      Python, a variable is implicitly created the first time you
      assign to it; in JavaScript, it is created the first time you
      refer to it.  This means that the following fragment is valid
      JavaScript:
    </p>
    <pre>var cookieHeader = this.$document.cookie;
var m = myRegexp.exec(cookiesHeader);
if (m) {
    ... use the match info to process the cookies ...
}</pre>
    <p>
      The equivalent Python looks like this:
    </p>
    <pre>cookieHeader = self._document.cookie
m = myRegexp.search(cookiesHeader)
if m:
    ... use the match info to process the cookies ...</pre>
    <p>
      In the JavaScript version, the regexp (used to extract one
      cookie from the <code>Cookies</code> header) will mysteriously never match
      and you will spend ages scrutinizing the regexp and flipping
      though the documentation on what is and is not valid regexp
      syntax in JavaScript.  In Python you will get an error message
      telling you that the variable <code>cookiesHeader</code> is
      referred to before it is assigned to&mdash;and immediately
      realise its name is misspelled in the second line.
    </p>
    <p>
      The tedious thing about testing the &lsquo;remember me&rsquo;
      option is that it involves repeatedly doing the very thing it is
      supposed to be saving me from: entering my URL and details
      on the picture-upload form.  Luckily I&nbsp;was testing on Safari,
      which has a form auto-completion feature that makes repeatedly
      filling in the form less annoying&mdash;but which also makes the
      &lsquo;Remember me&rsquo; feature almost entirely redundant
       <samp>;-)</samp>
    </p>
  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>javascript</dc:subject>
</entry>
