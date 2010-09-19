<!-- -*-HTML-*- -->
<entry date="20021031" icon="../1998/wp-64x64.png">
  <h>RSS valid, again (ahem)</h>
  <body>
    <p>
      My <a href="rss091.xml"><abbr title="Really Simple
      Syndication">RSS</abbr>&nbsp;0.9x</a> feed failed to validate
      after my last entry&mdash;because I&nbsp;included an HTML&nbsp;4
      character entity in the title.  (I&nbsp;used
      <code>&amp;mdash;</code> to create an em-dash.)  This is OK for
      HTML, but forbidden in RSS.  I&nbsp;have fixed the script that
      generates the file so it converts these entities in to the
      corresponding Unicode character.  Sorry for any inconvenience.
    </p>
  </body>
  <dc:subject>rss</dc:subject>
  <dc:subject>validation</dc:subject>
</entry>
