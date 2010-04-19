<!-- -*-HTML-*- -->
<entry date="20031009" icon="web-server.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>ASP&rsquo;s Response.Write disaster</h>
  <body>
    <p>
      Were you foolish enough to be creating a web application with <a
      href="http://www.microsoft.com/asp/"><abbr title="Microsoft
      ActiveX Server pages">ASP</abbr></a>, then you will be used to
      using the <code>Write</code> method of the <code>Response</code>
      object to stream HTML to the web browser of your client.  Today
      I got caught out by a serious limitation of the implementation
      of <code>Response.Write</code>.  (And this is not the first time
      it has leapt out and bit me, either.)
    </p>
    <p>
      The fundamental problem is caused by a decision made when
      designing <abbr title="Microsoft Common Object Model">COM</abbr>
      all those years ago.  Micrsoft intended, sensibly enough, that
      all character data processed by COM objects should use Unicode,
      which, at the time, could be all represented correctly using
      16-bit integers (Unicode version 3 breaks this, but that is
      another story).  The COM convention is that all strings are
      passed as UTF-16LE.  Most software still represented strings as
      byte sequences; Europeans with one byte per character, the
      Asians using variable-length multi-byte sequences.  Calling COM
      methods always requires transcoding between the legacy encoding
      and UTF-16.  
    </p>
    <p>
      Thus the <code>Response.Write</code> method is designed to
      consume character data (supplied as UTF-16), even though it
      immediately encodes as whatever single-byte (or <abbr
      title="multi-byte character set">MBCS</abbr>) encoding
      is the default on your computer.  Thus an ASP page served by a
      British computer, say, will convert the character data to the <a
      href="http://www.unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1252.TXT">Windows-1252
      encoding</a>:
    </p>
    <table>
        <tr>
			<th align="left">Characters</th>
			<td>&lsquo;</td>
			<td>Z</td>
			<td>o</td>
			<td>&euml;</td>
			<td>&rsquo;</td>
		</tr>
        <tr>
			<th align="left">Unicode</th>
			<td>2018</td>
			<td>005A</td>
			<td>006F</td>
			<td>00CB</td>
			<td>2019</td>
		</tr>
        <tr>
			<th align="left">Windows-1252</th>
			<td>0x91</td>
			<td>0x5A</td>
			<td>0x6F</td>
			<td>0xCB</td>
			<td>0x92</td>
		</tr>
    </table>
    <p>
      So long as you
      only want to generate character data in Windows-1252 then that
      is OK.  But there are times when this is not what you want.
    </p>
    <p>
      On a European Union web site one may want to be able to generate
      text that includes both Greek and Latin scripts.  The only
      sensible way to do this is to use <a
      href="http://www.utf-8.com/">UTF-8</a>.  Writing a function to
      convert Unicode character data to a byte sequence is simple
      enough (in fact, recent versions of the Win32 API have a
      function that does it for you):
    </p>
    <table>
        <tr><th align="left">Characters</th><td>&lsquo;</td><td>Z</td><td>o</td><td>&euml;</td><td>&rsquo;</td></tr>
        <tr><th align="left">Unicode</th><td>2018</td><td>005A</td><td>006F</td><td>00CB</td><td>2019</td></tr>
        <tr><th align="left">UTF-8</th><td>E2 80
        98</td><td>5A</td><td>6F</td><td>C3 8B</td><td>E2 80 98</td></tr>
    </table>
    <p>
      But, having generated a byte
      sequence, how do you make the <code>Response</code> object pass
      the bytes unchanged to the recipient?
    </p>
    <p>
      Theoretically you can transmit data verbatim by passing it to
      <code>Response.BinaryWrite</code>.  For this, you need to create
      data of type &lsquo;variant containing array of byte&rsquo;,
      which is something of a tall order in VBScript.  By writing a
      COM component in a language like C++, one can create a
      <code>VARIANT</code>, and a <code>SAFEARRAY</code> and copy
      buffers around and generally write about 25 lines of code in
      order to create a byte sequence you can pass to VBScript, which
      it can then pass to <code>Response.BinaryWrite</code>.
      I&nbsp;have done this in the past, and it really is an
      unreasonable amount of work.  What&rsquo;s more, the <abbr
      title="Microsoft Visual Basic">VB</abbr> programmers will not
      thank you for it, because working with byte arrays is even more
      inconvenient in VB than working with strings.
    </p>
    <p>
      In practice I have used a trick that works fairly well.
      Remember that <code>Response.Write</code> applies the Win32 encoding
      routine (called <code>WideCharToMultiByte</code>) to the data
      you pass to it.  So we convert our byte sequence to character
      data using the reverse function,
      <code>MultiByteToWideChar</code>:
    </p>
    <table>
        <tr><th align="left">Windows-1252</th><td>E2</td><td>80</td><td>
        98</td><td>5A</td><td>6F</td><td>C3</td><td>8B</td><td>E2</td><td>80</td><td>99</td></tr>
        <tr><th align="left">Unicode</th><td>00E2</td><td>20AC</td><td>
        02DC</td><td>005A</td><td>006F</td><td>00C3</td><td>2039</td><td>00E2</td><td>20AC</td><td>2122</td></tr>
        <tr><th align="left">Characters</th><td>&#x00E2;</td><td>&#x20AC;</td><td>
        &#x02DC;</td><td>&#x005A;</td><td>&#x006F;</td><td>&#x00C3;</td><td>&#x2039;</td><td>&#x00E2;</td><td>&#x20AC;</td><td>&#x2122;</td></tr>
    </table>
    <p>
      When this is run through the transcoder again, the UTF-8 byte
      sequence is restored.  The web browser will decode it to
      generate the original character data.  Or, if it does not
      realize the data is in UTF-8 format, it may display the
      gibberish characters shown above.
    </p>
    <p>
      In general, if you have a byte sequence you have to pass over a
      COM boundary, you will end up using this kludge.  Mostly this
      works and no-one notices the continual transcodings back and
      forth between MBCS and Unicode.  <a
      href="http://starship.python.org/crew/mhammond/">Mark
      Hammond&rsquo;s Win32 extensions for Python</a> use the same
      technique when passing Python strings (= byte sequences) through
      the COM barrier (Unicode strings get passed unchanged).
    </p>
    <p>
      To extend ASP to generate <abbr title="Portable Document Format">PDF</abbr>,
      I&nbsp;wanted to create the COM component in <a
      href="http://www.python.org/">Python</a>, partly because that
      way we can use <a
      href="http://www.reportlab.com/">ReportLab</a>&rsquo;s excellent
      <a href="http://www.reportlab.org/">PDF toolkit</a>.
      After some frustration before I worked out that the
      <code>_reg_clsctx_</code> attribute of the Python class needs to
      be set to <code>pythoncom.CLSCTX_LOCAL_SERVER</code>.  The
      default value causes ASP to display an error message, which is,
      as usual, meaningless.  Apart from that, <a title="Chapter 12 of
      Python Programming in Win32" href="http://www.oreilly.com/catalog/pythonwin32/chapter/ch12.html">creating COM servers in
      Python</a> is pretty straightforward.  Having written COM servers in
      C++ before now, I&nbsp;am very impressed at how easy Mark
      Hammond makes it look.   
    </p>
    <p>
      I spent a day, more or less, on working out how to do two apparently
      trivial things: <a
      href="10/08.html#e20031008">intercept the  XML data
      stream</a> and pass it to my Python code (via COM).  That done,
      it was pretty smooth sailing for a bit, using <a href="http://effbot.org/zone/element-index.htm">Fredrik
      Lundh&rsquo;s elementtree package</a> to parse the XML and
      ReportLab&rsquo;s PLATYPUS to render it as PDF.  Everthing was
      going swimmingly.  
    </p>
    <p>
      Then suddenly it all went wrong again.  First ASP errors
      (probably caused by a typo) but then I discovered that whenever
      I visited the PDF page, Adobe Acrobat Reader complaied that the
      file was corrupt.  Oh no!  I changed the script to set its
      content-type to <code>text/plain</code>, so I could see the raw
      PDF data.  It was strangely short. 
      I changed the script so that it
      printed the number of characters (representing bytes) returned
      by my COM object.  The total was still correct.  Somehow I was
      feeding 52K of data in to <code>Response.Write</code> and only
      2K was coming out.    My best guess is that PDF files can
      contain zero bytes, and that <code>Response.Write</code> treats
      its argument as a 0-terminated string
      (even though it is a <code>BSTR</code>, which includes a
      character count).  Amateurs.  I am going to have to come up with
      a new way of getting my bytes out of Python and on to the WWW.
    </p>
    <p>
      In conclusion, the trick I described above works OK, so long as
      your byte sequence contains noi zeros.  When your bytes
      originate as some form of character data that will definitely be
      the case, so don&rsquo;t worry.  Just do not expect ASP to be
      any good for binary formats like PDF.
    </p>
    <p>
      Next time I could try writing the whole server from scratch in
      Python and hope my bossess don&rsquo;t notice.
    </p>
  </body>
  <dc:subject>python</dc:subject>
  <dc:subject>pdf</dc:subject>
  <dc:subject>asp</dc:subject>
  <dc:subject>utf8</dc:subject>
  <dc:subject>reportlab</dc:subject>
  <dc:subject>elementtree</dc:subject>
</entry>
