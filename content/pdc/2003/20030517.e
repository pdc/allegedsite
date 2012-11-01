<!-- -*-HTML-*- -->
<entry date="20030517" icon="../icon-64x64.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1">
  <h>Backslashes in URLs</h>
  <body>
    <p>
      Had a bug in the <a href="picky.html">Picky Picky Game</a> where
      uploaded pictures might have backslashes left in their names
      (the picture name being derived from the file name supplied by
      the client computer).  Technically it is OK to have backslashes
      in a 
      <abbr title="Uniform Resource-Locator">URL</abbr>, and they should
      be treated like any other character.  Some web browsers
      second-guess you, however, and replace backslashes with slashes
      (<code>http://foo/bar\baz</code> is treated as
      <code>http://foo/bar/baz</code>), with the result that these
      pictures failed to appear.    
    </p>
    <p>
      The solution is, of course, to (a)&nbsp;change the code for
      translating file names in to picture names so that it removes
      backslashes, and (b)&nbsp;fix the existing databases.
      ZODB makes the second part pretty easy; having acquired a
      <code>Game</code> instance from the databse, you just run a
      script like
    </p>
    <pre>for rn, r in game.rounds.items():
    for pic in r.pictures:
	s = r.sanitizedName(pic.name, pic)
	if s != pic.name:
	    pic.name = s
	    pic.dataUri = s + picky.mediaTypeSuffix(pic.mediaType)</pre>
    <p>
      The function <code>sanitizedName</code> is the one that has to
      be fixed for part (a).
    </p>
  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>zodb</dc:subject>
</entry>
