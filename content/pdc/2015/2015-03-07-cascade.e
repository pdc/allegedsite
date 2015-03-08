Title: The Cascade Trap
Topics: jqueryuk css
Date: 2015-03-07

The Cascading Style Sheets language has this neat featured called the
*cascade*, where an element on your page acquires its value for a property
from the most-specific of several applying rules in the style sheet. This is a
feature that should be used sparingly if you don’t want your style sheet to
balloon in to a mess of overrides.


## Background

The original idea of the cascade is that you have a definitions for `p`
(paragraph) elements, that needs to be tweaked only slightly if the paragraph
happens to fall in the abstract of the science paper you are assumed to be
using CSS to style:

    p {
        font-family: Computer Modern, serif;
        font-size: 10pt;
        margin-top: 1.2em;
        margin-bottom: 1.2em;
    }

    #abstract p {
        font-size: 12pt;
        margin-left: 2em;
        margin-right: 2em;
    }

Suppose this style sheet is being applied to `p` element in the following HTML fragment:

    <section id="abstract">
        <p>
            Diverse pedagogical modes may be operationalized through the
            application of
            … etc …
        </p>
    </section>

Both rules apply, and plainly the top and bottom margins are acquired from the first and
the left and right margins from the second rule. What about `font-size`? Its
value comes from the second rule because it has the most-specific selector.

The [CSS recommendation][1] has [a section describing the cascade][2] that
spells put the details of deciding which rules matching a given element are the most specific.

  [1]: http://www.w3.org/TR/CSS2/
  [2]: http://www.w3.org/TR/CSS2/cascade.html#cascade


## Where Does it Go Wrong?

Having failed to devise an extensible markup-language to superseed HTML,
modern web pages have to stretch the definitions of HTML semantics a lot to
create the sorts of user-interfaces we are expected to implement. I had a
minor epiphany a few weeks ago that I will attempt to describe here using a
simplified version of the code in question.

On the [Photocrowd][] site we use `a` tags not just for links in paragraphs of
text—what you might call the traditional meaning—but also for button-like
call-to-action links  (amongst
other things omitted for clarity).

    …
    <p>
        This assignment reviewed by
        <a href="/experts/michelle-marshall/">Michelle Marshall</a>
    </p>
    …
    <div class="btn-list">
        <a class="btn btn-lg" href="/contests/133-smiles-and-laughter/">Find
            out more</a>
    </div>
    …

This results in CSS code like this:

    a {
        color: @logo_clr;
        &:hover {
            color: @logo_lit_clr;
        }
    }
    .btn {
        color: #FFF;
        background-color: #FFF;
        &:hover {
            color: #FFF;
            background-color: @logo_lit_clr;
        }
    }

Why does  the `.btn:hover` rule specify the colour of the button text, even
though it is not supposed to change? Because the `a:hover` rule would also
apply, and it takes precedence due to the cascade.

To make things more complicated, on assignment pages we use a different colour
scheme, so we need additional code like so:

    .assignment-theme {
        a {
            color: @ass_clr;
            &:hover {
                color: @ass_lit_clr;
            }
        }
        .btn {
            color: #FFF;
            background-color: @ass_clr;
            &:hover {
                color: #FFF;
                background-color: @ass_lit_clr;
            }
        }
    }

We have to again repeat the rules
saying that button text is white, because `.assignment-theme a` is more
specific than `.btn`. With the mouse over a button-styled link, there are eight rules fighting it out over what colour the text should be:

    .assignment-theme .btn:hover
    .assignment-theme .btn
    .assignment-theme a:hover
    .assignment-theme a
    .btn:hover
    .btn
    a:hover
    a

This is a simplified version of the situation in the real site, where we also
have menu headers, menu items, expandable text, links in the Menu menu and the
footer, links in the Menu menu and footer that are emphasized by swapping the
colours around, and  button-styled links in the Menu menu and footer—all of
which used different colours on assignment pages, and custom colors on contest
pages.


## What I Changed

After the Nth bug report that the colour of buttons had gone wrong on this
page or that page, I suddenly realized that one of the assumptions we had made
that caused all this was that when using `a` tags to mean their tranditional
meaning—links in running text—we should use plain `a` tags. But when I thought
about it I realized we mostly use `a` tags for something else; traditional
links are the exception not the rule.

I changed the HTML to add a `link` class to  `a` tags that are intended to
look like links, and then the CSS required become much simpler and less
repepatative:

    .lnk {
        color: @logo_clr;
        &:hover {
            @logo_lit_clr;
        }
    }
    .btn {
        color: #FFF;
        background-color: @logo_clr;
        &:hover {
            background-color: @logo_lit_clr;
        }
    }

    .assignment-theme {
        .lnk {
            color: @ass_clr;
            &:hover {
                @ass_lit_clr;
            }
        }
        .btn {
            background-color: @ass_clr;
            &:hover {
                background-color: @ass_lit_clr;
            }
        }
    }

No need to continually override the text colour of buttons, because we are no
longer telling the CSS that a button is kind of link.  (And again, this is
simpler than the real version, where there were many times more link
variations and the code was scattered throughout the CSS codebase.)

The upshot of this is that you want to reduce the use of the cascade and
part of achiving this is to surface the meanings in explicit CSS classes
rather than cleverly infering them from context. Where in some standard
generalized markup language one might have defined a document type that
matched what your document actually needed and write things like the
following:

    …
    <p>
        This assignment reviewed by
        <lnk href="/experts/michelle-marshall/">Michelle Marshall</lnk>
    </p>
    …
    <btn-list>
        <btn large href="/contests/133-smiles-and-laughter/">Find
            out more</btn>
    </btn-list>
    …

we must instead express this through HTML classes like so:

    …
    <p>
        This assignment reviewed by
        <a class="lnk" href="/experts/michelle-marshall/">Michelle Marshall</a>
    </p>
    …
    <div class="btn-list">
        <a class="btn btn-lg" href="/contests/133-smiles-and-laughter/">Find
            out more</a>
    </div>
    …

Another way we can reduce the use of cascade is to avoid using combination-
class selectors. Instead of this:

    <a class="btn large">Find out more</a>

    .btn { … }
    .btn.large { … }

we should think of ‘large btn’ as a subclass or ‘btn’, using the generic class
name suffixed with a word hinting at the customization.

    <a class="btn btn-large">Find out more</a>

    .btn { … }
    .btn-large { … }

The HTML includes the both the generic and the specific classes.


## Further reading

A lot of the thoughts I have been working through  about CSS organization are
developed further in [Mark Otto’s talk at jQuery UK 2015][4] and his [Code
Guide][5] web site.


  [Photocrowd]: https://www.photocrowd.com/
  [3]: https://www.photocrowd.com/experts/michelle-marshall/
  [XML]: http://en.wikipedia.org/wiki/XML
  [SGML]: http://en.wikipedia.org/wiki/Standard_Generalized_Markup_Language
  [4]: https://speakerdeck.com/mdo/at-mdo-ular-css
  [5]: http://codeguide.co
