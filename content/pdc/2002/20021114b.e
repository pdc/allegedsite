<!-- -*-HTML-*- -->
<entry date="20021114" icon="../wp/icon-64x64.png">
	<h>More on Opera&rsquo;s boundaries</h>
	<body>
		<p>
			It occurs to me I&nbsp;may be being harsh on Opera;
			I&nbsp;notice that elsewhere they show a preference for
			splitting MIME parameters over multiple physical lines.  For
			example, they use
		</p>
		<pre>Content-disposition: form-data;
			name="fred"</pre>

		<p>as opposed to</p>

		<pre>Content-disposition: form-data; name="fred"</pre>

		<p>
			It is just about possible that this confuses <code>thttpd</code>
			so that it clips everything after the first CRLF when passing
			the headers to my script via CGI...?
		</p>
	</body>
	<dc:subject>cgi</dc:subject>
	<dc:subject>opera</dc:subject>
	<dc:subject>picky</dc:subject>
</entry>
