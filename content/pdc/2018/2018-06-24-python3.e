Title: Porting my Blog to Python 3
Topics: meta python python3 fabric
Date: 2018-06-23


My last Mac OS update replaced Python, which as usual broke the virtualenvs I
use and when building a new virtualenv it seemed like as good a time as any to
upgrade to Python&nbsp;3 and Django 2.0. This lead to a lot of ‘adventures’
as I discovered how well Python&nbsp;3 is or isn’t supported in my setup.

Part 1 of the [Running to Stand Still][todo] series.


## Porting

This mostly involved running `2to3` then changing back all the mistaken
changes, such as unwrapping the occasional needless `list(...)` applied to iterators that were used in iteration,
and renaming any attribute named `next` wrongly renamed to `__next__`.

I experimented with using Pipenv for this but switched back to Pip-Tools
because my server looks for `requirements.txt` file and I don’t want to change
that just yet.


## PyPy3

Just to be thorough I created a PyPy3 virtualenv as well. This flushed out
two things. First, it implements Python&nbsp;3.5’s library rather than 3.6, so a
couple of places needed `decode` or `encode` calls added where 3.6 does
implicit conversions.

Second, I ended up replacing `lxml.etree` with `xml.etree.ElementTree`. The
documentation claims that the latter will use fast modules if available, so I
assume it incorporates the equivalent of `lxml`, and this frees me from trying
to get `lxml` to build for PyPy.


## On the server

On the server it was easy enough to download the latest Python source and do
`./configure` and `make` to build it and install in `/usr/local/bin`.
(Hopefully system utilities using Python will carry on working with the
`/usr/bin` version.)

I was able to update Pip to version 10 (from something ridiculous like version 1.4)
and hence upgrade to new version of virtualenv.

Switching to the `alleged` user (the account that owns the alleged website’s
files on the server) I created a new Python-3 env.


## Fabric

I had to reinstall Fabric because it is stuck on Python&nbsp;2.

[Fabric][] is a command invoker tool I use to deploy my site to the server: it has
conventions for running shell commands either remotely or locally and dealing
with the results. I had been using it from a copy installed in teh same
virtualenv as the rest of the blog software.

Unfortunately the 1._x_ version of Fabric cannot run on a Python&nbsp;3
system: it hasn’t been ported. Instead Fabric&nbsp;2, a ground-up rewrite
will support Python&nbsp;3. But alas! the new Fabric, while having a cleaner
architecture and so on, does not run Fabric&nbsp;1 scripts,
and porting them is not trivial and possibly not yet possible, depending on
whether the features you use have been reimplemented yet.

The fix (for now) has been to install Fabric globally, instead of using one in
the  virtualenv I use for the site.


## uWSGI

The next show-stopper was a surprise: uWSGI, despite having virtualenv-savvy
features, does not actually use the virtualenv. As a result, uWSGI compiled
for Python&nbsp;2 cannot run servers that run in Python&nbsp;3: the log
fills up with nonsensical import errors.

The solution is a story for another time.


  [todo]: 06/17.html
  [1]: ../2012/11/03.html
  [project wonderful]: https://www.projectwonderful.com/thanks.php
  [Fabric]: http://www.fabfile.org
