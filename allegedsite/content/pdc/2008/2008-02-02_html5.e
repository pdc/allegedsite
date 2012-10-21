Title: Some Bold (and Italic) Thoughts on HTML 5
Date: 2008-02-02
Icon: wp/icon-64x64.png
Topics: html5

[Internationalization Activity][] leader  [Richard Ishida][] [comments][1] on the 
[HTML 5 draft][HTML 5 draft], The formerly deprecated `b` and `i` elements of <abbr>HTML</abbr> are [defined in terms of their appearance][2]: for example, the name of a ship can be bracketed with `<i>…</i>`, because ship names are italicized. The problem is, of course, that this  applies to English, but not to Japanese, for example. Should these tags be suppressed in favour of something ‘more semantic’ (whatever that means)?

Where it Started
================

<abbr>HTML</abbr> inherited its inline elements from the Texinfo format. In Texinfo, there were
directives for the types of emphasis expected in computer documentation (`@kbd`, `@samp`,
`@code`, `@file`, `@dfn`, `@var`, ...), many of which have no equivalent in non-technical
prose. To be honest, most of them are not used in most technical documentation, because of
ignorance or unconcern induced by the use of Microsoft Word, whose default styles do not
include anything for computer text.

<div class="wide_photo_right"><a href="http://www.flickr.com/photos/pdc/2223972344/" title="Pencils (Vortex) by Damian Cugley, on Flickr"><img src="http://farm3.static.flickr.com/2406/2223972344_6385b3e2d3_m.jpg" width="240" height="180" alt="(photo)" /></a></div>

Because there were no tags for book titles, foreign tags, binomial names (as in _Homo
sapiens_), and all the other things we conventionally use italic for, the advice was to
just use `<em>…</em>`, which frankly is no more semantic than using `<i>…</i>`. If
anything it is worse, because it means `em` is no longer consistently representing
emphasis.

It Gets Worse
=============

To make things worse, Microsoft Internet Explorer’s default rendering of
the `var` and `dfn` element shows they misunderstood their purpose, hastening their
obsolescence. The `var` element was originally for ‘variables’ such as <var>x</var> and <var>y</var> in mathematics or placeholders in syntax definitions, as in the following example:

> Type the command `rm -rf`&#xA0;<var>dir</var>
> to delete the directory <var>dir</var> and all its contents.

The usual convention is to distinguish the varaiable (<var>dir</var> in this example) using italics. <abbr title="Microsoft Internet Explorer">MSIE</abbr> instead used the monospace (‘typewriter’) font used for computer text, seemingly thinking that `var` was for identifiers found in computer programs.

The `dfn` element was for defining instances of a term, as in the following example ([stolen from Wikipedia][3]):

> A <dfn>definition</dfn> is a statement of the meaning of a word or phrase. 
> The term to be defined is known as the <i>definiendum</i> (Latin: 
> _that which is to be defined_). The words which define it are known as the
> <i>definiens</i> (Latin: _that which is doing the defining_).

The typographical convention used varies from book to book; I have seen italic, bold, and
bold italic used. Italics makes sense to me because it corresponds to the
emphasis that is given to the term when speaking a definition aloud. Boldface makes sense
because it allows one to find the term later when skimming backwards to remind yourself of
the definition. Most web browsers do not distinguish text enclosed in `<dfn>…</dfn>` at
all.

Both of these problems are non-issues nowadays, since we can override the default styles
using <abbr title="Cascading Style Sheets">CSS</abbr>. But during the late 1990s this was not possible, so even the vanishingly small
percentage of the writing population that knew and cared about such distinctions had to
drop them.

Is the Solution to Add More Tags?
=================================

When <abbr>HTML</abbr> started being used more widely they could have added more elements for embedded
foreign words, words mentioned but not used, etc., but never quite got around to it. It is
probably just as well: this process could go on forever as technically-minded folks are
liable to invent distinctions that would never be used by normal people. Donald E. Knuth,
for example, used two different forms of italic in his books (traditional italic for
emphasis, slanted for book titles), and I have seen people who give different meanings to
‘…’ and “…” quotation. The problem is that this makes it even harder for a non-specialist
to know which tags to use to mark up a given phrase, which makes it more likely that they
will throw up their hands and refuse to try to learn.

