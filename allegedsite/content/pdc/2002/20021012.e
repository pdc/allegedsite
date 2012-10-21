<!-- -*-HTML-*- -->
<entry date="20021012" icon="../1998/wp-64x64.png">
  <h>Namespaces annoyances in RSS</h>
  <body>
    <p>
      In an <a href="09.html#e20020912">earlier note</a> I&nbsp;listed
      four namespaces used in
      <abbr title="Really Simple Syndication">RSS</abbr> and <abbr
      title="RDF Site Summary">RSS</abbr> for the same element names.
      One of these has now been unmade: the <a
      href="http://backend.userland.com/rss"><abbr title="Really
      Simple Syndication">RSS</abbr></a> specification never explicitly
      mentioned the namespace, but the sample file included an
      <code>xmlns</code> attribute.  While I&nbsp;was away in Canada,
      <a href="http://backend.userland.com/rss#extendingRss">this was
      removed</a> to ensure backward compatibility with
      RSS&nbsp;0.91.  This makes sense (there exist examples of
      applications that genuinely are  broken by this), but is kind of icky.
    </p>
    <p>
      There is still the old <abbr title="RDF Site
      Summary">RSS</abbr>&nbsp;0.9 format&mdash;which did use its own
      namespace&mdash;but given that even <abbr title="RDF Site
      Summary">RSS</abbr>&nbsp;1.0 did not preserve that, I&nbsp;think
      we can assume it is dead too.  I&nbsp;assume that the programs
      that were broken by the fleeting addition of the <abbr
      title="Really Simple Syndication">RSS</abbr>-2.0 namespace are
      also incapable of parsing <abbr title="RDF Site
      Summary">RSS</abbr>-1.0 data?
    </p>
    <p>
      I&nbsp;just tried printing a copy of the <abbr
      title="Really Simple Syndication">RSS</abbr>&nbsp;2.0 spec., but
      because he chose to use a fixed-width table for the text, it is
      clipped all down the right-hand side of the page, making it
      useless.  Goddammit!
    </p>
    <p>
      <strong>Update</strong> (2002-10-14): 
      I&nbsp;have removed the namespace declaration from 
      <a href="rss091.xml">my experimental RSS feed</a>.
    </p>
  </body>
  <dc:subject>rss</dc:subject>
    <dc:subject>xmlns</dc:subject>
    <dc:subject>alleged</dc:subject>
</entry>
