Title: Let’s Try Gunicorn Instead
Date: 2018-07-08
Topics: meta gunicorn django

I have switched to Gunicorn since my attempts to make uWSGI multilingual have failed disastrously.

Part 3 of the [Running to Stand Still][todo] series.


# Background

[WSGI][] is the protocol used to plug web applications written in the Python
programming language in to production web servers such as NGINX. Generally
they themselves behave as web servers, receiving requests as HTTP and calling
a Python callable supplied by your web framework. Some use a protocol such as
FastCGI or uwsgi that is less flexible but hopefully faster to parse than HTTP
and are connected to via an appropriate plugin in the main server.


## uWSGI

I have a single Linix server running several little web sites.
I use [NGINX][] as the web server. It handles static files, and  delegates to [uWSGI][] for the Python
apps, described in [this entry form 2012][1]. It turns out that my uWSGI server is bound
inextricably to Python&nbsp;2. Since I will need to port my apps to newer
Django versions and hence to Python&nbsp;3, I need an alternative solution.

I tried upgrading  uWSGI to a version with pluggable language versions. Unfortunately this
failed—the NGINX log just says the connection is broken. This   resulted
in all the other sites I host being broken as well as my blog. Rather than going
deeper in to the rabbit-hole of debugging uWSGI I  rolled back to the old
version and old configuration so as to get my older sites working again.

Now I needed a
Python-3-supporting solution to run alongside it.


## Gunicorn

Gunicorn is another WSGI server. It is the one recommended by Heroku, who know
a thing or two about hosting Django apps, so I decided I would see if I could
get it to serve my very simple Django-based blog.


# Installing

So far as I can tell the convention is to run a separate Gunicorn per site,
rather than have a multiplexer like the uWSGI Emperor. That’s fine by me.

Rather than using the system package for Gunicorn (which is likely to be out
of date since I am using an oldish Ubuntu LTS distribution), I installed it
direct in the virutalenv of the site. Since the virtualenv is named after the
site, you run Gunicorn as `/home/alleged/virtualenvs/alleged/bin/gunicorn`.
This obviates the issue which started all this, which was a mismatch between
Python versions.


# Testing

Since Gunicorn uses HTTP rather than a custom protocol, you can test it with a
conventional web-downloading command like `wget`. Something along the
following lines runs the sever:

    gunicorn --chdir Sites/alleged --bind 127.0.0.1:8001 alleged.wsgi

I could then test it with `wget http://localhost:8001/pdc/`.

I discovered I had been running with the wrong `ALLOWED_HOSTS` setting all
these years: it needs to list just the host name `localhost`, not host+port
`localhost:8001`. Whoops. This hadn’t been a problem before because it is
ignored in debug mode (so was not a problem during development) and the real
site has `Host` set to `alleged.org.uk`.


# Deployment

I use D. J. Bernstein’s [daemontools][] package to run my servers. I like it
because it is so simple: you set up a directory with a script that runs the
server and the `supervise` daemon takes care of running and monitoring it.

The script looks something like this:

    #!/bin/sh

    exec 2>&1
    echo Starting $SITE-gunicorn

    SITE=alleged
    SITE_HOME=/home/$SITE

    exec envdir env \
        $SITE_HOME/virtualenvs/$SITE/bin/gunicorn \
            --name $SITE-gunicorn \
            --pid /var/run/gunicorn/$SITE.pid \
            --user $SITE \
            --group gunicorn \
            --chdir $SITE_HOME/Sites/$SITE \
            --bind 127.0.0.1:8001 \
            --access-logfile /var/log/gunicorn/$SITE-access.log \
            --error-logfile /var/log/gunicorn/$SITE-error.log \
            --reload \
            $SITE.wsgi

The [environment][prev] of the process is controlled by a directory `/service/alleged/env`
(one file per environment variable).

At this point I could check the server was running with `wget
http://localhost:8001` as before. All good!

The last step was plumbing it in to NGINX. This was just a case of replacing
the URL in the `proxy_pass` directive in `alleged.conf` as follows:

    location @django {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://localhost:8001;
    }

And then after `nginx -s reload`, lo! my website was restored after many days
of being a broken 502 page.

Finally I am back to square one, and ready to update my site …


  [todo]: 06/17.html
  [1]: ../2012/11/03.html
  [prev]: 07/07.html
  [WSGI]: https://www.python.org/dev/peps/pep-0333/
  [NGINX]: http://nginx.org
  [uWSGI]: https://uwsgi-docs.readthedocs.io/en/latest/
  [daemontools]: https://cr.yp.to/daemontools.html
