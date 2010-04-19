Title: MU compared with ...
Image: ../icon-64x64.png
Date: 20040805
Topics: mu xml html lmnl

I have been outlining a hypothetical alternative to XML that I am
calling [MU][mu].  In this note I compare MU to some other mark-up notations.

MU compared with HTML
------------------------------

MU is intended to generalize what is a reasonable HTML-style document.
The intention is that the addition of a standard [MUD][mud] file and style sheets, 
a generic MU processor would be able to grok a large subset of
extant HTML documents. Obviously there will still be documents that are
not well-formed MU any more than they are well-formed HTML, and
processors may still need to do some second-guessing.

There is no `!DOCTYPE` declaration, and no SGML-style DTD. The equivalent is the `mud`
attribute of the media type.  As a special case, we might define a
special `text/html+mu` media type defined so that

<pre>
text/html+mu; charset=UTF-16
</pre>

is the same as

<pre>
text/mu; charset=UTF-16; mud="http://www.w3.org/2005/html.mud"
</pre>

where the specified MUD file contains `character` and `no-range tags`
sections that define the HTML syntax, `view` sections naming appropriate
CSS style sheets, and a `features` list including all the HTML modules.

Unlike HTML, there is no attempt to define the default charset as
anything other than US-ASCII, thus avoiding conflict with the MIME RFCs.
(On the other hand, if the document has no reported charset then
processors' behaviour is undefined, and may include attempts to glean
the charset from analysis of the byte patterns.)

MU documents can contain namespace-prefixed tags (declared in the MUD),
but the prefix is only required when there is a name collision; tags
without a prefix are taken as being in whichever namespace allows them
to be recognized by one of the activated features. This allows for
extensions (like [Apple's `canvas` tag][canvas], for example) without
having every other tag adorned with prefixes.

MU would prefer that document metadata -- such as title, links, and
suchlike -- live externally to the document data. In an HTTP or MIME
context, the natural place for title and suchlike is the headers; on
disc there would be a META resource containing the same information. In
particular, a document should not be an authority for its own encoding;
that leads to confusion. For HTML compatibility, there would have to be
features that can be mentioned in the MUD file to activate embedded
metadata for compatibility.

Many HTML processors use '`DOCTYPE` switching' to select different
quirks to match the bugs in other programs. With MU, you are supposed to
be able to use the `features` section of the MUD file to assert the need
for different processing models or whatever.

MU compared with XML
-----

MU does not have a `!DOCTYPE` declaration, `PUBLIC` identifier for its
DTD, or a DTD. The functions of the XML DTD are

  * defining default attributes (MU does not have default attribute
  values);
  * some checks for document validity (MU would use external validators,
  in the style of Relax NG and XSD);
  * defining entities (MU restricts entities to chacter entities and can
  define them in the MUD file).

In addition, SGML DTDs can alter the syntax by defining some
element-types as empty; MU does that through the MUD file.

MU has namespaces, but they are defined in the MUD file rather than
in-line (saving on typing, if nothing else). It also treats unqualified
tag-names differently, allowing them to be in whichever vocabulary makes
most sense. Some of the functions XML uses namespaces for are achieved
through feature declarations in the MUD. 

MU does not have XML's `encoding` pseudo-attribute; instead MU requires
that external metadata be used to establish the conversion from
bytes to characters. My [META][meta] proposal is intended to shore up those
operating systems that have problems in this regard.

MU does not have `NOTATION` definitions. 

XML models the document as an ordered tree of nodes, the leaf nodes
being text nodes or empty elements. MU considers a document to be a
character sequence, with some ranges (possibly overlapping) tagged with
optional attributes. Where XML is a semi-plausible format for exchanging
non-document datasets (such as serialized database tables, RSS, and
XML-RPC), in the world of MU, one might prefer [YAML][yaml] for those tasks.



Compared with LMNL
-----

[LMNL][lmnl] is another mark-up language firmly rooted in the concept of
marking up text. Like MU, tags mark ranges that may overlap. LMNL has a
properly worked out processing model that MU would steal wholesale.
LMNL
uses a different microsyntax, with start tags written
`[par}` and end tags `{par]`.  This addresses neatly one of the
annoyances of SGML-derived languages, the one-character difference between `<foo>` and
`</foo>`. It also gives them an unambguous empty-range notation:
`[img]`.

LMNL has a much more powerful
attribute syntax -- each annotation's value is potentially a LMNL text layer,
whereas MU, like XML and HTML, limits attribute values to unstructured character
data. I believe that all MU documents can be trivially converted to
LMNL, and LMNL documents with simple enough attributes can be
transformed to MU.

Updated
-----

2004-08-06: Added sections on XML and LMNL

  [canvas]: http://weblogs.mozillazine.org/hyatt/archives/2004_07.html#005913 "Surfin' Safari (David Hyatt's weblog)"
  [lmnl]: http://www.lmnl.net/ "The Layered Mark-up and aNnotation Language"
  [mu]: 07/17.html "MU: A notation for mark-up"
  [mud]: 07/19.html "MU part 2: Clear as MUD"
  [meta]: 08/03.html "META files for HTML + XML encoding happiness"
  [yaml]: http://yaml.org "Yaml Ain't Mark-up Language"
