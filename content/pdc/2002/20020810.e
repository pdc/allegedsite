<!-- -*-HTML-*- -->
<entry date="20020810" icon="../tarot/xii-hanged-64x64.png">
  <h>Dial-a-reading: now with Celtic Cross!</h>
  <body>
    <p>
      My  <a href="../tarot/#chooseDeal">simple-minded virtual tarot
      dealer</a> now understands the Celtic cross spread.
    </p>

    <p>
      This was tricky because it requires that one of the cards be
      laid crossways, so I&nbsp;had to change the format of the data
      which specifies the layouts.  Formerly I&nbsp;used JavaScript
      arrays to hold the positions of the cards; now 
      <a href="../tarot/aboutDealer.html">I&nbsp;have
      switched to embedding an XML document</a> describing the layouts in
      the <code>defs</code> section of the SVG file.
    </p>
  </body>
  <dc:subject>tarot</dc:subject>
</entry>
