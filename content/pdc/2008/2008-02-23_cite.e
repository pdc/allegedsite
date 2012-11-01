Title: The ‘cite’ that is Understood is not the True ‘cite’
Date: 2008-02-23
Topics: html5 html 
Icon: ../icon-64.png

[Mark Pilgrim reports][0] that he’s been misusing the HTML `cite` element all these years because the [HTML 5 definition][5] contradicts his use of `cite` to wrap authors’ names. Just when I was about to crow excitedly that I’d always said he was wrong, I checked the old specs and discovered we both were—or actually, that HTML 4 was wrong. 

For what it’s worth, the element `cite` originally got its name and meaning from the
`@cite` request [in Texinfo][1] (documented at least as far back as [1988][]), and the
description there refers simply to book titles:

> Use the `@cite' command for the name of a book that lacks a companion
> Info file.  The command produces italics in the printed manual, and
> quotation marks in the Info file.

The [HTML 2 spec (1995)][1995] also [mentions book titles only][2]:

> The CITE element is used to indicate the title of a book or other citation. It is 
> typically rendered as italics. For example:
> 
>     He just couldn't get enough of <cite>The Grapes of Wrath</cite>.

Both mention that titles are usually shown italicized.

The [HTML 4.01 definition][3] (1999) is ‘contains a citation or a reference to other
sources’ which would be vaguely consistent with HTML 2, *except* the examples they supply
show it used to surround the name of a speaker and a coded reference, not book titles:

	As <CITE>Harry S. Truman</CITE> said,
	<Q lang="en-us">The buck stops here.</Q>
	≈
	More information can be found in <CITE>[ISO-0000]</CITE>.
	≈
	Please refer to the following reference number in future
	correspondence: <STRONG>1-234-55</STRONG>

Both of their examples would *not* normally be italicized. Obviously the authors of the
HTML 4 recommendation were guided not by existing definition or usage in existing
documents, but by the name of the element. To my mind this constitutes poor scholarship,
the same sloppiness that has caused the `dfn` and `var` elements to lose their original
meanings.

The result of this is that HTML 4 *changed the meaning* of one of the OH SO IMPORTANT
semantic elements, which in turn does rather indicate that the semantic content was
perhaps not so important as all that, given that no-one working on HTML 4 knew or cared
what the established meaning of the `cite` element was!

And before you accuse me of being some proponent of wysiwyg point-and-drool word-processing, check out the articles on this very web site. There are documents going back over ten years, and for the first few years I consistently used `cite` for book titles, which was correct according to HTML 2, but incorrect according to HTML 4. Since [I switched][6] to using [Markdown][4] to write my articles in, I have lost the facility to easily distinguish italicized book titles from italicized anything else—but after years of careful, pedantic mark-up with no reward I find I don’t care any more.

  [0]: http://diveintomark.org/archives/2008/02/19/all-these-years
  [1]: http://www.cs.cmu.edu/cgi-bin/info2www?(texinfo)cite
  [2]: http://www.w3.org/MarkUp/html-spec/html-spec_5.html#SEC5.7.1.1
  [3]: http://www.w3.org/TR/html401/struct/text.html#h-9.2.1
  [4]: http://daringfireball.net/projects/markdown/
  [5]: http://www.whatwg.org/specs/web-apps/current-work/multipage/section-phrase.html#the-cite
  [6]: ../2004/04/24.html
  [1988]: http://www.cs.cmu.edu/cgi-bin/info2www?(texinfo)Top
  [1995]: http://www.w3.org/MarkUp/html-spec/html-spec_toc.html