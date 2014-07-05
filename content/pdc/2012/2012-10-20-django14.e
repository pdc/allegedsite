Title: Sibling Layout for Django 1.4 Projects
Date: 2012-10-20
Topics: django

Django 1.4 introduces two big changes that require thinking about: (1) support
for time zones, (2) removing some magic about where app modules go on disk. This is as good a time as any to update the
layout of my Django projects.

I wrote these notes for my own reference when rearranging some of my existing
sites. This is just one possible prohect layout. It is mostly convenient when
your apps are expected to be one-offs: it has the benefit of a shallower
directory structure.

Less-magical Path Entails New Layout
===================================

In 1.3, your project was in a directory `alleged`, which is the current
working directory while you are working on the site.

<div class="image-right">
    <img src="django-13-layout.png" width="296" alt="(diagram)" />
</div>

But in `settngs.py` the
app in the subdirectory  `blog`  is imported as `alleged.blog`, so some path
mungery is required to add the parent directory of the directory with
`settings.py` to your path. In 1.4 this bit of magic goes away.



Amongst other things this means [a new `manage.py` file][5].

For tidiness (following [the suggestion on the Django site][1]; I am not sure
it is required as such) you can create a new subdirectory for the site files
themselves.

    mkdir allegedsite
    git mv settings-sample.py urls.py allegedsite
    mv settings.py allegedsite
    git mv urls.py allegedsite
    touch allegedsite/__init__.py

In `settings.py`, remove `alleged.` from the names of apps, so they are all
relative to the project directory. Where we had the following:

    INSTALLED_APPS = (
        …

        'alleged.snaptioner',
        'alleged.blog',
    )

we now have this:

    INSTALLED_APPS = (
        …

        'snaptioner',
        'blog',
    )

Another thing to check is use of tricks like the following:

    def expand_path(partial_path):
        return os.path.join(os.path.dirname(__file__), partial_path)
    …
    SNAPTIONER_LIBRARY_DIR = expand_path('albums')

Either move these directories in to the site directory or edit these settings to add a `../`.

Because the site files are now in `allegedsite`, you also need to change this line in `settings.py` from this:

    ROOT_URLCONF = 'alleged.urls'

to this:

    ROOT_URLCONF = 'allegedsite.urls'

Similarly in several of the Python files we need to change  things like this import line:

    from alleged.fromatom import get_flickr, get_livejournal, get_youtube

To this:

    from blog.fromatom import get_flickr, get_livejournal, get_youtube

Static Files
============

The [staticfiles app][4]  removes the need for a lot of hackery and custom code in Django apps. To use it we must do some simple steps:

First, In `settings.py`, add `django.contrib.staticfiles` to `INSTALLED_APPS`.

Second, create `static` subdirectories in apps and move static  content in to the appropriate apps. For example:

    mkdir blog/static
    git mv static/js/ blog/static/

Third, replace whatever tag was used to generate the static directory with a call to the `static` tag. For example, changing

    <script src="{{ settings.STATIC_URL }js/snaptioner.js" %}"
            type="text/javascript"></script>

with this:

    <script src="{% static "js/snaptioner.js" %}" type="text/javascript"></script>

Each affected template will also need the line

    {% load staticfiles %}

added near the top.

By default this just prefixes the URL reference with the `STATIC_URL` value, but a fancier static-files handler might do something more complex with it.

Fourth, set up the directory static files are copied to. In my old setup I
exploited the old Mac OS X convention with static sites in `~/Sites`: by
creating a symbollic link linking `~/Sites/alleged` to
`~/Projects/alleged/static` I got the built-in Apache server to serve the
projects copy of the static files. Now I have deleted the symlink and replaced
it with a directory, and edited `settings.py` to add

    STATIC_ROOT = '/Users/pdc/Sites/alleged'

Now running

    ./manage.py collectstatic --noinput

Copies the static files to the static server.

For the development settings, a simpler alternative would be to remove the
static server altogether and leave `STATIC_ROOT` and `STATIC_URL`  out of
`settings.py`. The development server will then take charge of serving the
static files itself.


TEMPLATE_CONTEXT_PROCESSORS Setting
====

If we have added  context processors then this setting  needs updating because
(1) there is a new processor for handling time zones, and (2) the `auth`
processor has changed its module name. [The new defaults are described on the
settings page][3].

In most cases with my sites the only non-standard context processor I had was
one to  pass the static-files URL in to templates; this is no longer needed
because of the static files support, which means it is possible to delete the
setting altogether and use the default.

Timezone Support
================

I don‘t actually have much to add beyond the [Support for time zones
section][6] of the release notes, except that I discovered that time zones and
PyPy do not mix – at least PyPy 1.8 had a bug that manifested when trying to
run tests involving timezone-savvy dates.

WSGI Support
============

This allows easier deployment on WSGI-savvy web servers (such as [Nginx+uWSGI][7] or [Gunicorn][8]). To use it you need to add the file that would have been added by the `django startproject` command as described on the [WSGI deployment page][2].

  [1]: https://docs.djangoproject.com/en/dev/releases/1.4/#updated-default-project-layout-and-manage-py
  [2]: https://docs.djangoproject.com/en/dev/howto/deployment/wsgi/
  [3]: https://docs.djangoproject.com/en/1.4/ref/settings/#template-context-processors
  [4]: https://docs.djangoproject.com/en/dev/ref/contrib/staticfiles/#module-django.contrib.staticfiles
  [5]: https://docs.djangoproject.com/en/dev/releases/1.4/#updated-default-project-layout-and-manage-py
  [6]: https://docs.djangoproject.com/en/dev/releases/1.4/#support-for-time-zones
  [7]: /pdc/2012/11/03.html
  [8]: http://gunicorn.org/