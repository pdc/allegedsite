<!-- -*-HTML-*- -->
<entry date="20021017" icon="../1998/wp-64x64.png">
  <h>Must ... ignore ... HLink!</h>
  <body>
    <p>
      <a href="http://www.xml.com/pub/a/2002/10/02/deviant.html">The
      <abbr title="Technical Architecture Group">TAG</abbr>
      rejects HLink, not many dead</a>
      scream the headlines.  Is this the end for XHTML&nbsp;2?
    </p>
    <p>
      What&rsquo;s XHTML&nbsp;2?  It is the next step in the bridge
      from <abbr title="Hypertext Mark-up
      Language">HTML</abbr>&nbsp;4.01 to the futuristic world of
      &lsquo;pure&rsquo; XML documents.  <a href="http://www.w3.org/TR/2001/REC-xlink-20010627/">XLink</a> is a recommendation
      from the W3C for how XML documents should express links to other
      resources.  HLink is a new proposal from the XHTML committee for how
      XML documents should express links to other resources.  In
      effect, they are saying  that XLink is inadequate and they need
      to replace it.  <abbr title="Technical Architecture
      Group">TAG</abbr>
      <a
      href="http://lists.w3.org/Archives/Public/www-tag/2002Sep/0183.html">have
      expressed an opinion that XLink should be used instead</a>,
      presumably on the grounds that we don&rsquo;t want to have
      <em>two</em> W3C recommendations for one and the same thing.  
    </p>
    <p>
      Can XLink replace the special-purpose linking attributes in
      HTML?  I&nbsp;suppose we can imagine replacing <code>img</code>
      and <code>object</code>
      tags with something like
    </p>
    <pre>&lt;object
    xlink:type="simple"
    xlink:show="embed"
    xlink:actuate="onLoad"
    xlink:href=&quot;myLogo.gif"
    width="400" height="300"&gt;
  My Logo
&lt;/object&gt;</pre>

    <p>
      In principal the first three attributes (which would be the same
      for all images) can be given default values in the <abbr title="Document-Type Definition">DTD</abbr>.  This is
      the approach used in <abbr title="Scalar Vector Graphics">SVG</abbr>
      and <abbr title="Meths Mark-up Language">MathML</abbr>.
       The problem is that it
      prevents the XML document in question from being stand-alone.
      That is, the <abbr title="Document-Type Definition">DTD</abbr> must be downloaded and parsed before the
      document can be rendered.  <abbr title="Scalar Vector Graphics">SVG</abbr> fudges this; <abbr title="Scalar Vector Graphics">SVG</abbr> documents often do
      not have <code>DOCTYPE</code>s, and <abbr title="Scalar Vector Graphics">SVG</abbr> viewers 
      in effect use a <abbr title="Document-Type Definition">DTD</abbr> compiled in to the software.  All very messy.  
    </p>
    <p>
      There&rsquo;s another problem: the HTML tag <code>img</code>
      also allows for <abbr title="Uniform Resource
      Identifier">URI</abbr>s for the low-res version
      (<code>lowsrc</code> attribute), a long description
      (<code>longdesc</code>), and an client-side image-map
      (<code>usemap</code>).  <abbr title="Extensible Hypertext
      Mark-up Language">XHTML</abbr>&nbsp;2 also wants to add an
      <code>href</code> attribute to all elements (so any element in
      the document can be a link).  I&rsquo;m not sure that XLink
      defines <code>xlink:show</code> values for all of these.  Even
      if it does, we cannot have more than one simple XLink link per
      element (since we can only have one <code>xlink:href</code>
      attribute).  We could possibly follow the same system as <a
      href="http://www.topicmaps.org/xtm/1.0/"><abbr title="XML Topic
      Maps">XTM</abbr></a>, with one child element per link:
    </p>
    <pre>&lt;object style="width:400px; height:300px;"&gt;
  &lt;source xlink:href=&quot;myLogo.gif"/&gt;
  &lt;usemap xlink:href=&quot;#logoMap"/&gt;
  [My Logo]
&lt;/object&gt;</pre>
    <p>
      (Here we are assuming that the <abbr title="Document-Type Definition">DTD</abbr> is used to generate default
      values for the other Xlink attributes&mdash;but do we really
      want to rely on all XML browsers being <em>validating</em>
      browsers...?)
    </p>

    <p>
      The question is, will this work?  Yes, if we are using a
      specialized XHTML-2-savvy browser (one which understands
      <code>object</code> and <code>source</code>, and knows how to
      interpret them).  If the aim is to make XHTML&nbsp;2
      implementable using <em>only</em> XML + <abbr title="Cascading
      Style Sheets">CSS</abbr>&nbsp;2 + XLink + XBase, <em>without
      making XHTML a special case</em>, then the answer is no.
    </p>

    <p>
      The upshot of this is that, if the 
      <abbr title="World-Wide Web Consortium">W3C</abbr> want to make 
      XHTML&nbsp;2 just another XML format, displayable in a generic
      XML browser, then it looks like XLink is not quite right for the
      job.  It may well be that I&nbsp;am missing something, and the
      above example can be reworked to work with XLink.  It might be
      that <code>lowsrc</code> and <code>longdesc</code> are dumb
      features that no-one wants to carry over in to XHTML&nbsp;2
      anyway.  But my na&iuml;ve understanding of XLink and the nascent 
      XHTML&nbsp;2 suggests that the XHTML working group might have a
      point.  
    </p>

    <p>
      How is this going to end?  Right now it looks to an outsider
      like the question is being discussed less in terms of technical
      issues like what XHTML&rsquo;s goals are, and more in terms of
      committees and procedure and politics and such-like.  We may end
      up with an XHTML&nbsp;2 that requires a specialized XHTML&nbsp;2
      browser (requiring upgrades to existing browsers that recognize
      the XML namespaces or the <code>DOCTYPE</code>, or any of the
      other stupid heuristics in use today to distinguish different
      flavours of HTML).  The dawn of XML as a fully-fledged hypertext
      mark-up language will delayed by a few more years...
    </p>

    <p>
      I&nbsp;really should not be writing about this&mdash;I&nbsp;have
      plenty of other things to work on.  I&nbsp;just find it
      difficult to tune out all these arguments about XHTML when
      that&rsquo;s what I&nbsp;work with every day...
    </p>
  </body>
  <dc:subject>xmtml2</dc:subject>
    <dc:subject>hlink</dc:subject>
    <dc:subject>xml</dc:subject>
    <dc:subject>standards</dc:subject>
</entry>




