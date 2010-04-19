<!-- -*-HTML-*- -->
<entry date="20020106" icon="tarot/0-fool-64x64.png">
  <h>SVG fonts; SVG Problems</h>
  <body>
    <p>
      I&nbsp;have created proper card mock-ups of my two <a
      href="tarot/">Alleged Tarot 2002</a>&mdash;adding the title of
      the card in a font I&nbsp;have cobbled together for the
      occasion.  The SVG format allows for the creation of fonts using
      SVG primitives, and just this once I&nbsp;have elected to write
      a font by entering the numbers by hand, viewing some sample
      text, and changing the numbers til it looks right (yes,
      I&nbsp;know this is crazy).  To do this I an using a text editor
      on <a href="../jrd/">Jeremy</a>&rsquo;s NT box, displaying the
      SVG in MSIE with Adobe&rsquo;s plug-in.  It works so long as
      I&nbsp;include the font definition in the same SVG file; my
      attempts to use indirect <code>@font-face</code> definitions (so
      the font data can be in one file shared by all the SVG files)
      have so far failed.  Also, after repeated reloads of slightly
      broken SVG files, the plug-in eventually crashes and takes MSIE
      with it.
    </p>

    <p>
      I&nbsp;also discovered a strange anomaly when using the
      <code>image</code> element to include one SVG file in another:
      it all worked OK while I&nbsp;was viewing SVG in files
      (<code>file://...</code> URLs), but when the same images were
      installed on my test server, the referenced image vanished!
      Worse, after I&nbsp;had tried viewing them from the web server,
      the same problem manifested when I&nbsp;viewed the corresponding
      files on disc.  After closing MSIE and restarting it I&nbsp;was
      able to view the files again.  The workaround for this problem
      is to not use images indirectly, and instead to copy the
      referenced SVG direct in to the referring image.  At some point
      I&nbsp;will make a script for doing this automatically...
    </p>

    <p>
      I have tried viewing these images with Mozilla 0.9.7 with SVG.
      The <a href="tarot/simple.html">simple</a> images are partially
      displayed, but the <a href="http://bugzilla.mozilla.org/show_bug.cgi?id=111496"><code>viewBox</code> attribute is ignored</a>; as
      a result you see only the top-left corner of the image!  Also,
      the colours are all replaced with shades of blue and magenta.
      The <a href="tarot/card3.html">fancy</a> versions with the title
      displayed in my special font do not display at all.
      
    </p>
    
  </body>
  <dc:subject>tarot</dc:subject>
</entry>
