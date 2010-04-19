<!-- -*-HTML-*- -->
<entry date="20040204" icon="../icon-64x64.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>Mighty PostScript</h>
  <body>
    <p>
      The answer to the question posed rhetorically in my previous
      post is that Window&rsquo;s overcomplicated printing system is
      what lies between Adobe&rsquo;s SVG viewer and <a
      href="http://www.adobe.com/products/postscript/">Adobe&rsquo;s
      PostScript</a> interpreter in my printer.
    </p>
    <p>
      The <abbr title="Application-programming interface">API</abbr> of
      Microsoft Windows is horribly complicated by the fact that most
      of what they knew about graphics they learned from writing
      Microsoft Word.  They decided that printing should be just the
      same as rendering to the screen (because that&rsquo;s what Word
      needed), and as a result the GDI layer is stuffed full of
      second-guessing and really, really obscure features.  This is
      where the distinction between &lsquo;device&rsquo; and
      &lsquo;logical&rsquo; pixels comes in.  It also explains why
      when you implement an OLE custom control, the first thing you
      have to do is write a <code>Paint</code> method that does all
      sorts of hairy calculations to translate the fictional
      paper-based coordinate system in to actual screen pixels.  Even
      when your custom control is a pushbutton or (as it was when I
      was doing this) an interactive, scrolling map.  In order to
      allegedly make it easy to print documents, the graphics system
      has had extra features added, which means it is more complex,
      and so buggier and harder to use.
    </p>
    <p>
      If your response to this is that this system is how web pages
      can be printed, I refer you to my previous post, in which we
      discover that all this mess did <em>not</em> make it possible to
      print SVG merely by pretending a printer is the same as a screen.
    </p>
    <p>
      Anyway, as a Linux user, I have an alternative: convert my
      graphics to PostScript and send it direct to the printer via the
      printer queue.  This is less crazy that is sounds, but only
      because I have done enough PostScript programming in the past
      that I know a way to about it.  I also have a ten-year-old copy
      <cite>PostScript Language Reference Manual</cite> 2/e (the red
      book I alluded to earlier), an excellent guide to the PostScript
      Level 2 language, as understood by my printer.
    </p>
    <p>
      For the files in question (300-<abbr title="dots per
      inch">dpi</abbr>, colour <abbr title="Compuserve Graphics Interchange
      Format">GIF</abbr>s), it makes sense to try to reduce size of
      the image data in the PostScript document.  My current attempt
      goes like this:
    </p>
    <ul>
      <li>convert to greyscale (my printer is monochrome anyway);</li>
      <li>reduce the greyscale range to 0..15 (these pictures only use
      two shades of grey), and so squeeze two samples per byte;</li>
      <li>run-length encoding, to collapse long lines of the same
      colour;</li>
      <li>use ASCII85Encode rather than ASCIIHexEncode to convert the
      bytes to text (&times;1.25 expansion rather than &times;2).</li>
    </ul>
    <p>
      As a result in a sample page I get the following ratios
      (with the size of the GIF files added for comparison):
    </p>
    <table>
      <thead>
        <tr valign="bottom">
	  <th>Pixels</th>
	  <th>Characters</th>
	  <th>Pixels/Character</th>
	  <th>GIF size</th>
	</tr>
      </thead>
      <tbody>
        <tr valign="baseline" align="right">
          <td>718,662</td>
	  <td>168,580</td>
	  <td>4&middot;26</td>
	  <td>77,668</td>
        </tr>
        <tr valign="baseline" align="right">
          <td>724,446</td>
	  <td>187,171</td>
	  <td>3&middot;87</td>
	  <td>79,922</td>
        </tr>
        <tr valign="baseline" align="right">
          <td>724,446</td>
	  <td>124,088</td>
	  <td>5&middot;84</td>
	  <td>58,750</td>
        </tr>
        <tr valign="baseline" align="right">
          <td>541,926</td>
	  <td>137,209</td>
	  <td>3&middot;95</td>
	  <td>67,983</td>
        </tr>
        <tr valign="baseline" align="right">
          <td>541,926</td>
	  <td>87,532</td>
	  <td>6&middot;19</td>
	  <td>43,859</td>
        </tr>
      </tbody>
    </table>
    <p>
      The PostScript is 694&nbsp;KB (compressed 435&nbsp;KB), which
      compares well with the 2553&nbsp;KB of the PDF version of a
      similar page, though not so well with the 332&nbsp;KB of the
      <abbr title="scalar vector graphics">SVG</abbr> version.
      I&nbsp;could probably risk using binary data rather than one of
      the ASCII encodings and reduce the size of my PostScript data by
      almost 20%.
    </p>
  </body>
  <dc:subject>postscript</dc:subject>
  <dc:subject>percy</dc:subject>
</entry>
