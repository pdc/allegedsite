Title: Ooble: Work in Progress
Date: 2019-02-24
Topics: ooble django python

New side project: I am working on a microblogging app called Ooble. The aim is to be able to
replace my use of Tumblr for linking to web pages I find interesting and
making short notes.


# Motivation

The [GDPR][] has made what was already a grim situation
with regard to advertising-backed social-network sites even grimmer.

<div class="image-left">
    <img src="02-tumblr-160w.png" width="160" height="284" alt="(screenshot)"
        sizes="160px" srcset="
            02-tumblr-160w.png 160w,
            02-tumblr-320w.png 320w,
            02-tumblr-640w.png 640w
        " />
</div>

I can’t
read a comic on Hive or a blog hosted on Tumblr without a multi-page form
trying to browbeat me in to consenting to their misuse of tracking data. I
don’t like it, and I don’t like that by hosting my link blog on Tumblr I am
subjecting my readers (I like to pretend they exist) to the same abuse.

The recent Tumblr announcement that images designated by their easily confused
machine-learning algorithms as adult content will be banned is a reminder of
how much power over our expression we have allowed these gatekeepers to
assume. You should not need to be a porn freak to be chary of granting
American companies sole discretion over what is decent or indecent in the UK
or wherever else we live.

With some effort I can instead host my links and likes on my own site,
[pdc.ooble.uk][]. Without advertising there is no need for tracking
or secret cookies and I am free to write what I like (with the responsibility
that entails, of course).


# What Ooble Is

What you see on [pdc.ooble.uk][] is series of [note][]s: short
(single-paragraph or less) jottings that will often link to something interesting I
have found online. Where possible the links will be illustrated with a
thumbnail from the page and summary text.

They are presented in (reverse) chronological order. There is a modicum of
organisation, in that you can filter notes by tag.

There is also an Atom feed for antediluvian feed-reader fans and [IFTTT][].


# What Ooble Is Not

Ooble is not a social network: readers will not need to join Ooble to read it
or follow updates.  In the fullness of time you will be able to like or boost
‘syndicated’ copies of notes on your existing social networks or IndieWeb
site.

The great benefit of this for me is I don’t need to expend effort supporting
massive scalability in order to handle thousands of users:

  * since only the
    editors need accounts (which so far just means me), and

  * my entire multi-year
    Tumblr archive fits in a few GB, meaning it is OK to just use ordinary files
    instead of some exotic hosted storage solution.

Less time faffing with
infrastructure means more time to spend making something fun.


# What Ooble May Become

[Webmention][] support is probably next on my list; this should allow me to
plug in to the [IndieWeb][] social meta-network. Ooble should then be able to
syndicate notes to Twitter, Mastodon and my old Tumblr blog, so that someone
who does want to follow me can without needing a feed reader.

Other things to look in to:

  * I want to explore making the page layout more interesting and give more
    emphasis to must-read links over things merely noted to be read later.

  * The internet is awash with unattributed photographs and other work: How can
    Ooble make it easier to  include better attribution and sourcing in link
    pages?

  * Mastodon makes a feature of hiding posts or images behind content warnings,
    which I should try to mix in to Ooble somehow.


# What Ooble Means

Turns out _ooble_ is a word for rolling about on the floor out of boredom.


  [pdc.ooble.uk]: https://pdc.ooble.uk/
  [GDPR]: https://ec.europa.eu/commission/priorities/justice-and-fundamental-rights/data-protection/2018-reform-eu-data-protection-rules_en
  [note]: https://indieweb.org/note
  [IFTTT]: https://ifttt.com/
  [Webmention]: https://www.w3.org/TR/webmention/
  [IndieWeb]: https://indieweb.org/
