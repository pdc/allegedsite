<!-- -*-HTML-*- -->
<entry date="20021118" icon="../2003/picky-80x80.png">
  <h>Picky Picky Game: The Joy of PIL</h>
  <body>
    <p>
      The final piece in the puzzle of my <abbr title="Picky Picky
      Game">PPG</abbr> platform is <a
      href="http://www.pythonware.com/products/pil/">the Python
      Imaging Library (PIL)</a> from <a
      href="http://www.pythonware.com/">Secret Labs AB
      (PythonWare)</a>.  This makes it easy to check that the uploaded
      images are the right dimensions, for example:
    </p>
    <pre>im = Image.open(StringIO.StringIO(data))
width, height = im.size
if width &gt; game.maxWidth or height &gt; game.maxHeight:
    log('Image is too large: the maximum is %d &times; %d.' \
            % (game.maxWidth, game.maxHeight), STOP)
    ok = 0</pre>
    <p>
      I&nbsp;don&rsquo;t even need to know whether the image is a 
      <abbr title="Portable Network Graphics">PNG</abbr>,
      <abbr title="Joint Photographic Expert Group">JPEG</abbr>, or
      <abbr title="Compuserve Graphics Interchange Format">GIF</abbr>.
    </p>

  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>pil</dc:subject>
</entry>
