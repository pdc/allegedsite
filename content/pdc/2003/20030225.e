<!-- -*-HTML-*- -->
<entry date="20030225" icon="../wp/icon-64x64.png">
  <h>Now with added subjects</h>
  <body>
    <p>
      I have added a rudimentary subject-tagging scheme to the system
      I&nbsp;use to publish these web pages.  Not <a
      href="http://xfml.org/">Faceted Metadata</a>, not <a
      href="http://topicmaps.org/">Topic Maps</a>, just subject
      elements in the style of <a href="http://dublincore.org/">the
      Dublin Core</a>.  My &lsquo;database&rsquo; of entries are just
      files on disc, and they can now have <code>dc:subject</code>
      elements using topic names from an ad-hoc taxonomy (that is a
      fancy way of saying I&nbsp;just make up the topic names as
      I&nbsp;go alonmg).  The
      Tcl script that generates <a
      href="subjects.html">subjects.html</a> scans all the files for
      such elements and builds up its database of links in-memory.  It
      then writes all the index pages automatically.
    </p>
    <p>
      Only entries I&nbsp;have taken the time to tag with subjects
      will be included, of course.
    </p>
  </body>
  <dc:subject>programming</dc:subject>
  <dc:subject>web</dc:subject>
</entry>
