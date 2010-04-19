<!-- -*-HTML-*- -->
<entry date="20031008" icon="web-server.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>Capturing XML output from ADO using a Stream object</h>
  <body>
    <p>
      I&nbsp;will describe here the solution to a problem that taxed me at
      work this week, in the faint hope that it will prove useful to
      someone else who needs to do the same strange thing.
    </p>
    <p>
      The web application I&nbsp;am working on uses <abbr
      title="Standard Query Language">SQL</abbr> stored procedures to
      do all the work.  I&nbsp;use the <a
      href="http://msdn.microsoft.com/library/en-us/xmlsql/ac_openxml_1hd8.asp"><code>FOR
      XML</code> extension</a> of <a
      href="http://www.microsoft.com/sql/">Microsoft SQL Server
      2000</a> so that the results emerge in <abbr title="Extensible
      Mark-up Language">XML</abbr> format rather than the usual
      collection of records.
    </p>
    <p>
      This is all mediated through <a href="http://www.microsoft.com/ado/">Microsoft&rsquo;s <abbr
      title="Microsoft ActiveX Data Objects">ADO</abbr> conventions</a>.
      The way this works is that you create an ADO
      <code>Command</code> object as usual, and use the special
      property called <code>Properties</code> to set certain special
      parameters.  (It is not obvious why these are not implemented as
      regular properties.)  One of the special properties is
      <code>XSL</code>, which names an <abbr title="Extensible
      Stylesheet Language: Transform">XSLT</abbr> resource that is
      used to convert the raw XML emitted by SQL Server in to
      something more useful, such as HTML.  Another special property
      called <code>Output Stream</code> is used to plumb the output
      straight to the <abbr title="Microsoft ActiveX Server
      Pages">ASP</abbr> <code>Response</code> object:
    </p>
    <pre>cmd.Properties("XML Root") = "foo"
cmd.Properties("XSL") = xslDir &amp; theme &amp; "/foo.xslt"
cmd.Properties("Output Stream") = Response</pre>
    <p>
      You then execute the command passing the
      <code>adExecuteStream</code> flag and all is well.  We can
      describe this with a <a
      href="http://cocoon.apache.org/">Cocoon</a>-style pipeline:
    </p>
    <blockquote><div><img src="pipeline-1.png" width="390" height="94"
    alt="(diagram)" /></div></blockquote>
    <p>
      The advantage of this set-up is that it reduces the <a
      href="http://www.microsoft.com/vbscript/"><abbr title="Microsoft
      Visual Basic Scripting Edition">VBScript</abbr></a> portion of
      the application to the bare minimum needed to marshal the form
      parameters in to data that can be fed in to a SQL procedure and
      then execute the proc with its output transformed in to the HTML
      page.  The ASP pages actually contain no HTML at all: the
      application logic (such as it is) is all in SQL, and the
      appearance entirely controlled by the XSLT.
    </p>
    <p>
      Things got tricky when suddenly I&nbsp;wanted to have one page
      generate several flavours of output beyond the usual HTML, such as
      <abbr title="Portable Document Format">PDF</abbr>.
      I&nbsp;would need a software component to do this, and since
      ASP/VBScript was being used as the application glue, the
      component would have to be a 
      <abbr title="Microsoft Common Object Model">COM</abbr> 
      <abbr title="component class">coclass</abbr>.  But how to get
      the XML in to the component?  On the face of it there are three
      obvious ways to do this:
    </p>
    <ul>
      <li>
        The <code>Output Stream</code> property is set to my
        component, and it implements the stream
        interface that the ADO command object expects.
      </li>
      <li>
        The ADO command might be persuaded to expose the XML as a
        <em>readable</em> stream (client pull rather than server
        push).  The new component would then read its data from this.  
      </li>
      <li>
        Find the equivalent of a C++ <code>stringstream</code> or
        Python <code>StringIO</code>&mdash;something that pretends to
        be an output stream but instead buffers the XML data in
        memory.  The XML is then sent to the new component as a string
        parameter.
      </li>
    </ul>
    <p>
      In theory the first option is the best from the point of view of
      pipelining:
    </p>
    <blockquote><div><img src="pipeline-2.png" width="390" height="94"
    alt="(diagram)" /></div></blockquote>
    <p> 
      Unfortunately the documentation was maddeningly vague as to
      how to implement the stream interface.  The SQL Server
      documentation said &lsquo;<abbr title="Microsoft Object Linking
      and Embedding Database">OLEDB</abbr> stream&rsquo;, the OLEDB
      documentation alluded to <code>IStream</code>, which turns out
      to mean a bundle of half-a-dozen custom COM interfaces...
      Blurk.  No way to do <em>this</em> in five minutes.  (This
      contrasts badly with Python&rsquo;s use of &lsquo;file-like
      objects&rsquo; which just need to implement a few simple methods
      like <code>write</code>.)
    </p>
    <p>
      The second option, where my program reads from the ADO object,
      rather than it writing to stream, does not seem possible.  With
      ADO&nbsp;.NET you can execute a command in a fashion that
      returns a reader object, but I&nbsp;could not crack this with ADO.
      Oh, well.
    </p>
    <p>
      The last of these has the advantage of conceptual simplicity at
      the expense of storing the whole XML document in memory at once:
    </p>
    <blockquote><div><img src="pipeline-3.png" width="435" height="226"
    alt="(diagram)" /></div></blockquote>
    <p>    
      In practice this should not be a problem, since the data would
      not be over-large.  So all I&nbsp;needed was the buffer object.  The
      SQL Server documentation mentions an ADO class
      <code>Stream</code>.  It has no information about the methods or
      properties of the <code>Stream</code> class, but  something like
      this should work, right?:
    </p>
    <pre>Dim strm
Set strm = Server.CreateObject("ADODB.Stream")
cmd.Properties("Output Stream") = strm
cmd.Execute ,, adCmdStoredProc Or adExecuteStream
... read stream somehow ...</pre>
    <p>
      Unfortunately this causes the script to fail with the usual
      frustratingly ambiguous error message from ADO.  I&nbsp;spent
      ages trying different variations, Googling for hints, and
      retrying the discarded ideas from earlier, before I&nbsp;found a
      page that mentioned that you have to call <code>strm.Open</code>
      before it will work.  Why?  You just do.
    </p>
    <pre>Dim strm
Set strm = Server.CreateObject("ADODB.Stream")
<strong>strm.Open</strong>
cmd.Properties("Output Stream") = strm
cmd.Execute ,, adCmdStoredProc Or adExecuteStream
strm.Position = 0
text = strm.ReadText
strm.Close</pre>
    <p>
      Now all that remains is the minor task of writing a COM
      component that exposes a method <code>MakePdfWriteToStream</code>
      along the following lines:
    </p>
    <pre>Dim pdfMaker
Set pdfMaker = Server.CreateObject("myproject.PdfMaker")
pdfMaker.MakePdfWriteToStream(Response)</pre>
    <p>
      But that&rsquo;s another story.
    </p>
  </body>
  <dc:subject>pdf</dc:subject>
  <dc:subject>asp</dc:subject>
  <dc:subject>ado</dc:subject>
  <dc:subject>sqlserver</dc:subject>
  <dc:subject>xml</dc:subject>
  <dc:subject>xslt</dc:subject>
  <dc:subject>work</dc:subject>
</entry>
