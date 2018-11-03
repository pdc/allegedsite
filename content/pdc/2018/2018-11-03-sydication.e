Topic: meta syndication
Date: 2018-11-03
Title: Syndication Links
Link: <https://octodon.social/@pdc/101006646972410830>; rel=syndication
Link: <https://twitter.com/damiancugley/status/1058659319514910720>; rel=syndication

I am scratching me head over  transitioning from using the Twitter button on my blog
pages and toward some kind of IndieWeb solution with syndication link.


# The Old Way

My site design has a Tweet This button in the side bar of entries, using a
snippet supplied by Twitter that creates a new tweet referencing the article
in question. This has a couple of downsides:

- it allows Twitter to daub my site with cookies;

- in the event that people actually use it, it generates individual posts
  linking to my entry, making it hard to aggregate feedback on the article
  without using Twitter’s search interface.

It might be better if I instead tweeted a single link to the article, and then
encouraged readers who want to interact with it via Twitter to retweet or
favourite that tweet. Then I can see any replies or retweets by checking that
one tweet.


# Also Mastodon

I was thinking about this in the context of not wanting to promote Twitter at
the expense of, say, [Mastodon][]. Mastodon is another social network, but
differs from Twitter in various useful ways, two of which are the following:

  - It is not funded by advertising, so the interests of server owners
    are better aligned with those of users; and

  - Anyone can run a Mastodon server, and they federate their notifications
    via a protocol [ActivityPub][].

This addresses two of the biggest problems with Twitter—that it is a single
silo that owns all our data, and that its dependence on advertising revenue
requires them to make the service incrementally worse over time. (Other
federated social networks are available.)

How to incorporate Mastodon syndication? We could do one of three things:

  - Replicate the Tweet This button as a Toot This button (the federated nature of Mastodon might complicate this);
  - Link to or embed a post on Mastodon that syndicates this article; or
  - Make the server (or the blog) be an ActivityPub actor in its own right.

The last of these will require more research. Embedding a Mastodon post is fairly
straightforward.


# Approach

There is a bijou standardette called [rel-syndication][] that says how to link
from an article to the syndicated versions of that article.

My articles have headers in the style of [RFC 5322][] (current successor to
RFC 822), so I could add  `Link` headers from [RFC 8288][] as follows:

    Link: <https://octodon.social/@pdc/100601703924310915>; rel=syndication

and then expose these links in the generated HTML as something like this:

    <a href="https://octodon.social/@pdc/100601703924310915"
        rel="syndication" class="u-syndication link-mastodon">On Mastodon</a>

The `rel` attribute tells automatic processors that this links from the
canonical page of an article to to a syndicated version; the `u-syndication`
class is used as part of the `h-entry` convention. The `link-mastodon`
class would be used to style the link appropriately.
A link to a Twitter tweet would work the same way.

Rather than just linking to the syndication post (tweet or toot), I could embed it.
I was just thinking about this when I discovered that
Simon Willison [does this on his blog][1]. This has the advantage that the embedded tweet includes
some numbers representing feedback ‘for free’,
and it is reasonably obvious that that is where you go to interact with the article.

For Mastodon posts, making this happen is a simple case of adding some JavaScript at the end of the page:

    <script>
        document.querySelectorAll('.link-mastodon').forEach(k => {
            const url = k.getAttribute('href');
            const iframe = document.createElement('iframe');
            iframe.setAttribute('src', url + '/embed');
            iframe.setAttribute('class', 'mastodon-embed');
            iframe.setAttribute('width', '400');
            k.parentNode.appendChild(iframe);

            const script = document.createElement('script');
            script.setAttribute('src', 'https://octodon.social/embed.js');
            script.setAttribute('async', 'async');
            k.parentNode.appendChild(script);

            k.parentNode.removeChild(k);
        });
    </script>

This converts the link in to the 2 elements that Mastodon generates as the
embedded version of a toot. By having the link in the HTML and converting it to
the embed version we allow for graceful degradation of the page if JavaScript
is not available, and retain support for the rel-syndication protocol.

This works fine, but after I implemented it I found
I didn’t like the way the embedded fragment was formatted differently from the
rest of my page. It looks like a foreign insertion—because it is—and in the end
I may stick to just the simple link.


# The Magical Future: IndieWeb Webactions

There is an alternative to embedding a Twitter post: you can generate links on
your page that go to Twitter forms for retweeting, linking, and replying to
the tweet. These can be just links, or you can use a JavaScript incantation
supplied by Twitter to make automatically styled like Twitter buttons. This is
in some ways neater than expecting people to click through to a tweet first.
The downside is that it does not make sense to do such a page for each of more
than one social network.

There is an IndieWeb contrivance called [webactions][] aimed at solving this
but it is a bit involved. It works roughly like this:

* Alice has a blog and is hep to webactions and has told her browser a URL
  pattern for the forms she wants to use to post, repost, like, or reply to
  posts;

* Bob has a blog and entries end with    links to the Twitter forms for like,
  repost (retweet), and reply, invisibly annotated with information about which
  is which; and

* Bob’s sites includes the Webaction JavaScript code, which finds
  Alice’s settings are replaces the Twitter buttons with ones linking
  to Alice’s special URLs.

If this does not seem complicated enough, wait until you find out the
indirection Alice needs to use to set up her webaction handlers.


# For Now

I plan to add syndication links for new articles and see how it goes—but to
leave the existing Tweet button until I come up with something better.



  [1]: https://simonwillison.net/2018/Aug/25/restructuredtext/
  [ActivityPub]: https://www.w3.org/TR/activitypub/
  [Mastodon]: https://joinmastodon.org
  [RFC 5322]: https://datatracker.ietf.org/doc/rfc5322/
  [RFC 8288]: https://datatracker.ietf.org/doc/rfc8288/
  [rel-syndication]: http://microformats.org/wiki/rel-syndication
  [webactions]: https://indieweb.org/webactions
