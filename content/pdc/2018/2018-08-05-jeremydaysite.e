Title: Updating jeremyday.uk
Date: 2018-08-05
Topics: jeremyday meta pipenv twitter

I build a web site for Jeremy Day and I have now spent several hours updating it to the latest Django and Python versions.


Part 8 of the [Running to Stand Still][todo] series.

# Git and Gittability

The computer I used to develop the site is currently broken but my deployment
system uses a Git repo so I was able to exploit that as follows:

  * As [pdc on GitHub][], set up an empty project, and
    and create a Personal Access Token to use as the password in the next step (because I use <abbr title="two-factor authentication">2FA</abbr>)
  * As `jeremyday` on the server, `git add remote github https://github.com/pdc/jeremydaysite.git`
    and `git push github --all`, using the Personal Access Token when prompted for password
  * As myself on my home system, `git clone git@github.com:pdc/jeremydaysite.git`

The main gotcha is the bit where it asks for a password and actually wants a Personal Access Token.


# Pipenv

This site predates my use of Piptools! So it has `requirements.txt` but no
`requirements.in` or similar. So I elected to switch to [Pipenv][] (this being
the current new thing in 2018). The existing Django version is 1.6.5 which
supports only Python &le; 3.3 so I had to stick with Python 2.7 for now.

    pipenv --two  # This creates Pipfile from requirements.txt
    pipenv install


# Settings

The next thing to try is

    pipenv run python -Wall manage.py test

This failed because I don’t have a settings file, in turn
because in 2009 my approach was to have separate `settings.py`
files for developer and production mode.

So my next step was to repeat the process of changing to
[store config in the environment][].

Once this was fixed up the problem was it could not load `spreadsite.spreadlinks`.


# Spreadlinks 0.3

In 2009 I created a ha-ha-only-serious  site [Spreadsite][] with a library for
serving pages of links using a spreadsheet to organize them. When I build
Jeremy’s site I used this to create the page of links to her projects.

So I had some code I wanted to use in two projects. The sensible approach is
to avoid duplicated code by pulling the shared code in to its own reusable
package. Back in 2009 the state of package management in Python was a
bewildering inchoate mess with impossibly complicated-looking packages that
were all simultaneously successors to each other—so I decided to instead share
the code as a Git submodule. Given how notoriously painful Git submodules are
you can get an idea of how off-putting the packaging solution looked at the
time.

So I figured that since I was breaking everything anyway
I would have another go at pulling the library out in to its
own package that can be installed. There is now a Python Packaging Sorting Out
Committee trying to get things organized, but it is still quite fiddly to
get right. In the end I discovered a recipe on the Django website that worked.

I was able to test this locally by deleting all the `spreadlinks` code from
the `spreadsite` project and using this command to link in the nascent
library package:

    pipenv install --dev -e ../spreadlinks

