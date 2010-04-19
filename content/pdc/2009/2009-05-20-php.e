Title: PHP is Wrong
Topics: php rant
Date: 2009-05-20
Icon: ../icon-64x64.png

PHP is at best a mediocre programming language; it’s only reason for existing is that it is designed for writing HTML pages for web sites. So why is it that it completely lacks any understanding of HTML?

HTML versus Plain Text versus User Input
========================================

PHP assembles the content of the page it is producing through concatenating strings, as in

    function make_link($label, $url) {
		return '<a href="' . $url . '">' . $label . '</a>';
	}

Where the dot operator (`.`) joins two strings together. Because  it does not know it is making HTML, the PHP system cannot prevent you from introducing bugs. In the case of the above function,  if there are special characters in the label then it will make bad HTML. We should have written it as  the following:

    function make_link($label, $url) {
		return '<a href="' . $url . '">' 
			. htmlentities($label, ENT_NOQUOTES, 'UTF-8') . '</a>';
	}

No, wait, I forgot that the URL might contain ampersands, so really it should have been something like this:

    function make_link($label, $url) {
		return '<a href="' . htmlentities($url, ENT_COMPAT, 'UTF-8') . '">' 
			. htmlentities($label, ENT_NOQUOTES, 'UTF-8') . '</a>';
	}

But what if we want the label to be allowed to include HTML constructs after all? In Drupal the solution is that there is an extra argument that says whether the label is plain text or HTML. 


    function make_link($label, $url, $is_label_html) {
		if (!$is_label_html) {
			$label = htmlentities($label, ENT_NOQUOTES, 'UTF-8');
		}
		return '<a href="' . htmlentities($url, ENT_COMPAT, 'UTF-8') . '">' 
			. $label . '</a>';
	}

It is up to the caller to keep track of which text has been escaped, contains HTML and must not be escaped, or is plain text that needs to be escaped if added to the HTML. This is tedious and error-prone.

Structures versus Strings
=========================

Drupal has a lot of functions that pass around partially built pages and modify them. For example, today I was debugging a problem with a function `ds_breadcrumb`, which takes a list of links and returns the formatted HTML for the breadcrumb trail of the site. The first problem is, what should the type of the list of links be?  In other words, is a link a structure like this:

	array(
		'title' => 'Jack & Jill', 
		'url' => 'http://example.org/?jack=1&jill=1',
		'is_title_html' => FALSE,
	)

or a string like this:

	<a href="http://example.org/?jack=1&amp;jill=1">Jack &amp; Jill</a>

In Drupal’s case the links are strings, not structures. My code has to scan the list of links for links that refer to certain pages, because we want to represent them differently. After an unreliable version  that sniffed each link with a regex, I resorted to writing a function that scans the HTML of the links and converts them in to structures. Matching the URLs we were interested in is then a straightforward matter.

This came unstuck because of the ambiguity as to when special characters
are or are not escaped. We ended up with apostrophes in titles turning
in to `&amp;#039;` (just to be explicit, in case the text of this
article gets (un)escaped by mistake: ampersand, a, m, p, semicolon,
number sign, zero, three, nine, semicolon). This was after I used
`html_entity_decode` to convert the HTML content of the tag in to plain
text. I think that this is because PHP’s conversion functions have that
flag that controls whether they munge the apostrophe and double-quote
characters, and somewhere along the line the wrong flag value was being
passed.

A Hypothetical HTML-Savvy Language
==================================

Given that PHP’s whole reason for being is to write HTML, why not incorporate HTML (or XML) in to the language itself? There’s something along these lines in the [E4X][] dialect of JavaScript. For example, suppose you could do something like this:

	$link = <a href={$url}>{$label}</a>;

to give the variable `$link` an HTML fragment as its value. The output of the PHP page would not be a string but instead an HTML object. Neither the label nor the URL need to be escaped before interpolating them in to the HTML fragment; special characters will be escaped as necessary when the fragment is converted to a byte stream in the page. Note that the value  of `$label` can a character string or another HTML fragment, thus entirely eliminating the need for special flags for escaping or not escaping the text.

The output of the  processor would therefore automatically be well-formed, since bad HTML will be a syntax error in the code.

Many of the situations where Drupal sometimes uses structures and sometimes uses strings would be greatly simplified since this new structure would serve both purposes. 

I have toyed with the idea that you could use this HTML structure to replace other structured types (like lists and dictionaries), since it has aspects of both. The results might be a bit clunky when it comes to doing the occasional pure calculation.

Approaches in General-Purpose Languages
=======================================

An alternative to a programming language with HTML (or XML) built in to the syntax is to use a general-purpose language with some kind of templates. The style here is generally whole-page templates, where data is processed as plain old objects and values, and converted to HTML at the end using a template. This contrasts with the bottom-up Drupal approach, where fragments of HTML are assembled in to larger and larger chunks of HTML in order to build the page.

Python has several template kits to choose from, but two which are interesting in this context are [Kid][] and [Genshi][], in which the template syntax is itself an application of XML. A few extra attributes and element types are mixed in with the XHTML to interpolate values and mark conditional or repeatable code, like this:

	<div py:if="socks">
		<h2>List of socks</h2>
		<ul>
			<li py:for="sock in socks">
				<a href="socks/${ sock.tag }">${ sock.label }</a>
			</li>
		</ul>
	</div>

Once again the result is guaranteed to be well-formed, since XML-savvy data structures are used as the intermediate format and serialized as HTML or XHTML at the last possible moment. Strings that are interpolated in to the structure are automatically escaped on output. To take a chunk of already-formatted HTML you must parse it in to an XML structure (with Kid) or convert it to a special subtype of string that signals that the text is known to be valid HTML (with Genshi). The upshot of this is that the default is safe, since the price for forgetting is that ugly HTML code becomes visible on the site, unlike PHP, where the price for forgetting is yet another [cross-site scripting][XSS] vulnerability.

[Django][] takes the line that [templates][1] should not themselves have to be valid XML, but that interpolated strings are escaped by default. Again, you have to explicitly mark text containing mark-up as safe before it can appear on the page.  

Conclusion
==========

For a system designed to generate HTML, PHP is surprisingly ill-suited to the task. Let’s all use Django instead.





  [E4X]: https://developer.mozilla.org/En/E4X/Processing_XML_with_E4X
  [Kid]: http://www.kid-templating.org/
  [Genshi]: http://genshi.edgewall.org/
  [XSS]: http://en.wikipedia.org/wiki/Cross-site_scripting
  [Django]: http://www.djangoproject.com/
  [1]: http://docs.djangoproject.com/en/1.0/topics/templates/