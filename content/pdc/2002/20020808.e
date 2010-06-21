<!-- -*-HTML-*- -->
<entry date="20020808" icon="../wp/icon-64x64.png">
  <h>RSS 0.91 experiments</h>
  <body>
    <p>
      I have created <a href="../rss091.xml">an experimental RSS feed</a>
      (&lsquo;channel&rsquo;)
      for this site.  In principle this can be used by people with RSS
      aggregators to mix my latest headlines in with other channels.  
    </p>
    <p>
      The documentation for RSS I&nbsp;am using is 
      <a href="http://backend.userland.com/rss091">Dave
      Winer&rsquo;s</a>, because he is one of the few people to
      actually document it.  
      Erm,  except that I&nbsp;have taken the liberty of
      adding an XML namespace attribute
      (using the namespace mentioned in an article about
      RSS&nbsp;1.0).  
    </p>
    <p>
      I am using the <code>description</code> field to hold (part of)
      the first paragraph, by way of a teaser; readers are expected to
      follow the link to read the thing in full.
      I was a little surprised to discover that RSS&nbsp;0.91 has no
      provision for supplying a date for news items.  For weblog-style
      channels, this seems like a major omission!
    </p>
    <p>
      I also really dislike the RSS-0.91 de-facto convention of
      using escaped HTML text as the value of titles and
      descriptions.  For one thing, why not just embed HTML as-is
      instead of under an extra layer of encoding?  (That&rsquo;s the
      whole point of XML namespaces, for example...)  Worse, many
      people just grab the first 100, say, characters, regardless of
      whether decoding the result will be valid HTML or not!  This
      means that you cannot safely use XSLT to transform RSS&nbsp;0.91
      to HTML, unless I&nbsp;am missing something...
      Anyway, in my feed I&nbsp;am making a point of stripping out all
      mark-up before adding to the RSS file.  People who want to see
      it formatted will have to follow the link!
    </p>
  </body>
  <dc:subject>rss</dc:subject>
  <dc:subject>alleged</dc:subject>
</entry>