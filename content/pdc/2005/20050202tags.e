Title: Flickr and del.icio.us tags illustrate why worse is better
Topics: tags flickr delicious seahorse metadata topicmap
Icon: ../wp/icon-64x64.png
Date: 20050202

Recently the term 'folksonomy' has been coined to refer to the use of
unstructured keywords to classify and group resources collaboratively
('resources' as in photos on [Flickr][1] and links to web sites on
[del.icio.us][2]). Supposedly the experts on metadata are chagrined to
discover that structured keywords, hierarchical taxonomies, and faceted
metadata have been outdone by such a simple system. But this approach
isn't actually all that new.

The problems with metadata
-----

But first a little background, based on my own bitter experience!
In 1997 I comprised the entire technical staff on a multinational
European project to create an on-line repository of information on HIV
and Aids called [SEAHORSE][3], after a year-long feasibility study in
1995 where I was the one arguing that we exploit this new-fangled WWW
concept to distribute information, rather than creating our own
ISDN-based network!

Mostly SEAHORSE was about linking to the
growing corpus of material already existing, since there was no budget
for creating original material. It seemed to me that a good approach
would be to tag the web sites and documents we linked to with one or
more categories, and have the user choose a cluster categories to search
for documents. For example, suppose a certain drug r&eacute;gime gives
you brittle toe nails, and eating more grapes will ameliorate this
symptom: a page describing this would be annotated with the names of the
drug, 'toe nails', and 'grapes'. The challenges with this are fairly
obvious:

  * authority (people can disagree on how pertinent a page is);
  * homonyms (same word, but different meanings);
  * synonyms (different words with the same meaning); 
  * hypernyms (this word is a more general concept than that one);
  * localization (the web site had to be multilingual); and
  * navigation (how to choose your cluster of categories).
  
The issue of __authority__ was especially interesting because during the
1980s and early 1990s, the subject of HIV and Aids was one where people
with Aids often knew more about it than many medical professionals, and
there were many people who were publishing information that did not go
through an academic peer-review. Even within our consortium we had the
Immune Development Trust emphasizing complementary medicine (and now
renamed the [Complementary Health Trust][4]), and London Lighthouse (now
assimilated into the [Terrence Higgins Trust][5]) working with
conventional medicine. My solution was to partition the annotations in
to annotation-sets (later renamed repositories because _annotation set_
was considered too technical a term) and to allow users to select which
annotation sets to actually use information from (a __profile__ of the system). 

The problem with __homonyms__ I can easiest illustrate with a
hypothetical couple of Flickr posts: one from a fishing trip and one of
a jazz quartet, both tagged with _bass_.  When I'm searching for bass,
the fish, how do I avoid hits for bass, the instrument? (For that matter,
how do I google for information on the Latin language or latin
alphabets without instead discovering web sites devoted to pictures of incompletely clothed Americans of Spanish
descent?)  The solution is to organize the concepts in to some sort of
hierarchy, so that you can have _objects/musical instruments/stringed/bass_
distinguished from _nature/animals/fish/bass_, say. In directories like
the original Yahoo and the present [DMOZ][6], you locate categories by
navigating from general categories to more specific ones, and I took
that as my model for my SEAHORSE prototype. 

__Synonyms__ are tricky because different people will choose different
words to represent the same subject, often __hypernyms__ (more generic
terms) or __hyponyms__ (more specific words). For example, using our
hypothetical bass photos again, if I searched for tags like
_micropterus_, _fish_, _double bass_, or _strings_, it would not match
_bass_. This is where a prearranged collection of categories is useful:
by either requiring people to choose from a list, we avoid confusion
caused by synonyms; hypernyms and hyponyms by treating a page tagged
with _nature/animals/fish/bass_ as implictly being tagged with
_nature/animals/fish_, _nature/animals_, and _nature_. This ends up with
what amounts to a __controlled vocabulary__ or __taxonomy__, where a
bunch of wise people come up with a standardized list of categories in advance to
be used by everyone else. There might or might not be arrangements for
extending the taxonomy as new concepts are required. 

