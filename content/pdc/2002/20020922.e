<!-- -*-HTML-*- -->
<entry date="20020922" icon="../icon-64x64.png">
  <h>Thinking about Topic Maps and dates</h>
  <body>
    <p>
      I&nbsp;had an idle thought about using topic-maps&rsquo;
      processing model (or even topic maps themselves) to represent
      the information encoded in <abbr title="Really Simple
      Syndication">RSS</abbr> and <abbr title="RDF Site
      Summary">RSS</abbr> data resources.  The attraction is that
      topic maps have a concept of merging built in, so writing an
      aggregator would in principle be straightforward.  
    </p>

    <p>
      Obviously stories are topics, and categories are topics.  What
      about dates?  These become what in topic-maps are called
      occurences (the concept of occurrence is stretched a little).
      I&nbsp;assume any topic-map query-engine is willing to do
      grouping and sorting on  topics according to occurrence values?
    </p>

    <p>
      This got me thinking about dates in metadata.  Most metadata
      examples I&rsquo;ve seen use what might be called free-form
      dates.  This is perhaps OK within one, isolated database, but
      when I&nbsp;am merging two topic-maps, how does my
      computer&nbsp;know how to compare dates in random formats like
      <code>13 Oct 02</code> and <code>2002-09-22</code>?  I&nbsp;would
      rather not rely on the cute guessing games that programs like
      Microsoft&reg; Excel resort to (e.g., if I&nbsp;enter 12-09-2002
      and 13-09-2002 in separate cells, they end up holding
      9&nbsp;December and 13&nbsp;September).
    </p>

    <p>
      My suggestion is that the occurrence-types that subclass special
      topics that are conventionally used for dates in particular
      formats.  These special topics in turn would require published
      subject indicators.  I&nbsp;have created a page that contains <a
      href="../../2002/datetime.html">PSIs for Date-Time occurrence
      types</a> to illustrate the idea.  Note! this is just for
      discussion.  Also, it really needs an attached
      machine-processable metadata resource (in <abbr title="XML Topic
      Map">XTM</abbr>, say).
    </p>

    <p>
      Another slightly weird approach would be to reify the dates.
      That is, create topics representing the dates themselves.  The
      relationship between story and the date it is published on then
      is represented as an association between the story topic and the
      date topic.  Date topics would use PSIs with a format like
      <code>http://psi.example.com/2002/date/#2002-09-22</code> or
      <code>http://psi.example.com/2002/date/?d=2002-09-22</code> (the
      latter has the advantage of being able to run a check on the
      format of its param).  Probably less efficient than using occurences.
    </p>
  </body>
</entry>
