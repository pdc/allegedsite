<!-- -*-HTML-*- -->
<entry date="20030903" icon="../../2005/percy/8/8b3.gif" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>Generating the printed comic with ReportLab</h>
  <body>
    <p>
      My <a title="Page 1 of Percy Street"
      href="../../2005/percy/1/">Percy Street comic strip</a> is
      published on-line at 100&nbsp;<abbr title="dots per
      inch">dpi</abbr>, using <a href="Hypertext Mark-up
      Language">HTML</a> to arrange the panels on the page.
      I&nbsp;draw the pages at 300&nbsp;dpi, which should be just high
      enough resolution to print on paper.  The printed version uses
      <abbr title="Portable Document Format">PDF</abbr> rather than HTML to
      lay out the page.  (The page has to be laid out because
      I&nbsp;am drawing each panel as a separate image.)
    </p>
    <p>
      The <a href="http://www.reportlab.com/">ReportLab</a> <a
      href="http://www.reportlab.com/toolkit/">Toolkit</a> makes this
      easy.  This was a relief, because my previous experience with
      turning <abbr title="Extensible Mark-up Language">XML</abbr>
      data in to <abbr>PDF</abbr> as with <a
      href="http://xml.apache.org/fop/">Apache <abbr title="Formatting
      Objects Processor">FOP</abbr></a>, which works, and works well,
      but is incredibly fiddly, and requires learning all about <a
      href="http://www.w3.org/TR/xsl/"><abbr title="XML Stylesheet
      Language Formatting Objects">XSL-FO</abbr></a>, which, because
      of its super-generalized model of page layout, has a high
      learning curve.
    </p>
    <p>
      ReportLab, by contrast, expose an interface to <abbr>PDF</abbr> that reveals
      the secret truth: under the hood, <abbr>PDF</abbr> is not all that dissimilar
      to PostScript.  This may not seem much of an advantage to most
      of my readers, but back before I started work at my current
      employer, I did a lot of work in PostScript (even writing
      programs in the PostScript language itself).  For this
      particular application&mdash;where I&nbsp;know (or can
      calculate) exactly where on the page I&nbsp;want to place each
      illustration&mdash;being able to just say
    </p>
    <pre>self.canvas.drawImage(fileName, 
    x + self.border, y + self.border,
    frame.width, frame.height)</pre>
    <p>
      seems really simple.  Actually, calculating <code>x</code>  and
      <code>y</code> was a little tricky, because I&nbsp;wanted to do
      most of it automatically (the program deduces some aspects of
      the layout from the sizes of the panels).
    </p>
    <p>
      The printable version uses different graphic files&mdash;the
      300-dpi ones&mdash;but the information used to lay out the page
      is extracted from the same XML file as is used to generate the
      HTML pages.  The ReportLab Toolkit uses <a
      href="http://python.org/">Python</a>, so my script processes the
      files using <a
      href="http://effbot.org/zone/element-index.htm">Fredrik
      Lundh&rsquo;s elementtree package</a>, which gives a more
      Pythonic interface to <abbr>XML</abbr> than the usual <abbr title="Document
      Object-Model">DOM</abbr>.  It also uses <a
      href="http://www.pythonware.com/products/pil/"><abbr title="the
      Python Imaging Library">PIL</abbr></a> (also created by Fredrik
      Lundh) to handle the graphics themselves.
    </p>
    <p>
      The <a href="../../2005/percy/percy.xml"><abbr>XML</abbr> description of the comic</a>
      is rather dull reading.  It divides the strip in to pages, the
      pages in to tiers, and the tiers in to frames.  Each frame is a
      separate image.  To generate <a href="../../2005/percy/1/">the
      HTML version</a>, the tiers are converted to HTML
      <code>div</code>s using a <a
      href="http://www.w3.org/TR/xslt"><abbr title="XML Style-sheet
      Language&mdash;Transform">XSLT</abbr></a> file <a
      href="../../2005/percy/striptoxhtml.xslt"><code>striptoxhtml.xslt</code></a>.
      A little jiggery-pokery with <abbr title="Cascading Style
      Sheets">CSS</abbr> is required to get the layout to fit together
      exactly as I&nbsp;want it to.  The dimensions have to be
      carefully judged so that a tier with, say, three panels with
      borders and gutters between adds up to the exact same number of
      pixels as the adjacent tier with only two panels.  The XSLT
      processing is done using the very convenient XSLT plug-in to <a
      href="http://www.jedit.org/">jEdit</a>.
    </p>
    <p>
      With the PDF version, my program calculates  the positions of the
      pictures so they line up nicely.  
      There is one tricky bit.  In most cases, the frames in a tier
      are all of the same height.  The exception is on 
      <a href="../../2005/percy/3/">page 3</a>, which has two smaller
      frames, one above the other.  In the HTML version, this is
      achieved through  use of the <code>float</code> property of the
      images.  In my program it took me an extra afternoon of
      fiddling to get things to come out right.  Luckily I can depend
      on various things, such as the first frame being the one that
      defines the height of the tier (because to do otherwise would
      confuse readers because of the way frames are read from left to
      right).  
    </p>
    <p>
      Here is <a title="percy.pdf: 2.5M PDF file"
      href="../../2005/percy/percy.pdf">sample PDF output</a> using a mixture of
      the screen-resolution and printer-resolution images (it should
      be obvious which pages are which).  There now remains the
      tedious task of converting the individual frames (in
      Painter&rsquo;s proprietary format) in to high-resolution <abbr
      title="Compuserv Graphics Interchange Format">GIF</abbr>s...
    </p>
    <p>
		<strong>Update (10 Dec. 2005).</strong>
		<a href="../../2005/percy/"><cite>Percy Street</cite></a> is now being
		drawn under a pseudonym Leckford; for updates see <a
		href="http://www.livejournal.com/users/leckford/">Leckford&rsquo;s LiveJournal</a>.
    </p>
  </body>
  <dc:subject>percy</dc:subject>
  <dc:subject>pil</dc:subject>
  <dc:subject>python</dc:subject>
</entry>
