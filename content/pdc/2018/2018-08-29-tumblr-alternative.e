Topics: meta tumblr
Date: 2018-08-29
Title: What to do about Tumblr?

I am struggling to think of alternatives to using Tumbler for my link blog.


# Tumblr, Tentacle of Verizon

I have used a Tumblr blog as a way to link to interesting things I find online
for years now. Its main advantages are

- it reduces the friction to posting a link, and
- it is well known, so people can follow me easily and see my posts mixed in with other interesting stuff.

The downside is that Tumblr is yet another social-media silo trying to make a
buck by accumulating data about me, and the GDPR is making it impossible to
ignore its takeover by a creepy cable company.

Sadly, if I want to use a service paid for by advertising, I have to accept
that advertisers will exhaustively track my every move online so they may make
their marketing more efficient (meaning more manipulative)—and if I host my
content on their system I am condoning my readers’ being treated just as
badly.


# What do?

What if I don’t want to accept this? I have to do one of the following:

* complain about it and then carry on as usual;
* pay for a replacement either in money or effort (i.e., building my own);
* link to things on one of the social-media platforms I am less creeped out by
  (most people just post their links on Twitter); or
* stop linking to things—after all does anyine really care which typography specimens I find amusing?

Most of those options require no further discussion, so I will continue this
entry assuming I plan to throw something together myself, and what I would
want this hypothetical solution to provide.


# Wishlist

What do I want from a linking-to-stuff solution?

Suppose I was going for the [IndieWeb][] approach, with my posts and the
information about the links stored on my server rather than a corporate one.

## Low friction

The link-publishing process should be as frictionless as possible. Ideally it
would work a little like Tumblr’s, where you start with the URL of the page
you are interested in and the editor downloads the page server-side and
examines it for metadata to start the post with—and then lets you edit in a
phone-friendly manner. This would make a good bookmarklet on desktop browser,
and probably the least-bad starting point for a mobile-optimized note-taker
web app.

## Sourcing

Links should be be published with acknowledgement of sources, and to make
this easy my blog should gather source references as conveniently possible.
It is nice sometimes to credit the person whose link to the original helped you discover it
(expressed with ‘via’ links).
Ideally I could start with a tweet to something cool, have the editor peel
back the layers of indirection to the original web page, and then the
published link would be to the original resource with  a ‘via @somebody’ link
back to the tweet.

## Links are Optional and Repeatable

If we make the links optional, then a post can be just a short note, much like
a Twitter tweet or Mastodon toot.

Sometimes a post can link to multiple pages. A single post might have a
gallery made of some Flickr images, for example. It would show the images as
large thumbnails in some kind of gallery layout, and link to the original
Flickr pages.

## Readers Don’t Need Special Tools

Hypothetical readers must be able to follow a time-line of my links

* without having to  visit my site religiously every week to check up on it,
* without signing up to a new subscription service or something,
* without having to use an RSS feed reader.

Otherwise I don’t think many people will bother.

## Readers can React and Comment

Neverthless it would be nice if I could have the chance to gloat at how many
likes or boosts or whatever I have accrued with my posts. This feature is low
priority because the amount of interaction with my posts is normally so close
to zero it might be depressing to actually measure it.

## Also Atom (and ActivityPub if that’s easy)

Although I don’t expect most people to use a feed reader these days,
syndication should also include an [Atom][] feed. I think [ActivityPub][] is
based on Atom, and I should look in to what it takes to make a blog support
someone following my blog on Mastodon.

## Also Linked Data

It would also be nice to expose the links as [linked data][]—the sort of thing
that can feed semantic-web processors and be added to a dataset and queries
with SPARQL. As an alternative to traditional RDF representations there is a
relatively new format [JSON-LD][] designed to map on to RDF but be consumable
by  [JAMstack][] apps as well.

## Gallery

I want a pretty gallery of links nicely arranged, with some
support for discovering posts by topic rather than only listing the most
recent ones. This is a chance to play with CSS grid.

## WebMention

I should mention [WebMention][]. My link blog would need to analyse new posts
and notify WebMention-savvy sites that I had linked to them.

## No User Accounts Needed

To make it easier to make it secure, the public interface ideally will have no
logins and be read-only.

This means I need have no commenting system on my own site—which would have otherwise required a lot of
work with user accounts and authentication and password resets and profiles and so on.


# POSSE

The IndieWeb solution to readers not needing special tools
is called [POSSE][] (publish on my own
site and syndicate elsewhere). With this approach, posts to my link blog would
be automatically duplicated on some subset of Facebook, Twitter, and Tumblr,
allowing my hypothetical reader to follow it using a site they’re already
signed up to, and respond and feed back on the platforms they are familiar
with.

Having outsourced the feedback, it would be nice to be able to gather comments
and likes on the syndicated copies of a post so as to display it on my page
for the post. There are various [IndieWeb bridge][] apps out there to explore.

POSSE support is a prerequisite for making the public site read-only, because
I would be delegating interaction with posts to other social media.


# Thinks

In writing this list I have discovered  I am describing something that could
replace my use of Tumblr without being exactly like Tumblr. Assuming I can get
the POSSE aspect working somehow, it also might be a way to post to Twitter,
Mastodon, and Facebook without relying on services like [IFTTT][] being able
to parse the feed from one to forward it to another. It could address the
issue that my link blog doesn't include links I discovered via Twitter,
because adding them is too much like hard work.

Using Django it is easy to see how I might set up a barely working system with
moderate effort; the question is, can I make it easy enough to use that I
prefer it to sticking with Tumblr?


  [ActivityPub]: https://www.w3.org/TR/activitypub/
  [Atom]: https://tools.ietf.org/html/rfc4287
  [IFTTT]: https://ifttt.com/
  [IndieWeb]: https://indieweb.org
  [IndieWeb bridge]: https://indieweb.org/bridge
  [linked data]: http://linkeddata.org
  [JAMstack]: https://jamstack.org
  [JSON-LD]: https://json-ld.org
  [POSSE]: https://indieweb.org/POSSE
  [WebMention]: https://www.w3.org/TR/webmention/
