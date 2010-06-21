<!-- -*-HTML-*- -->
<entry date="20020312" icon="tarot/xi-strength-64x64.png">
  <h>Alleged Tarot (11a)</h>
  <body>
    <p>
      I&nbsp;have redesigned the layout of the <a
      href="tarot/">cards</a> so that the titles are on the left side
      rather than the right&mdash;and this way they read up from the
      bottom of the card rather than from some point part-way down.
      This means I&nbsp;can fit in the <a
      hrf="tarot/x-wheel-svg.html">Wheel of Fortune</a> without the
      rest of them looking lop-sided.  Also, I&nbsp;have decided that
      the titles will no longer overlap the artwork.
    </p>

    <p>
      I&nbsp;have also fixed a few bugs&mdash;the <a
      href="tarot/coins-ace-svg.html">Ace of Coins</a> had not had its
      colours adjusted after the <abbr title="cyan-magenta-yellow-black">CMYK</abbr>&rarr;<abbr title="red-green-blue">RGB</abbr> translation; <a
      href="tarot/coins-5-svg.html">Five of Coins</a> had changed the
      figure&rsquo;s hair from pink to white; <a
      href="tarot/vii-chariot-svg.html">The Chariot</a> was cropped
      wrongly.  
    </p>

    <p>
      To explain the colour issue: I&nbsp;am using an old version of
      Adobe Illustrator which does not seem to have an <abbr
      title="red-green-blue">RGB</abbr> option.  To convert to <abbr title="Scalable Vector Graphics">SVG</abbr>
      I&nbsp;use a freeware drawing program called <a
      href="http://sketch.sourceforge.net/">Sketch</a>, which is happy
      to translate <abbr title="cyan-magenta-yellow-black">CMYK</abbr> to <abbr title="red-green-blue">RGB</abbr>,
      but does not take account of the fact that Adobe&rsquo;s screen
      display simulates the printed paper, rather than showing
      mathematically correct <abbr title="cyan-magenta-yellow-black">CMYK</abbr> colours.  My brute-force solution to
      this is to cobble together a Python script that takes as inputs
      Adobe Illustrator&rsquo;s Targa image and a screen shot of the
      &lsquo;bad&rsquo; <abbr title="Scalable Vector Graphics">SVG</abbr>, and examines them pixel-by-pixel to
      generate a map from the &lsquo;bad&rsquo; colour space to the
      correct one.  It then generates a new <abbr title="Scalable Vector Graphics">SVG</abbr> file with the adjusted
      colours.  Sounds complicated?  I&rsquo;m hoping the new version
      of Sketch will make it unnecessary...
    </p>
  </body>
  <dc:subject>tarot</dc:subject>
  <dc:subject>svg</dc:subject>
  <dc:subject>cmyk</dc:subject>
  <dc:subject>adove</dc:subject>
</entry>