I had to run the tests via the main app and then update either the library or
the main file depending on where the tests failed. Once the library was
probably OK I published to PyPI using the following easy-to-forget
incantation:

    rm -rf dist Spreadlinks.egg-info/SOURCES.txt &&
      pipenv run python setup.py sdist bdist_wheel &&
      pipenv run twine upload dist/*

I am reminded that the equivalent command in the world of Node is much more succinct:

    npm publish

Anyway, after some faff I have  a tiny [Spreadlinks package][] on PyPI that
still needs some work but can be used to get the code to my server.


# Upgrading to Django 1.11

I had to iterate through several Django versions, each of which might break
either the main project  or the app library.

One gotcha was the message

    RemovedInDjango110Warning: The context_instance argument of render_to_string is deprecated.

I searched in vain for `render_to_string` but eventually worked out it was my
use of `render_to_response` that was at issue. This was fine because all I
needed to do was change

    return render_to_response(template_name or default_template_name, result, RequestContext(request))

to the more modern equivalent:

    return render(request, template_name or default_template_name, result)

In similar fashion, I also found there was a place where I was calling `Template.render` with a
`Context` object whereas it wants a plain dictionary nowadays.


# Python 3

Once I had reached Django&nbsp;1.11 it was time to switch Python versions.
This was basically running `2to3` on the main app, backing out some of the
less useful changes, and then seen what was still broken.

If you run recent Python & Django versions with `-Wall` you get messages about
unclosed file descriptors. It turns out this ancient code base of mine still
had examples of the old  shorthand

    text = open(file_path, 'r').read()

Which needed to be changed to

    with open(file_path, 'r') as input:
        text = input.read()

I also dropped my attempts to pool `httplib2` instances—probably useless
anyway, and the cause of warnings about resource leaks.


# BeautifulSoup 4

Next I had to wean the LiveJournal embedder off of BeautifulSoup&nbsp;3.2.1.

In 2010 I used [BeautifulSoup][] to parse [Jeremy’s LiveJournal front page][1]
for articles (the Atom feeds being too abbreviated to be useful). It turns out BeautifulSoup&nbsp;3._x_
was based on an SGML parser that was deprecated and dropped in Python&nbsp;3,
but that’s OK because its successor BeautifulSoup&nbsp;4 allows for pluggable
HTML parsers, of which HTML-5-savvy `html5lib` is one. In fact it’s better
because it cleaves closely to how browsers parse HTML these days.

I discovered that tweaks to LiveJournal’s formatting in the last almost-decade
meant I needed to tweak some of the selectors. Switching to CSS selectors
addressed most of the issues though, so it worked out nicely in the end.


# Deployment

By the time I had got the site working again on my MacBook I was ready to
deploy but that entails updating the server to serve it with Gunicorn.  It
was getting late in the evening. Did I want to spend half the night faffing
about setting up the server and getting stressed out when some omitted
environment variable causes the whole thing to fail?

What I did instead was spend the evening [documenting the commands for
deploying the Gunicorn server][2] as if I had already done it—the sort of blog
entry my future self will be copying commands out of to deploy another site.
Tidying up the narrative gave me a chance to  optimize the procedure. It helped
that I had already done most of it to get [spreadsite.org][] working. Then in
the morning I followed the instructions in the article and at the end of the
recipe the site worked first time!


# Updating Links

There was one or two small snags. First, LiveJournal was missing because it
was failing to load jQuery because I still had an HTTP URL in the template for
the page. Since the sigte runs on HTTPS now,  included resources must be as
well.

This site largely exists to preserve content originally written for Geocities
or whatever a couple of decades ago, and some of the URLs need updating. In
some cases this is because a resource has moved.

Mostly tthis consisted of looking for links in the templates and HTML files
and when they had been fixed running `fab deploy` to publish the site again.
Annoyingly I still have to manually bounce the server to get it to recache its
templates.


# Twitter API Withdrawl

Second, the Twitter box on the front page also didn’t work. The requests were getting a
410 Gone response which, apart from reminding me of Mark Pilgrim’s
disappearance almost seven years ago now, suggested the API was no longer
supported. And indeed there is now a replacement search endpoint, which
differs mainly in that it requires OAuth2 authentication to work.

For the sake of getting things fixed quickly I went for the less ambitious
option of  embedding Twitter’s own time-line widget on the page instead of
getting mine to work again. This has the downside that it effectively hands
over the design of a chunk of the page to Twitter, effectively embedding a
free advertisement for their site. The upside is Twitter have to make it work,
not me.

The minimum width of the Twitter widget is 220&thinsp;px. I rejigged the style
sheet for the page so it makes the appearances and main columns wider when
there is sufficient space on the page. So much easier with flex-box than it was
with columns made from floats!


# Lessons

Delegating most of the content-management of the site to LiveJournal and
Twitter has mostly worked over the last almost-decade  without much
intervention from me. The discontinuing of the Twitter API is the exception
that reminds us that the trade-off is that ultimately Jeremy’s posts and notes
on Twitter are not stored on servers under her control and could be lost.



  [pdc on GitHub]: https://github.com/pdc
  [Store Config in the Environment]: 07/07.html
  [Pipenv]: https://docs.pipenv.org
  [BeautifulSoup]: https://www.crummy.com/software/BeautifulSoup/bs4/doc/
  [1]: https://cleanskies.livejournal.com
  [Spreadsite]: https://spreadsite.org/
  [spreadsite.org]: https://spreadsite.org/
  [Spreadlinks package]: https://pypi.org/project/Spreadlinks/
  [POSSE]: https://indieweb.org/POSSE
  [PESOS]: https://indieweb.org/PESOS

  [todo]: 06/17.html
  [2]: 08/04.html
