Title: It's a bit like Markdown
Date: 20040424
Image: ../icon-64x64.png
Topics: pymarkdown tcl python markdown self

I have decided to change the way my home site works.  Up until now I
have been writing entries by creating a quasi-XML file containing the
HTML text;  I am changing  the format to be quasi-RFC-822: a text file
with a short header section at the top.  <s>The text is translated to
HTML via the usual hacked-together nest of regexps.</s>

The motivation for the change in format is the same as that described
on [John Gruber's Markdown page][1]: while I can happily type HTML
until the cows come home, for writing prose it is nice to be able
concentrate on the words without being distracted by the requirements
to get all the tags just right.  Unlike HTML source, it is possible to
read Markdown text fluently.

  [1]: http://daringfireball.net/projects/markdown/

I intend to implement something close to a proper subset of the
Markdown+Smartypants conventions, simply because I don't want to add
one more to the existing proliferation of *different* Wiki-like text
formats.  By *subset* I mean I do not intend immediately to implement
*all* of Markdown; it is actually a fairly complex syntax.  

**Update** (2004-05-08).  I have switched to doing my Markdown clone
in Python rather than Tcl.  This is partly because nowadays I am more
fluent in Python (this web site is the only Tcl project I still have).
In order to accomodate the interactions between the `\\`-escapes and
`\``-quoting I have replaced a lot of the regexp substitutions with a
single-pass finite-state machine, and I find this easier in Python
than Tcl.

It's still early days; in writing the previous paragraph I discovered
a bug to fix, and I haven't got around to processing apostrophes yet.

**Update** (2004-05-10).  I have apostrophe (`'`) automatically
translated to &#x2018; and &#x2019; (the Unicode characters for
inverted comma and apostrophe) according to context.  Similarly `"`
becomes &#x201C; and &#x201D;.  (Except they do not when inside
`\`...\`` or part of HTML tags.)
