Title: Refactor, Redesign, Restyle
Icon: ../icon-64x64.png
Topics: css html genshi python markdown self restyle
Date: 20070304

Yes, I have redesigned my archive pages—that is, the ones where all the entries apart
from the most recent live, and the index pages for navigating between them.  To see the new look you can visit the [archive page for this entry](03/04.html).

Not too long ago I [restyled this site][] to use a font called Gentium and a
black-on-vellum colour scheme; the navigation remained the same, which is to say,
remained broken. Why is that, and what’s so great about my new system?

  [restyled this site]: ../2005/12/15.html "Experiments with Gentium"


The problem with TclHTML
------------------------

This site was originally maintained with a package I created called [TclHTML][], where
the programming language Tcl is extended with commands for generating HTML. It seemed
like a good idea at the time.


Getting back in to the Tcl code used to generate the year and month
index pages was just too depressing to contemplate, so I concentrated on the front page.  Over the years I’ve been hacking on this site I have accumulated a whole slew of code designed to keep various bits in order.  The problem was not just that the Tcl code is harder to work with when you have not done Tcl programming in five years or so; the Makefiles used to run the whole process and pull in data from various files and so on has just become too unwieldy for words. 

  [TclHTML]: http://tclhtml.sourceforge.net/


The problem with Make 
---------------------

The `make` program works best with sparse dependencies—most targets depend on a small
number of other files, with one final linking step at the end. When I added the
[subjects][] page, this introduced a single file that depends on all the entries (since
any entry may introduce topics that must be listed in `subjects.html`), and on which
dozens of documents depend (the pages for each subject); this and a few other
overlapping dependencies means that changing one page means a great number of pages are
read and reread because they affect that page.

The solution to this is to have a program with a more specialized algorithm than that of
`make`, so that all the pages can be read and their metadata extracted once; then all
the pages that need to be regenerated can be regenerated one after the other using this
metadata rather than reconstructing it from scratch each time.

the upshot of this is that I am making a new system, which does not use the old Tcl+Make
based code at all—only the content (the entries)

  [subjects]: ../2003/subjects.html 


The Problem with Gentium
------------------------

Mozilla Firefox is my main web browser on my Mac, and something about the way Firefox
does text and the Gentium font means that my text is [looks awful in Firefox][prev]. It
works fine in Safari and looks great—and it looks no worse on Windows than any other
font, and better than most. It’s just Firefox on the Mac.

  [prev]: ../2005/12/15.html "Experiments with Gentium"


New possibilities with <s>Kid</s> Genshi
----------------------------------------

I have already been experimenting with generating static HTML [using Kid][], a neat and
tidy Python-based templating system for XML. Since then, Ryan Tomayko (Kid’s perpetrator)
has [anointed Genshi as Kid’s successor][1]. [Genshi][], like Kid, has templates that are
well-formed XML, decorated with special attributes to control how data is incorporated in
to the template. Genshi has a few extra features, such as being able to generate text as
well as XML, and internally uses streams of mark-up events that use Python’s generator
feature to maximum advantage.

Compared with TclHTML, Genshi neatly separates the concerns of how the data is
manipulated from the layout of the page: my development process consisted of writing
code to extract the information from the various files, and once that was working well
enough, hacking the template to make a reasonable page layout, and once that was working
well enough, hacking the CSS to make it pretty, and then going back to the Python to add to the repertoire of metadata being extracted.  The advantage over the TclHTML commingled approach is that while working on the template you can think in HTML without needing to hold the programming details in your head at the same time. Well, more or less.

Another advantage is that Genshi will be able to generate non-HTML files (like a news feed in Atom) using the same system as the HTML, only changing the templates.


Object-Oriented Design
----------------------

The inputs for my web site—at least the part I am working on here—are **entries**, stored on disc as one file per entry.  *Older* entries are stored in an XML format:

	<entry xmlns="http://www.alleged.org.uk/2003/um"
		xmlns:dc="http://purl.org/dc/elements/1.1" 
		date="20020219" icon="tarot/wands-4-64x64.png">
	  <h>Alleged Tarot (Week 8): Four &times; Four</h>
	  <body>
	    <p>
	      This week&rsquo;s installment in my 
	      <a href="tarot/">on-going project to create an 
	      tarot deck in SVG</a> is the fours of each suit:
	      <a href="tarot/wands-4-svg.html">Wands</a>,
	      <a href="tarot/cups-4-svg.html">Cups</a>,
	      <a href="tarot/swords-4-svg.html">Swords</a>, and
	      <a href="tarot/coins-4-svg.html">Coins</a>.
	      Hope you all enjoy them.
	    </p>
	  </body>
	  <dc:subject>tarot</dc:subject>
	</entry>

