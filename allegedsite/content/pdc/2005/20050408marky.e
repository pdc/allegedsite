Title: Markdown + Make versus Microsoft Word
Topics: make markdown msword html
Date: 20050408
Image: ../icon-64x64.png

I have written [a short note about using `make` and `sed` with Markdown
to maintain a collection of HTML documents][0]. Programmers are forever writing
documentation (proposals, specifications, technical notes, and so on),
and the latest stage in my quest to make writing prose as frictionless
as possible
I have started using [Markdown][1] to do this.
Before that I wrote in HTML with some XML mixed in to better handle
sectioning; before that I used Microsoft Word.

The [aformentioned note][0] gives the details of how this works. The
rest of *this* note discusses why I'm not using Microsoft Word.

Writing with Word is not frictionless
-----

Most of my managers would expect me to use Microsoft Word to write
proposals and specifications and the like. This makes some sense
because, not being developers, the spend most of their time plugging
away in Microsoft Office, so Word is always to hand. But I instead *program* for a
living: I typically have three text editors open at once (Microsoft
Visual Studio .NET 2003, the [Pythonwin IDE][2], and [jEdit][3]), so dashing
out a note in a text editor is the natural thing to do. When
I do use Word I waste time
struggling against its officious auto-lousification features.
[Jeremy][4]'s description of it as being like a bolshy secretary is very
apt; it is so annoying that there is a whole industry growing around the
[_Word Annoyances_][5] books.

Besides, we are all web developers now, and should always be looking for
a chance to sharpen our HTML skills and practice organizing documents for the Web.

Word documents are not good to read
-----

Word is worse for reading on-line than HTML. When colleagues and
customers send us documents in Word format, I cringe. I have to wait
while the word processor drags its bloated code off the hard drive and
in to memory, and eventually opens a window in which the document in
question is displayed at some random zoom level and view mode chosen by
the last person to edit it.

Word documents do not sit comfortably on the company intranet. Not that
anyone seems to have the wit to appreciate that being able to refer to
documents by URL would save a lot of time that instead we waste digging
though old mail messages or obscure file shares looking for 'the DTI
spec' (which is not named that, of course).

With HTML pages on an intranet server, it is easy to have
cross-references between documents, to write index pages, even share
them with clients via an extranet server. You can have links from bug
reports to the relevant section of the specification or what-have-you.


Word documents are ugly
-----

<a href="http://www.flickr.com/photos/pdc/1911118/" title="Wishing well (on Flickr)"><img src="http://photos2.flickr.com/1911118\_2e55e0f904\_m.jpg" width="240" height="159" alt="" align="right" /></a>
But surely we can exploit the extra formatting features Word offers to
make documents of rare clarity and great beauty? Yes, and, back when I
wrote position papers in Word, I carefully chose fonts and adjusted the
layout of headings to make the documents look nice and read well. I even
persuaded the powers at be to let me buy a Bitstream 500-font CD so we
could use [Plantin][6] rather than Times Roman. I made these changes
using Styles so that formatting was consistent throughout the document.
I discovered how to make a Code style that used [Univers 55][7] to represent
computer text and suppressed the spell-checker. I even worked out how to
attach this style to a keyboard shortcut so I could write technical
documents with lots of computer text in. I spent ages arguing with the
automatic header-numbering dialogues until they numbered the headings
properly, and I tweaked the table of contents to make it more usable. I
organized my documents carefully so as to avoid convoluted and heavily
nested sub-sub-subheadings. I felt this was the least I needed to do to
produce documents of an acceptable standard that could be shown to
clients.

In this regard, I am unique. Normal people use the wizz-bang features of
Word to create ugly, unstructured documents that use fonts too small to
read on the screen, and lines too long to read comfortably on paper. The
least bad examples are when they leave the default, ugly, heading
formats in place. When they attempt impose a style of their own it is
far worse.

Concentrate on the words, not Word
-----

Another things that irritates me (and is not entirely relevant to this
discussion) is that so little thought goes in to writing these words.
Another way in which I am freakishly divergent from the norm is that the
second thing I put in every paper is a line with the revision
number, the date, and my name. The idea is that (a) it should be easy to
discover whether one is reading the latest version, and (b) if there are
questions, it is possible to ask someone. An undated document headed 'Bugs in
Frobomatic' followed by a list of complaints will soon be useless
because it does not say which version of the software, or whom to ask
for details about the bugs.

<a href="http://www.flickr.com/photos/pdc/630282/" title="Bodford (on Flickr)"><img src="http://photos1.flickr.com/630282\_0be34102c7\_m.jpg" width="240" height="180" alt="" align="left" /></a>
I used to make a point of numbering documents (something might be Tech
Note #3) and number headings in documents and in some cases even
paragraphs. This way you could refer to TN3, &sect;4.2 concisely rather
than 'The one about the database thingummy that Jared mailed you in June
I think, about halfway through, headed Issues with User Authentication
(or do I mean Authorization?), about four paragraphs in'. I even wrote
scripts to automagically number headings in HTML documents, *and*
provide anchors so I could link directly to a certain section of a
certain document. I have since given up: nobody cares. 

Conclusion
-----

Too many people spend hundreds of pounds on word-processing software so
that they may spend hundreds of hours writing documents, but then
neglect to spend a minute or two ensuring these documents will be
citeable, findable and readable. 

For writing technical prose, the formatting features of word processors
are a distraction at best. Programmers especially would be better off
spending their time getting really good with a decent text editor.


  [0]: ../../2005/marky/
  [1]: http://daringfireball.net/projects/markdown/
  [2]: https://sourceforge.net/projects/pywin32/
  [3]: http://www.jedit.org/
  [4]: ../../jrd/
  [5]: http://www.wopr.com/books/annoyword97.htm
  [6]: http://www.linotype.com/13564/plantinroman-font.html#more
  [7]: http://www.linotype.com/12641/univers55roman-font.html#more