In a way __localization__ is similar to the synonym problem: this
project was pan-European, and we were working on the assumption that it
would sometimes be useful for a non-English-speaker to be directed to
English-language resoures (they might be able to get someone to
translate them once they've found them). The approach taken was to use
numbers to represent categories internally, so that number 356 might be
named _fish_ in English and _poisson_ in French. Unlike DMOZ, I did not
split the hierarchy in to segments based on language: all languages
shared a common taxonomy, translated in to that language.  We did not
have any budget ear-marked for translation, so I designed the system so
that volunteers could supply translations gradually and piecemeal. If a
new category was added in English, and you visited Greek version of the
site, you would see the English word until the Greek translation was
added.

For navigation I followed the lead of Yahoo and other directory web
sites (most people have forgotten it now, but Yahoo started life as
the first attempt at a directory for the whole WWW). This meant that
most pages had a list of cataegories, and clicking on them lead to a
page containing their subcategories, and so on, until you found the page
with the precise category you were after, and the list of links and
articles related to that category. 

The problems with the solutions
-----

There were all sorts of problems with the GUI for a variety of reasons.
Partly this was lack of development time: I was the sole developer on
the whole project, which is rather remarkable considering there were
about twenty people working on the project. I was expecting
there to be another person working on the UI proper, with me supplying
the back-end code that handled the links and categories and so on. I
structured my code accordingly: I had a test framework to allow me to
exercise the innards of the program and index the fifty sites that I had
been given (on paper) to prime the pump. As it turned out, the
consortium partner with responsibility for the UI had never used a
computer (she had a friend to 'do the photoshopping' bit), so that
responsibility devolved to me. 
We ended up adapting my Yahoo-style test rig as the public face of
SEAHORSE.

The upshot of this was that we designed the application backwards: first
the underlying model, then a user interface, then inventing use cases to fit the UI.

There were two big problems with this. First, we had no way for the
reader to choose to search using more than one category, since the only
way to choose one was to visit its page. Second, creating new
categories, and tagging links with categories, was a clumbersome process.
It made sense for my test rig to have a Create Category page separate
from the Add Link page, because I wanted to be able to create all these
various objects independently of each other during testing; quite
another thing to expect volunteers to click through several pages in
order to register one lousy link.

As a result of this, no-oner quite grasped the idea of a page being
tagged with *many* categories. It also meant [they never saw any
need][8] to create the fine-grained categorization scheme I had
envisiaged. I did not matter that I had documented all this; [users
don't read documentation][7].

It got worse. We added a hierarchical list of categories with
progressive display (Microsofties call this a TreeView), which was nice
(once I had worked out how to make it display fast). But this just
encouraged people to think of categories as being like folders. My boss
started talking about our clever use of the 'Windows Explorer metaphor'.
We redesigned their icons to look like folders.  It didn't really matter
what I said: they became folders to everyone else.  

No-one else on the project seemed to grasp my attempts at empowering the
user to choose whose reputations to trust (the annotation-sets and
profiles and suchlike). It just meant extra user-interface clutter that
they did not care about and just got in their way. Soon they were asking
me to create folders for 'their' metadata to go in,
which was pretty much the end of any attempt to make categories be used
for organizing pages by topic.

What about people who want to contribute to the database? Our users were
'empowered' to *suggest* additions to the linkbase that would not be
published on the site until checked by an agent of one of the consortium
partners. This was to 'preserve quality'. What it meant, of course, was
that we gave no reward to casual readers volunteering information, so
they would wander off to a web site that did.

There is also a big problem with deeply hierarchical taxonomies: people
don't like them, and they won't use them. Consider _Roget's Thesaurus_,
which originally was all about subdivision of concepts in to collections
of terms for describing that concept: it was never successful until an
alphabetical index was added, so that people could look up _excellence_
without the trouble of trying to work out where it belonged in Roget's
system. Similarly, have a look at the front page of [DMOZ][6]: can you
guess which of these very abstract top-level categories will be
concealing an entry for _bass_? I had to use the search box to find it.
Yahoo started as a directory, but has long since sidelined that in
favour of free-text search and other features.

The SEAHORSE hierarchy is particularly bad because it was created
*before* tagging any documents, not after. As a result, its top few levels
are cluttered with concepts that no-one is particularly interested in,
and you have to dig deep to find anything of interest. This is a common
problem with taxonomies that are designed before a large body of work
has been analysed to see what topics actually are needed, and actually
are useful enough to be worth emphasizing. 

Another thing that undermined SEAHORSE was the time it took to come
on-line.  By 1999 there were many web sites with HIV and Aids
information; you could take your choice of providers of information.
Other things that were good for people but bad for SEAHORSE were
statutory organizations' catching up with HIV research, which made
grass-roots medical publications largely obsolete, and combination
therapies: people with HIV were suddenly finding themselves
in the position of being able to resume the lives they had had to
abandon when they became sick. As a result there were simply fewer
people available with any time for and interest in contributing  
to a community-based HIV/Aids information resource.


Lessons
-----

When I came to be throwing together the software that generates this web
site, I wanted to be able to categorize my articles.  I decided to
eschew all the clever formalisms and try to invent the simplest thing
that could possibly work.  Articles for this site are plain text files,
starting with an RFC-2822-style header (but I do not support all the hairiness of  RFC
2822), followed by the text of the article in [Markdown][9] format
(older articles are in XML).  
One of the headers is `Topic`, and it contains keywords separated by
spaces.  There is a file, `subjects.data`, that lists these keywords on
separate lines with a properly spelled version of the name:

<pre>
...
pbmplus: PBMPlus
markdown: Markdown
pymarkdown: pyMarkdown
zeo: &lt;abbr title="Z Enterprise Objects">ZEO&lt;/abbr>
zodb: &lt;abbr title="Z Object Database">ZODB&lt;/abbr>
...
</pre>

The page [subjects.html][10] is made by scanning the articles for
keywords and making the links automatically. The idea here was to make
it as easy as possible to add categories, but still to allow for their
names to use the features of HTML.  The topics are arranged in the file
in a fashion I vaguely intended one day to use to group the topics into
a hierarchy.  But (unlike SEAHORSE) I intentionally concentrated on
making adding the topics easy, while leaving scope for more complicated
stuff later.

This is reminiscent of the 'worse is better' debates that used to rage
between Lisp and C enthusiasts. Lispy culture emphasized the 'better is
better' approach, where you would decide ahead of time exactly how
something would work, and implement that correctly and without
compromise. C hackers were content to come up with something that was
easy to implement and work around the imperfections. The WWW is often
cited as another example: HTML solved the problem of broken links that
had been concerning hypertext experts for decades by simply ignoring it.

[Flickr][1] and [del.icio.us][2] wisely give usability precedence over
all other concerns, and use essentially the same system. Entering a set
of as many categories as you like is a simple matter of banging in the
names with your keyboard. Unlike my site (which is static HTML), they
both allow you to search using multiple tags in combination.

The problems of synonyms, homographs, and localization have been dealt
with by ignoring them: the problems are not *bad
enough* to be worth the cost of solving them. If the alternative is the
complexity that stifled SEAHORSE, then they are right to do so.  
Some people are aware of the hypernym problem, and can address it themselves
by using multiple tags. For example, I tagged [my photos of the
Westminster clock tower][12] with [_london_][14] in addition to
[_westminster_][13]. This gives much of the benefit of  a hierarchical
geographical taxonomy, without the inconvenience of the hierarchical
taxonomy itself.

If synonyms are a big enough problem in the longer term, we can think
about clustering tags together using loose look-up tables. Flickr
already do this to an extent: if you visit the page for a tag, as well
as listing photos with that tag, it also lists tags that are often found
associated with the same photos. Other forms of analysis might be able
to derive structured keywords from the unstructured tags: and this will
work better *because* tags are so easy to add, which means there will be
enough of them to do decent statistical analysis on.

This will not be completely straightforward.
Different people make up words according to their own ideas, and
the result is that sometimes tags are not used the way you might expect.
But if people find that clustering of tags makes Flickr more fun for
them, then they will take more care over choosing their own tags to
increase the number of matches. Flickr allows you to change the spelling
of existing tags to correct typos.

You could also (if you really cared) piggy-back a structured vocabulary
on top of Flickr's tags. [ISO Topic Maps][11] allow for a topic to be
identified by any number of subject indicators (that is, URLs used to
identify a subject). I could publish a topic map in which I describe the
topic identified by my tag <http://del.icio.us/pdc/programming> and how
it relates to other topics, including ones identified by other users'
tags, thus merging our taxonomies in arbitratrily subtle and nuanced
ways. 

Just remember what the corpses of countless overdesigned metadata
projects tell us: subtlty is not everything.



  [1]: http://flickr.com/
  [2]: http://del.icio.us/
  [3]: http://seahorse.oxi.net/ "Self-help, empowerment, and awareness of HIV/AIDS: the on-line research and support exchange"
  [4]: http://www.comphealth.org.uk/
  [5]: http://www.tht.org.uk/
  [6]: http://dmoz.org/
  [7]: http://joelonsoftware.com/uibook/chapters/fog0000000062.html "User Interface Design for Programmers Chapter 6: Designing for People Who Have Better Things To Do With Their Lives"
  [8]: http://joelonsoftware.com/uibook/chapters/fog0000000058.html "User Interface Design for Programmers Chapter 2: Figuring Out What They Expected"
  [9]: http://daringfireball.net/projects/markdown/
  [10]: ../2003/subjects.html
  [11]: http://topicmaps.org/
  [12]: http://flickr.com/photos/pdc/507133/
  [13]: http://flickr.com/photos/pdc/tags/westminster/
  [14]: http://flickr.com/photos/pdc/tags/london/
