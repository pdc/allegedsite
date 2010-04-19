Title: MU: A notation for mark-up
Date: 20040717
Image: ../icon-64x64.png
Keywords: xml mu

Discussions of Apple's proposed extensions to HTML made me wonder if
perhaps XML is suffering from being too complex and too strict, and
that a different generalization of HTML might make sense. Here's my
completely half-baked ideas, a language I shall call MU. 


Incomplete notes on MU
----------------------

In fact there are two (meta)languages, MU and MUD. 
MU is used to _mark up_ documents.  MUD is metadata about the marked-up text (specifically, MUD files can specify the encoding, character-entities beyond the usual `&lt;` etc., and a few other things).  I'll outline its format [later][next].

Encoding
--------

XML documents start with a declaration that specifies the character
encoding. In my view this is a problem, because it means that if you
want to transcode a document, you need a program that can parse the XML
declaration and alter the character data so it names the new encoding.
Things get more complicated with HTML because there are various ways
in which metadata about the encoding is embedded within the document.

Itwould be easier to require that XML data be accompanied by metadata
specifying its character encoding, making this an operating-system
problem, not part of the parser.

So far as the MU processor is concerned, a MU document is a squence of
characters, where characters are understood to be [Unicode or
ISO-10646][1] code points. Character data should be in Unicode
Normalization form C, but parsers are not required to enforce this.

When retrieving a document froma file system or over the net,
documents are represented as sequences of bytes in the usual way, and
the recipient must use (1) supplied metadata, if any, (2) sniffing for
UTF-8, UTF-16, or UTF-32 bytes &agrave; la XML, or (3) the conventions
of the OS, to determine the encoding. Supplied metadata means things
like a `charset` attribute in the MIME content-type, or a supplied MUD
resource.  MU documents _do not_ refer to their own encoding
internally.

Entity references
-----------------

MU uses `<` and `&` as its magic characters, not because I think they
are a good choice but because HTML does. If I were inventing the
format from scratch, I would be thinking in terms of `{` and `\\`
because they are less prevalent in real text.

Anhyow, MU and allows character-entity references `&amp;`, `&lt;`, `&gt;`,
`&quot;`, and numeric entities `&#x...;` and `&#...;`. All of these
represent single characters; it lacks the SGML or XML concept of 
entities containing chunks of text. 

Additional character entities may be
defined in a MUD file.

Tags and ranges
---------------

Tags look like this (please excuse my pseudo-DTD notation):

  * start-tag: `<` etype ( `#` match-id )? att\* `>`
  * end-tag: `<` `/` etype  ( `#` match-id )? `>`
  * empty-tag: `<` etype att\* `/` `>`
  * no-range-tag: `<` etype att\* `>`

The rules for tag-matching is that a start-tag must have a matching
end-tag later in the document. Tags define _ranges_, not elements, and
*ranges may overlap.*

There are two reasons to allow overlapping ranges. First, it allows
people to write things like
`<b><i>bi</b></i>`, which makes the format more forgiving of
amateurs. Second, it allows a given text to be marked up according to
different structures simultaneously. For example, consider
[the XML.com article on tagging Shakespeare][8]. In this there are three
simultaneous structures: the division of the text in to lines (based on
the original First Folio edition); the division of the play in to acts,
scenes, and speeches; and the division of the book in to pages. Add to
this the requirement that notes refer to words or phrases from the text
(perhaps overlapping) and the requirement for overlapping mark-up
becomes apparent. The XML example fudges this by marking up not lines
but the breaks between them.  

That said, for many applications a tree-based view of the document
structure is attractive; this is dealt with by the treeification
algorithm, described later.

The purpose of the optional `#`match-id part is to permit overlapping
ranges with the same etype, as in `<lem#a>foo <lem#b>bar</lem#a>
baz</lem#b>`. This is a direct steal from [LMNL][7]. The matching
end-tag is  the first unmatched end-tag with the same match-id as the
start-tag, or with no match-id if the start-tag has no match-id. The
match-ids are only used by the parser; they are not passed up to the
client application.
    
An empty-tag is equivalent to a start-tag immediately followed by a
matching
end-tag.
    
There may be a MUD file and it may define a set of _no-range_ etypes, in
which no-range tags may be used with the same meaning as empty-tags
(otherwise they would resemble start-tags). For example, if `img` is
a no-range element, `<img src=\"foo.png">` is equivalent to `<img src=\"foo.png"/>`.
Document authors should omit end-tags for no-range elements, and parsers
should ignore them.

Attributes values can omit quotes
---------------------------------

Attributes look like the following:

  * att: html-token-att | key-value-att
  * html-token-att: id
  * key-value-att: att-id `=` ( quoted | apostrophed | naked )
  * quoted: `"` not-quote\* `"`
  * apostrophed: `'` not-apostrophe\* `'`
  * naked: not-space-or-gt\*
  
Naked attribute values allows `<img src=foo.gif>` as a shorthand for
`<img &#x0073;rc="foo.gif"/>`. (HTML in theory constrains naked
values to name tokens, but people often include slashes in them.)  For
identifiers and numbers, the quotes around attribute values serve no
real purpose.

The production html-token-att means those so-called boolean HTML
attributes like `<option selected>` that are taken to mean `<option
selected="selected">`. I don't like them; they're an SGML feature that
just makes things more complicated, but HTML uses them so in they go.

And what is the point of all this?
----------------------------------

The idea is that many HTML documents are already MU documents without
extra effort -- even a fair chunk of the invalid HTML documents that
exist.  At the same time MU is not an unreasonable format, from the
point of view of parsers and processors.  The plan is that a lot of
the second-guessing that pragmatic HTML browsers resort to can be
rationalized and made legitimate, thus defusing one of the big
theoretical vs. practical arguments that seems to rage forever these
days.

  
  [1]: http://www.unicode.org/faq/unicode_iso.html "Unicode and ISO 10646 (unicode.org)"
  [2]: http://www.ietf.org/rfc/rfc2234.txt "RFC 2234 ABNF"
  [4]: http://xml.coverpages.org/sgml.html "Standard Generalized Markup Language (Cover Pages)"
  [5]: http://yaml.org "Yaml Ain't Mark-up Language"
  [6]: http://www.ietf.org/rfc/rfc2387.txt "RFC 2387 The MIME Multipart/Related Content-type"
  [7]: http://www.lmnl.net/ "The Layered Mark-up and aNnotation Language"
  [8]: http://www.xml.com/pub/a/2004/05/26/totag.html "To Tag or Not to Tag: The New Variorum Shakespeare and XML (xml.com)"
  [next]: 19.html "Clear as MUD"


