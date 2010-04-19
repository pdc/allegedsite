<!-- -*-HTML-*- -->
<entry date="20020213" icon="tarot/wands-2-64x64.png">
  <h>SVG interaction sans Javascript</h>
  <body>
    <p>
      In my <a href="tarot/">SVG tarot deck</a>, I&nbsp;could not
      decide between drawing the pips cards plain or with pictures
      on, so I&nbsp;added a button to toggle the picture on and off.
      People using Adobe&rsquo;s SVG plug-in version&nbsp;2 have reported
      problems with the Javascript&mdash;something about its not
      understanding <code>getElementById</code>.  I&nbsp;did not want
      to start getting in to an endless struggle to remain compatible
      with what is after all an obsolete browser (version 3 is
      available gratis from Adobe); I&nbsp;have enough compatibility
      nightmares with HTML on Netscape Navigator&nbsp;4.  But it
      occurred to me to try to instead use SVG&rsquo;s built-in
      animation features, so that I&nbsp;was not using Javascript at
      all.  I&nbsp;hope that I&nbsp;can thereby avoid causing trouble
      on older SVG viewers, since they presumably will simply ignore
      the animation elements.
    </p>
    <p>
      <a href="http://www.xml.com/pub/a/2002/01/23/svg/">More on
      SVG&rsquo;s intrinsic animations (XML.com)</a>.
    </p>
  </body>
  <dc:subject>tarot</dc:subject>
</entry>
