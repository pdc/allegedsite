<!-- -*-HTML-*- -->
<entry date="20020912" icon="../wp/icon-64x64.png">
  <h>Version numbers in namespaces considered harmful</h>
  <body>
    <p>
      The various flavours of RSS offer a variety of namespace
      requirements:
    </p>

    <table>
      <thead>
        <tr valign="bottom">
	  <th align="left">URL</th>
	  <th align="left">RSS version</th>
	</tr>
      </thead>
      <tbody>
        <tr>
	  <td><code>http://my.netscape.com/rdf/simple/0.9/</code></td>
	  <td>0.9</td>
	</tr>
        <tr>
	  <td>(default)</td>
	  <td>0.91, 0.92, 0.94</td>
	</tr>
	<tr>
	  <td>
	    <code>http://purl.org/rss/1.0/<br />
	    http://purl.org/rss/1.0/modules/rss091#</code>
	  </td>
	  <td>1.0</td>
	</tr>
	<tr>
	  <td><code>http://backend.userland.com/rss2</code></td>
	  <td>2.0</td>
	</tr>
      </tbody>
    </table>

    <p>
      In my opinion, it is a grave mistake to include a version number
      in a namespace URI.  The function of a namespace is to prevent
      accidental collisions between names defined by different people
      (or organizations) when two XML vocabularies are combined in one
      document.  The version number of the format can be specified 
      separately (as indeed all the RSS versions do, as an attribute
      of their root element).  If the 0.9 spec had only used
      <code>http://netscape.com/1999/rss</code> as its namespace
      (following the lead of
      <code>http://www.w3.org/1999/xhtml</code>) then all
      the versions could have used the same namespace.
    </p>

    <p>
      Why do I&nbsp;care, you ask?  Because if you use actual XML
      tools like XSLT to manipulate RSS feeds, then the fact that
      there are three or four namespaces in use for essentially the
      same elements makes the whole thing more complicated.  Where
      I&nbsp;might have had
    </p>

    <pre>&lt;xsl:template match="/rss:rss/rss:channel"&gt;...</pre>

    <p>
      I better be prepared for more complicated expressions like
    </p>

    <pre>&lt;xsl:template match="/*/*[lname()=channel]"&gt;...</pre>

    <p>
      (to allow for any root element, and  to ignore the namespace of
      the <code>channel</code> element).  This clutters the XSLT file
      and makes it harder to maintain&mdash;and probably also less
      efficient.  Sigh.
    </p>

    <p>
      This is not unique to RSS, by the way&mdash;I&nbsp;had all sorts
      of hassle with early ve4sions of SVG tools which were caught out
      by the ever-changing SVG namespace URL.  They finally settled on
      the quite-sane <code>http://www.w3.org/2000/svg</code>.
    </p>
  </body>
  <dc:subject>rss</dc:subject>
  <dc:subject>xml</dc:subject>
  <dc:subject>xmlns</dc:subject>
</entry>