Note that the `body` element is basically the same as XHTML, except all the elements are
in the wrong namespace. The `dc:subject` element(s) record topic keywords. My system
used the short names, like `tarot`, to map on to proper labels, like ‘Alleged Tarot
2002’. Since then the fashion has emerged of using tags ‘in the raw’, so I might leave
them as keywords in future.


In 2004 [I switched to using Markdown conventions][3]:


	Title: It's a bit like Markdown
	Date: 20040424
	Image: ../icon-64x64.png
	Topics: pymarkdown tcl python markdown self 
	≈
	I have decided to change the way my home site works.  Up until now I
	have been writing entries by creating a quasi-XML file containing the
	HTML text;  I am changing  the format to be quasi-RFC-822: a text file
	with a short header section at the top.  <s>The text is translated to
	HTML via the usual hacked-together nest of regexps.</s> 
	≈
	The motivation for the change in format is the same as that described
	on [John Gruber's Markdown page][1]: while I can happily type HTML
	until the cows come home, for writing prose it is nice to be able
	concentrate on the words without being distracted by the requirements
	to get all the tags just right.  Unlike HTML source, it is possible to
	read Markdown text fluently. 
	≈
	  [1]: http://daringfireball.net/projects/markdown/
	≈
	... etc. ...

Once the body has been converted to HTML, the information provided to the system is the
same: HTML, date, image, tags. So I have two classes, `Entry` and `XmlEntry` with a
common base class `EntryBase`. The function that loads entries peeks at the start of the
file to see whether it starts with `<`, and then passes the text to the appropriate
class constructor.

My first thought was to give the `EntityBase` subclasses a method `write_html` to
generate their HTML versions. Then I remembered that before 1 May 2003, entries did not
have their own page, but instead were grouped by month. To allow for this variation, the
`Corpus` object that keeps track of the entries also keeps a list of `Output` objects.
When loading in an entry, the corpus decides which outputs it participates in, and
creates them if they do not already exist.  

The `Output` objects have a list of entries, a title, and a template name (so the legacy
monthly roll-ups can use a different Genshi template from the one-entry-per-page
entries). They know if they are stale (they check by comparing modified-times), so they
need not be regenerated if their inputs have not changed.

This system also gives me the [yearly](../2004/) and [monthly](../2004/07/) index pages almost for free: all I needed to do was add code to register a new output based on the month or year of each entry, and write two extra Genshi templates (and these could be largely based on the existing ones).

[More on Ood](http://www.bbc.co.uk/doctorwho/gallery/s2_08-09gallery/index.shtml).


Redesigning and restyling
-------------------------

So much for refactoring the code that generates the site. I have also tweaked the
layout. Now the legacy pages have their own template they can have a distinctive design
from the single-entry pages: the date is abbreviated and made big and the sizes used in
the headings are different to reflect their different granularity. The index pages now
simply list titles and tags: the crappy almost-calendar used for the yearly index pages
(which did not include new-style entries at all) has been junked, and not a moment too
soon.

I’ve also made a better fist of coming up with a workable grid system for the entry
pages. The entry details are no longer embedded in the side of the entry but have their
own column in the grid. Some nuance of the float rules caused the article photo to get
lost in the old style. Now it stands alone and looks decorative. I am also getting a
little bolder about adding larger chunks of white space to the design. Professional
designers may mock, but by my standards the layout looks pretty good. `:-)`

Mac users will see the body text in [Hoefler Text][], a comprehensive family of
beautiful text typefaces with all the trimmings provided gratis with Mac OS X. If you
have a Mac, open TextEdit, write some text, pop open the Font panel, choose Hoefler
Text, and use the cogwheel button menu to pop open the Typography panel to boggle at the
OpenType features supported by this under-appreciated font family. For headlines I’ve
once again used Futura capitals, slightly letter-spaced for that old-fashioned look.

  [Hoefler Text]: http://typography.com/catalog/hoeflertext/

Windows users may see High Tower Text; I will need to evaluate the look on my PC at work
before I finalize the Windows version of the style sheets.


Next
----


This process is not yet finished; what you see now is one weekend’s effort. I’ve claimed
I can apply my Genshi-based method to generating the feed as well as the HTML, so I
should do that next. Then I need to apply the new system and look to the home page; this
will be trickier because there is more information on the home page, gathered from other
web sites.






  [using Kid]: ../2006/08/20.html "Maintain Static HTML with Kid Templating"
  [1]: http://tomayko.com/articles/2006/11/11/xml-templating-in-python-evolves
  [3]: ../2004/04/24.html "It’s a bit like Markdown"
  [Genshi]: http://genshi.edgewall.org/
  [Python Markdown]: http://freewisdom.org/projects/python-markdown/



