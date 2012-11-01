Title: Atom Feed, my RSS!
Image: ../icon-64x64.png
Date: 2010-03-07
Topics: atom python django

Work on [jeremyday.org.uk][1], the replacement for [www.jeremydennis.co.uk][2] continues apace. I’ve used [spreadsite][5] to create a projects list (which needs updating), created a new version of the [The Weekly Strip][4] archive, and had a long talk to [Jamie Lokier][3] about how caching *should* work on GNU/Linux systems and the WWW in general. Also I have created a new Atom feed for TWS.

Start
=====

Atom is one of the formats used for web-site feeds—often referred to as RSS, the name of [some of the other formats][6]. It is an XML application, specified in [RFC 4287][], with additional elements for linking feed documents defined in [RFC 5005][]. 
With Django is is as easy to generate XML as it is HTML, so my first thought was to just create my own feed template and view function. How hard can it be?

My second though was to see whether the [Django syndication framework would be better][7], on the grounds that it makes sense to let third-party modules take the strain sometimes. After a little while looking at creating a `Feed` subclass and realizing I could not see any support for archive links, I decided to switch back to creating my own template.

Paged Versus Archive
====================

RFC 5005 defines the sorts of feed: *complete*, *paged*, and *archive*. Ignoring the complete options, paged feeds are about giving readers the latest updates, with a way to search back through older updates if they want, whereas archived feeds are about buying a complete and largely unchanging list of entries. In other words, paged feeds are for news readers (also called RSS readers, feed aggregators, etc.), whereas archive feeds allow a robot  access to incremental updates to a collection of data items that are known to add up to a complete and consistent list. 

There is a peculiarity of the Weekly Strip that some strips are back-dated, which means that if you list them by number you get a different sequence from that you get by listing them in date order.  A paged feed will need to be in reading order for consistency with the rest of the site; an archived feed needs to be stable (apart from the last page), so will need to be in accession-number order.

My plan is to build both: first a paged feed for people who want to track the latest additions, and, later, an archive feed linking to  machine-readable metadata about the strips, for the sake of repositories like [Subj3ct][]. 

Process
=======

The development process is textbook: first, add entries to the URLconf:

    urlpatterns = patterns('jeremyday.theweeklystrip.views',
        …
        (r'^feeds/in-reading-order\.atom$', 'reading_order_feed', {},
            'tws_reading_order_feed'),
        (r'^feeds/in-reading-order\.page(?P<page>[0-9]+)\.atom$',
            'reading_order_feed', {}, 'tws_reading_order_feed'),
        …
        )

Next create a view function:

    @render_with_template('jeremyday/tws.atom',
            mimetype='application/atom+xml') 
    def reading_order_feed(request, page=None):
        strips = twslib.get_tws(settings.TWS_FILE, settings.TWS_SRC_PREFIX)
        …

Finally create a template `jeremyday/tws.atom`, with the appropriate XML:

    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
        <title>{{ title }}{% ifnotequal page 1 %}, page {{ page }}{% endifnotequal %}</title>
        <id>{{ id }}</id>
    
        <link href="{{ home }}"/>
        <link rel="self" href="{{ self }}"/>
        <link rel="first" href="{{ first }}"/>
        …
        {% for strip in strips %}
        <e n t r y>
            <title>{{ strip.number }}. {{ strip.title }}</title>
            <link href="{{ strip.page_href }}"/>
            <id>{{ strip.id }}</id>
            <published>{{ strip.date|date:"Y-m-d" }}T12:00:00Z</published>
            <updated>{{ strip.updated }}</updated>
            <summary type="xhtml">
                <div xmlns="http://www.w3.org/1999/xhtml">
                    …
                </div>
            </summary>
        </entry>
        {% endfor %}
    </feed>
        
Now you go back to the view function and fill in the requisite template variables. There are URLs for various links—in all there is `first`, `last`, `self`, `next`, and `prev` for the feed and the main link for the entries. Mostly these are obtained using the `reverse` function:

    first_href = reverse('tws_reading_order_feed') 
    last_href = reverse('tws_reading_order_feed', 
            kwargs={'page': str(max_page)})

