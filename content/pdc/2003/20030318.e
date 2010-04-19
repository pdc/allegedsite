<!-- -*-HTML-*- -->
<entry date="20030318" icon="../wp/icon-64x64.png">
  <h>LiveJournal, now with cool URLs</h>
  <body>
    <p>
      I have been scraping the <a
      href="http://livejournal.com/~pdc/">syndicated version of my 
      <abbr title="Really Simple Syndication">RSS</abbr>
      feed</a> on <a href="http://livejournal.com/">LiveJournal</a> in
      order to add comments links to my articles (not that anyone
      does).  They recently changed the format, so that
      (a)&nbsp;readers must click through to a second LJ page to find
      the link to click read the post itself, and (b)&nbsp;my scraper
      broke.  But that&rsquo;s their perogative, and offering a
      comment service to strangers who aren&rsquo;t even LiveJournal
      members is hardly part of their core mission, so I cannot fault
      them for it!
    </p>
    <p>
      They have also switched to using <a
      href="http://www.w3.org/Provider/Style/URI.html">&lsquo;cool&rsquo;
      <abbr title="Universal Resource-Locator">URL</abbr>s</a> (in the
      sense described by <a
      href="http://www.w3.org/People/Berners-Lee/">Tim Berners-Lee</a>
      in his <a href="http://www.w3.org/Provider/Style/"><cite>Style
      Guide to Online Hypertext</cite></a>) of the form
      <code>~pdc/1234.html</code> rather than
      <code>talkread.bml?this=that&amp;thother=1234</code>.  Apart from
      making the URLs shorter, this change means that the mechanism
      used to serve the files is now invisible, and can be altered
      without having to change the URLs in future.  It could even be
      (gasp!)&nbsp;static files generated once a night when they scan
      my RSS feed.
    </p>
  </body>
  <dc:subject>livejournal</dc:subject>
  <dc:subject>web</dc:subject>
</entry>