<div class="wide_photo_left"><a href="http://www.flickr.com/photos/pdc/2205504227/" title="4 Jenga by Damian Cugley, on Flickr"><img src="http://farm3.static.flickr.com/2024/2205504227_2d5be6ab4d_m.jpg" width="240" height="180" alt="(Photo)" /></a></div>

And let’s not forget that most people who write do not write their own tags, but just mash ⌘I to make their word processor switch to italics mode.

What the <abbr>HTML</abbr> 4 standard *did* do was introduce the `q` tag to represent quotation. This
was, [in my opinion][4], a serious error, and has cost web-browser implementers [hours of
labour][5] that could have been better spent doing something useful.

The <abbr>HTML</abbr>-5 approach is to take the opposite tack, and un-deprecate the `i` tag, giving it the meaning roughly ‘something that would normally be italicized’. In scripts that do not use italics this might be taken as meaning that the `i` tag is not useful with those scripts, or that it might be used to mark up text whose connection to italic fonts is more tenuous.

It this seems too simple consider that the _Guardian_ newspaper [goes one further][6], and
distinguishes book and movie titles, ship names, and all that jazz with the use of capital
letters alone: they do not use italics for these. In the busy environment of a news office
this probably gains them hundreds of person-hours’ productivity a week by eliminating a
whole class of argument between sub-editors.

Translation
===========

One question Richard Ishida raises is that this may mean that a translator of a passage has less information to work with than if more detailed semantic mark-up were used. While I can see the point I don’t think it is likely to make a big difference practically.

For example, suppose our hypothetical translator has the following paragraph to translate to Japanese:

> Captain Sulu beamed up to the _Excelsior_ and handed Krorg’s _bat’leth_ to
> the transporter chief to dispose of. 
> _I almost didn’t make it this time,_ he thought ruefully.

Already she needs to know whether to render Sulu’s name as Kato (as used in the Japanese version of the TV show) or some transliteration of Sulu, the Japanese transliteration of Krorg’s name and the Klingon term _bat’leth_, and for that matter a decision on whether _Excelsior_’s name is to be transliterated or translated. At this point I imagine that recognising that _Excelsior_ and _bat’leth_ are italicized for different reasons and these correspond to different punctuation marks in Japanese is the least of her troubles.

This is what XML is for
=======================

There are still situations where the complete and accurate marking up of text *is*
desired—generally in an academic or other technical context. For these purposes, an
application-specific XML vocabulary seems like the ticket. Trying to add all the possible
extra meanings people might need to <abbr>HTML</abbr> will only bloat <abbr>HTML</abbr> (which is already too
complex) while probably omitting exactly the special meaning you need now.

The alternative if sticking to <abbr>HTML</abbr> would be to use `class` attributes in the obvious way to augment the information conveyed by the `i` tags:

	<p><span class="nameprefix rank">Captain</span> Sulu beamed up to the <i
	class="ship">Excelsior</i> and handed <span class="personname
	transliteratedfromklingon">Krorg</span>’s <span class="foreignword
	transliteratedfromklingon">bat<span class="glottalstop">"’</span>leth</span> 
	to the transporter chief to dispose of. <i class="internalmonologue">I 
	almost didn’t make it this time</i>, he thought ruefully.</p>

This saves us the inconvenience of having to add a definition to the <abbr>HTML</abbr> 5 standard describing the tag used to represent telepathic speech in sf novels.




  [Richard Ishida]: http://rishida.net/
  [Internationalization Activity]: http://www.w3.org/International/
  [1]: http://rishida.net/blog/?p=134
  [2]: http://www.whatwg.org/specs/web-apps/current-work/multipage/section-phrase.html#the-i
  [HTML 5 draft]: http://www.whatwg.org/specs/web-apps/current-work/multipage/
  [3]: http://en.wikipedia.org/wiki/Definition
  [4]: ../2003/marks-of-quotation.html
  [5]: http://archivist.incutio.com/viewlist/css-discuss/4682
  [6]: http://www.guardian.co.uk/styleguide/page/0,,184827,00.html