<!-- -*-HTML-*- -->
<entry date="20040201" icon="../icon-64x64.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>Fucking print my fucking file, or: When will  Microsoft Windows
  be ready for
  the Desktop?</h>
  <body>
    <p>
      All I&nbsp;want to do is print my fucking graphics files at a
      particular size on the fucking page.  Nothing fancy.   This image
      at this position at this size.  That image at that position at
      that size.  
    </p>
    <p>
      I&nbsp;have writen a program that creates a <abbr
      title="Portable Document Format">PDF</abbr>.  My PowerBook can
      display the PDF, but since it will not connect to my network
      printer I&nbsp;cannot print it.  Jeremy&rsquo;s NT box can print
      but it cannot handle the PDF.  My Linux box has a version of
      GhostView that can view PDFs but it cannot read my PDF either.
      I&nbsp;think the problem is that the PDF format has undergone
      several enhancements over the years and my PDF-generating
      program is using some newfangled format the other computers
      cannot grok (both the NT box and the Linux box being full of
      very outdated software).  I&nbsp;am pretty sure I&nbsp;do not
      <em>need</em> any special PDF features to create my document.
      Is there a way to convert a new-format PDF to an old-format PDF?
      And why the hell are new versions of PDF incompatible with old
      viewers?  Why can&rsquo;t that at least display the parts of the
      document not using new features?  Why do they have to crash?
      Why can&rsquo;t anyone write a viewer that does not crash all
      the fucking time?
    </p>
    <p>
      I&nbsp;have written a program (actually an <abbr
      title="Extensibe Style Sheets&mdash;Transform">XSLT</abbr>) that
      uses <abbr title="Structured Vector Graphics">SVG</abbr> to lay
      out the graphics.  All very simple stuff; the file has on its
      outermost <code>svg</code> element the attributes
      <code>width="148mm" height="210mm"</code>.  All very simple.  As
      documented in the SVG specification.  I&nbsp;can view this SVG
      on Jeremy&rsquo;s Windows-NT box.  When I&nbsp;print it, it
      comes out 115&nbsp;mm wide and longer than the page (stretched
      so that the pictures look absurdly thin).  What the fuck?  What
      the fucking fucking fucking fucking fucking fucking fucking
      fucking fuck is this fucking shit!?  The size of the fucking
      picture is explictly specified.  The printer is a PostScript
      printer.  The SVG vewier plug-in is written by Adobe, the people
      who specified the PostScript language, the people who contribued
      most of the printing know-how to the SVG specification, the
      people who wrote Appendix&nbsp;G of the Red Book that describes
      very clearly and in detail how printer drivers and printing
      programs can communicate with each other the requirements of the
      picture and in particular the dimensions of the fucking page.
      So what went wrong?
    </p>
    <p>
      For that matter, why can&rsquo;t <abbr
      title="Macintosh">Mac</abbr>&nbsp;<abbr title="Operating
      System">OS</abbr>&nbsp;<abbr title="Ten">X</abbr> talk to my
      network printer?  The <abbr title="Line Printer">LPR</abbr>
      protocol is not exactly a new idea.  Mac OS&nbsp;9 supported it
      (on and off, admitedly).  Why can&rsquo;t it just print to my
      printer?  Why can&rsquo;t I&nbsp;just tell it that there is a
      PostScript printer called <code>lp</code> on this machine and
      have it talk to the printer queue daemon and if that fails tell
      me exactly what stage in the printing stack has failed so
      I&nbsp;can fucking fix it?
    </p>
    <p>
      It&rsquo;s the year 2004 for fuck&rsquo;s sake.  Printers with
      Level&nbsp;2 PostScript date back to the early 1990s.  This is
      not fucking rocket science.  I&nbsp;am not asking for flying
      cars or moon bases or protein pills.  I&nbsp;just want to be
      able, with minimal fuss, to print a document containing some
      words and some pictures.  Why is this still beyond us?  Why?
    </p>
  </body>
  <dc:subject>macosx</dc:subject>
  <dc:subject>pdf</dc:subject>
  <dc:subject>svg</dc:subject>
  <dc:subject>nt</dc:subject>
</entry>
