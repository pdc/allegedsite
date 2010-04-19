Title: MU part 3: More MUD
Date: 20040720
Image: ../icon-64x64.png
Topics: mu mud xml yaml

Apologies to people reading this via LiveJournal's syndicated feed; a
combination of my software converting every header in to an RSS item and
LiveJournal duplicating each item every time I edited the title has
created a flurry of links to essays that I expect no-one but me has any
interest in anyway.

Just to rub it in, here is some more of my imaginary generalized mark-up
language [MU][first] and its metadata format [MUD][prev]..

No-range tags
--------------

The property `no-range tags` is a list of etypes, as a YAML list:

<pre>
no-range tags:
  - img
  - embed
  - applet
  - br
  - hr
  - base
  - link
</pre>

This is a kludge to allow for HTML's empty elements: a list of etypes for
which the no-range-tag syntax is permitted. For example, with the above
definition, `<hr>` is treated the same as `<hr/>`.

It is in the MUD file -- rather than being in a separate schema or
pattern file -- because it is needed to parse the MU.  This sadly
means documents  using this feature are not stand-alone.

Character entities
-----

This section is used to define additional character entities.

<pre>
characters:
    nbsp: 00A0
    iexcl: 00A1
    cent: 00A2
    ...
</pre>

Characters are defined here using Unicode code points in hexadecimal,
so that in this example, `&iexcl;` is equivalent to `&#x00A1;`.
Note that (unlike SGML and XML) we do not allow entities to expand to
more than one character.  

Style sheets
-----

Collections of documents that describe how to display the text. I am
supposing in these examples that in the parallel universe where MU is
defined, CSS has been extended to work with documents containing
overlapping mark-up in the style of LMNL and MU.

<pre>
views:
    default:
        title: Standard appearance
	media: screen
	features:
	  - tag:alleged.org.uk,2004:mu:css
        style sheets:
          - foo.css
	  - bar.css
    mobile:
        title: Compact layout
	media: screen
	features:
	  - tag:alleged.org.uk,2004:mu:css
        style sheets:
	  - foo.css
	  - bar-compact.css
</pre>

The view named `default` is used initially; all the other view names are
arbitrary, and are there for the sake of style-sheet switchers. The
`features` tag says which style-sheet processors will be required to
make sense of this view; if that feature is missing, that view is
skipped. This gives a way to extend the style-sheet system, without
using special mdia-types for the CSS files.

It might be reasonable to make the CSS feature mandatory, so that in the
common case the `features` tag is not needed.

This is just a sketch -- sorting out the details is left as an excerise
for the reader.

Extensions
-----

MUD files can also contain arbitrary extra data for plug-ins to play
with. This is a special section called `extensions`:

<pre>
extensions:
    speak-u-like:
        default-voice: tiny child
	default-speed: 110%
    relax-ng:
        schemas:
	  - this.rng
	  - that.rnc
        mode: pedantic
</pre>

The keys are arbitrary. Generally there should be a corresponding
`features` entry that activates the plug-in that then searches the
`extensions` section for its configuration, if any. 

MUD versus MUM versus META
-----

Some of the fields I outlined for MUD files -- such as `type` and
`charset` -- I now think deserve a file of their own, which I have
dubbed META. The MUD file therefore is a document-format definition,
shared by many documents, compared with the META file, which gives
information specific to a single document.

The [description of META files][meta] now moved out to its own page.

MUM is a bundling format I will describe some time in the future.


Changes
-----

Updated 2004-08-05 to add `characters`, `extensions` and `views` sections.


  [first]: 07/17.html "Mark-Up"
  [prev]: 07/19.html "MU Part 2: Clear as MUD"
  [meta]: 08/03.html "META files for HTML + XML encoding happiness"
