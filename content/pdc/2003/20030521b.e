<!-- -*-HTML-*- -->
<entry date="20030521" icon="picky-80x80.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1"> 
  <h>Now with BMP support</h>
  <body>
    <p>
      To make it easier to create pictures for the <a
      href="http://caption.org/caption-cgi/hello.cgi/sample/">Picky
      Picky Game</a>, I have added code to automatically convert
      Microsoft Windows Bitmap (<code>.bmp</code>) files into 
      <abbr title="Portable Network Graphics">PNG</abbr>s.  
    </p>
    <p>
      This is straightforward because I&nbsp;already was using <abbr
      title="the Python Imaging Library">PIL</abbr> to check the
      dimensions of the images.  Converting to PNG (if the format is
      one PIL knows) is pretty simple:
    </p>
    <pre>permittedTypes = ['image/png', 'image/jpeg', 'image/pjpeg', 'image/gif']
...
if not imt in permittedTypes:
    buf = StringIO.StringIO()
    im.save(buf, 'PNG')
    data = buf.getvalue()
    logger.log(slog.WARNING, 'Converted your image from %s to image/png' % imt,
	       'This may have lead to a slight loss of image quality.')
    imt = 'image/png'
    buf.close()</pre>

    <p>
      The above goes in the sequence of checks on uploaded images
      (after the check for width &times; height, but before the check
      for number of bytes).  I&nbsp;think I&nbsp;spent longer creating
      a BMP image to test it on than I&nbsp;did writing the new code!
    </p>
    <p>
      <img src="paint1.png" align="right" alt="" width="230"
      height="134" />
      The advantage of BMP support is that, if you have Microsoft
      Windows, then you definitely have Microsoft Paint installed.
      So long as you know about Start menu &rarr; Programs &rarr;
      Accessories &rarr; Paint, and the Image &rarr; Attributes menu item,
      you can create panels for Picky Picky Game.
    </p>

  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>pil</dc:subject>
  <dc:subject>python</dc:subject>
</entry>
