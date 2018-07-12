Title: Store Config in the Environment
Date: 2018-07-08
Topics: meta django python

My web site settings file is broken so I might as well fix a few things.

My website is not interactive so I have disregarded the rule that you
shouldn’t put production settings in the source-code control system. I did this because
it simplified my deployment system (described in [an earlier entry][1]). Since
it is currently broken anyway I might as well take the effort to move it a
little closer to best practices.

Part 2 of the [Running to Stand Still][todo] series.


# Config in the Environment

The [Twelve-Factor App][12] describes ways to ensure your a web app is
deployable, scalable and maintainable. One factor is that you [store config in
the environment][3], rather than in files. For example, an environment
variable `DATABASE_URL` specifies the connection settings for your database.

Where the environment variables come from depends on your hosting environment.
They might be an env dir or some special database or parameters in a
Dockerfile or Kubernetes chart or whatever.


# Django Settings

With a Django app the settings are provided as a Python module.
The obvious approach to making this get the salient information from environment variables
is to make liberal
use of `os.environ.get` in the settings file.
For example

    DEBUG = os.environ.get('DEBUG')

When representing a boolean condition with environment variables I prefer to
use an empty or absent value to represent false and a non-empty value to
represent true.

With this convention it is best if false represents a default, safe, option:
No access to real databases without the `DATABASE_URL` environment variable,
and so on.  If we can contrive to make the defaults suitable for running a
staging copy of the site then this will make  it easy to get set up as a
developer (more of a consideratuion when you have more than one developer).

There are packges like `dj-database-url` that have routines for decoding
`DATABASE_URL` in to the settings Django uses.


# Django-environ

A more convenient solution is a third-party library `django-environ`. This
wraps up a bunch of conveniences for getting settings from the environment in
one easy lump. It can read from a local `.env` file to make development
straightforward, and knows how to decode database URLs.

Compared to my previous setup, this means replacing the sample settings and
production settings files with a proper settings file starting with something
like this:

    import environ

    env = environ.Env(
        DEBUG=(bool, False),
        STATIC_ROOT=(str, None),
        STATIC_URL=(str, None),
    )
    environ.Env.read_env()

    DEBUG = env('DEBUG')
    …

    if env('STATIC_ROOT'):
        STATIC_URL = env('STATIC_URL', default='http://static.alleged.org.uk/')
        STATIC_ROOT = env('STATIC_ROOT')  # e.g., '/home/alleged/static')
    else:
        STATIC_URL = '/s/'

A less trivial web site would have more settings—such as for databases and
caches—but this is still useful even for my tiny site.

For the most part I have arranged it so when safe enough the default is
developer mode. The exception is `DEBUG`, so on my working copy I needed to do
something like this:

    echo DEBUG=y >> alleged/.env

I also needed to make arrangements for the `SECRET_KEY` setting. Normally it is
important that `SECRET_KEY` be unique and secert, but since my siute does not
use user sessions I don’t actually use it.  I have set it so if you are in
`DEBUG` mode it uses a dummy value, and if not it treats `SECRET_KEY` as a
required parameter, and aborts the server if it does not find it in its
environment.


# Lessons

It is easier than ever to avoid checking database settings and keys in to
source-code control. So don’t do that.


  [todo]: 06/17.html
  [1]: ../2012/11/03.html
  [12]: https://12factor.net
  [3]: https://12factor.net/config
  [4]: https://devcenter.heroku.com/articles/config-vars
  [5]: http://django-environ.readthedocs.io/en/latest/
