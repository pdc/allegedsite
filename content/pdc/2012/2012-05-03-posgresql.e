Title: Running on PostgreSQL on Ubuntu
Date: 2012-05-03
Topics: deployment django postgresql

I have discovered that whenever the name MySQL is mentioned, someone will make
a choking gurgling noise and complain that it isn’t [PostgreSQL][1]. Now that
MySQL has been consumed by Sun, which has in turn been consumed iby Oracle, I
thought I would see how hard it is to switch.

The main difference between the two seems to be that MySQL started out as an
SQL interpreter to which a reliable database backend was eventually attached,
whereas PostgreSQL started as a database backend (Postgres) with a  SQL
interpreter laminated on top. I have a certain sympathy for the idea that you
should optimize your database for correctness  and reliability before anything
else, so maybe that is whether the ‘MySQL—ack! ptht!’ attitude comes from. (For a longer discussion, see [MySQL vs PostgreSQL][3])

## Installation

The server is installed much as you would expect. On Ubuntu 10.04 LTS, I used:

    sudo aptitude install postgresql-8.4

If you are more up-to-date you will have 12.04 and use PostgreSQL 9.1.

The only real gotcha with installing it is the peculiar names given to the
supporting packages. For my purposes I need the Python driver and the server.
The Python adapter is not called `postgresql` or
anything sensible like that but `psycopg2`. It is a wrapper around the PostgreSQL library,
which naturally is not called `libpostgresql`, but  `libpq`.
The upshot of which is you have to do the following commands:

    sudo aptitude install libpq-dev
    pip install psycopg2

My moaning about the names aside, this seems to be a pretty good example of a
DP-API 2 wrapper, and is Unicode-, Python-3-, and thread-safe.

## Exploitation

Since my immediate application, the [CAPTION][2] web site, is a Django app,
there is actually very little difference to deploying with PostgreSQL, apart
from the difficulty I have in typing its name.

For the development version of the site I use SQLite, with a clause in
`caption/settings.py` along the lines of

    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': 'dev.db',
        },
    )

PostgreSQL has a nifty convention whereby if you create a user entry with the
same name as a Unix user account, the two are identified—and if there is a
same-named database, it is the default for that user. This means, since all my
web apps run with unique user names, I do not need to have database passwords
embedded in the settings file. These commands set up the database:

    sudo -u postgres createuser caption
    sudo -u postgres createdb caption

The settings file entry now looks like this:

    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'HOST': '', # Using Unix domain socket
            'NAME': 'caption',
        },
    )

In the case of the CAPTION site, the intitial set of articles was already dumped as the intial data for the database as follows:

    ./manage.py dumpdata --indent 4 --format yaml articles \
            > articles/fixtures/initial_data.yaml

This meant all I had to get the database populated was run `./manage.py syncdb`.

All in all it seems to have gone smoothly—which is as it should be, given that
all I am using it for is as an object storagefor Django, the simplest possible
case. The resilience of PostgreSQL is likely to be more important for a
hypothetical heavily loaded future Kanbo.

  [1]: http://www.postgresql.org/
  [2]: http://caption.org/
  [3]: http://www.wikivs.com/wiki/MySQL_vs_PostgreSQL