Using `reverse` means I can change the scheme for URLs by editing `urls.py` and the links will automatically be correct.

URLs in the feed  can in principle be relative to the URL of the feed itself, but to reduce the opportunity for feed readers to read the feed wrongly, I expand them all with `request.build_absolute_uri`:

    tpl_args = {
        …
        'self': request.build_absolute_uri(self_href),
        'first': request.build_absolute_uri(first_href),
        'last': request.build_absolute_uri(last_href),
        …
    }

took me forever to find the name of that function. :-)

Date with Datetimes
===================

The other main gotcha was the updated times, a requirement of RFC 4287. These need to be in for format [RFC 3339][] (a profile of [ISO 8601][] that is not entirely dissimilar to [XML Schema dateTime][8] and the [W3C DTF][]). So I need the following format:

    2010-03-04T22:23:45+00:00

Note: date and time must be separated by a capital `T`, and the time offset must be included.

I thought at first to try Django’s `date` filter's format `c`, but (a) this is defined only for the forthcoming Django 1.2 and I ams till using Django 1.1, and (b) it generates `2008-01-02 10:30:00.000123`, which is conformant to ISO 8601 but not to RFC 3339.

I thought to try the `datetime` class’s `isoformat` method, but when I create a datetime from  a timestamp it has no time zone, and the `datetime` classes therefore do not include one in the output. I can’t just add `+00:00` unconditionally since this will be wrong during summer time. Creating a timezone object takes another twenty lines of code and by this time I was getting a little exasperated at how long it was taking to render the time in to ASCII.

So I ended up using `time.strftime`, with a format string `%Y-%m-%dT%H:%M:%S%z`. This looks about right:

    2010-03-04T22:23:45+0000

It was not until I had deployed the new code and tested it in the [feed validator][9] that I noticed that it omits the colon in the time zone. The upshot of which is that my code for rendering datetimes looks like

    updated = time.strftime('%Y-%m-%dT%H:%M:%S%z',
            time.localtime(mtime))
    updated = '%s:%s' % (updated[:−2], updated[−2:])

The other complication with dates is the philosophical question of what date to use for the `updated` value of a strip. I ended up settling on the using the modification date of the graphics file—which on my desktop is a fairly accurate record of when the strip was uploaded—even though for backdated strips this quite different from the publication date.

Testing
=======

Apart from the the [Feed Validator][9], I have tried it out in the feed readers of Safari 4, [Vienna 2.4][12], and [Google Reader][10]. All of them display the icon images and you can click on the image to show the strip. Safari and Google respect the order of the entries in the feed—which is reverse publication order—whereas Vienna sorts by the `updated` field, which undoes the back-dating of some strips. But never mind.

Future
======

Once I have created a [linked-data][11] representation of the strips—not that there is much data to add—I plan to create an archive feed as well (ordered by accession number rather than by (purported) publication date). 


  [1]: http://jeremyday.org.uk/
  [2]: http://www.jeremydennis.co.uk/
  [3]: http://www.shareable.org/
  [4]: http://jeremyday.org.uk/tws/
  [5]: http://spreadsite.org/
  [6]: http://diveintomark.org/archives/2004/02/04/incompatible-rss
  [7]: http://docs.djangoproject.com/en/1.1/ref/contrib/syndication/
  [8]: http://www.w3.org/TR/xmlschema-2/#dateTime
  [9]: http://beta.feedvalidator.org/check.cgi?url=http://jeremyday.org.uk/tws/feeds/in-reading-order.atom
  [10]: http://www.google.com/reader
  [11]: http://linkeddata.org/
  [RFC 3339]: http://tools.ietf.org/html/rfc3339
  [RFC 4287]: http://atompub.org/rfc4287.html
  [RFC 5005]: http://tools.ietf.org/html/rfc5005
  [ISO 8601]: http://www.cl.cam.ac.uk/~mgk25/iso-time.html
  [W3C DTF]: http://www.w3.org/TR/NOTE-datetime
  [subj3ct]: http://subj3ct.com/
  [12]: http://www.vienna-rss.org/