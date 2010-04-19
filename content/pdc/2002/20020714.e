<!-- -*-HTML-*- -->
<entry date="20020714" icon="../tarot/i-magician-64x64.png"
href="../tarot/attempt-1.svg">
  <h>SVG slideshow, attempt 1</h>
  <body>
    <p>
      My <a href="../tarot/">virtual tarot deck</a> is published in
      <abbr title="Scalar Vector Graphics">SVG</abbr>, but the index
      pages are still in 
      <abbr title="Hypertext Mark-Up Language">HTML</abbr>,
      which is a problem for people trying to visit 
      using an SVG-only browser like Batik.  So I&nbsp;intend to make
      an SVG-powered index page.  
      <a href="../tarot/attempt-1.svg">My first attempt</a> 
      uses the SVG <code>image</code> tag and intrinsic animation
      to switch between cards.  This turns out to be unsatisfactory on
      two counts.  First, it works by rendering the card and then
      displaying the result as if it were a raster image&mdash;on my
      computer that leaves the screen blank for some seconds while the
      off-screen rendring takes place.  Second,  the resulting image
      is not interactive&mdash;you lose the feature of the pips cards
      where the illustration can be switched on and off.
    </p>
  </body>
  <dc:subject>tarot</dc:subject>
</entry>
