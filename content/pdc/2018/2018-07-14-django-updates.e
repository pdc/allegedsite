Topic: django meta
Title: Django Updates
Date: 2018-07-14

Now I have upgraded to Python-3, porting my site to Django 2.0 was pretty straightforward.

Part 4 of the [Running to Stand Still][todo] series.


# Upgrading

The Django website has [recommendations for how to upgrade][1] which
boil down to

* Do it one release at a time (1.9 &rarr; 1.10 &rarr; 1.11 &rarr; 2.0)
* Use the latest point release of each minor release.
* Make liberal use of the `-Wall` option to `python` to check for deprecated features.

At first I used commands like

    python -Wall ./manage.py test

to check for deprecated features, such as the change from the
`MIDDLEWARE_CLASSES` setting to `MIDDLEWARE`, fixed these, and repeated.

I am using [Pip-tools][] to maintain my `requirements.txt` file. To upgrade to the
latest Django&nbsp;1.10.x one way is to update `requirements.in` to have  like
`django<1.11` and run commands like the following:

    pip-compile --upgrade requirements.in
    pip install -r requirements.txt

If you are using [Pipenv][] instead then you will do something similar but
probably with a single much more stylish command.

And then repeat the testing cycle.


# Main Gotcha

With the benefit of hindsight it would have been better if my test cycle had included running the server:

    python -Wall ./manage.py runserver 8001

There were some template changes that did get covered by the tests but
caused a deprecation warning when rendering a page for real.


# Lessons

This went smoother than previous upgrades, partly I guess because Django is
converging on perfection and partly because the deprecation mechanism built in
to recent Python verisons makes it easier for them to guide me though the
process.  (Also this is not a very complicated site.)


  [todo]: 06/17.html
  [1]: https://docs.djangoproject.com/en/2.0/howto/upgrade-version/
  [Pipenv]: https://docs.pipenv.org
  [pip-tools]: https://github.com/jazzband/pip-tools
