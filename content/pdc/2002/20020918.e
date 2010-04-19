<!-- -*-HTML-*- -->
<entry date="20020918" icon="../icon-64x64.png" href="http://www.topicmaps.org/">
  <h>Topic Maps</h>
  <body>
    <p>
      I&rsquo;ve been <a href="http://www.xml.com/pub/a/2002/09/11/topicmaps.html">reading</a> about 
      <a href="http://www.topicmaps.org/">Topic Maps</a>,
      an 
      <abbr title="International Organization for Standardization">ISO</abbr>
      standard that has been augmented with an 
      <a href="http://www.topicmaps.org/xtm/1.0/">XML
      representation</a>.  
    </p>

    <p>
      Topic maps are very similar to the <abbr
      title="Resource-Description Framework">RDF</abbr>, in that they
      are all about graphs of topics (representing real-world
      subjects) connected with associations.  The difference is that
      the Topic-maps paradigm seems easier to understand.  Maybe its
      because they draw a distinction between the topics and the
      subjects they stand in for, whereas <abbr
      title="Resource-Description Framework">RDF</abbr> tends to
      conflate the two.  Or maybe its the way a few important
      relationships (like occurence and instanceOf) are treated
      specially in topic maps, which makes maps a little less
      bewilderingly generic.
    </p>

    <p>
      Topic maps have a system of using 
      <abbr title="Universal Resource Identifier">URI</abbr>s 
      to stand in for particular abstract subjects.
      Separate topic maps using the same URI
      <code>http://www.topicmaps.org/xtm/language.xtm#en</code>
      as the <em>subject indicator</em> for the English language
      know they are referring to the same thing.
      When they are merged, the corresponding topics will be combined
      automatically.  One of the activities of various topic-map
      committees is creating <em>published</em> subject indicators for
      various generically useful types of topic, in order to promote
      interoperability between topic maps.  
    </p>
    <p>
      Other (meta)data systems use URIs to represent subjects: 
      <abbr
      title="Resource-Description Framework">RDF</abbr> does (using a
      weird convention where XML element-names turn in to URIs), 
      <abbr title="Really Simple Syndication">RSS</abbr> 0.9x/2.0 does
      (inasmuch as <code>category</code> names may be  interpreted
      relative to a <code>domain</code> specified by a URL).  It would
      be kind of cool if we could all agree to use the same 
      subject identifiers, so our various efforts interoperate as much
      as possible. 
    </p>
  </body>
</entry>
