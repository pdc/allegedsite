Title: Deploying Django with Nginx + FastCGI
Date: 2010-04-11
Icon: ../icon-64x64.png
Topics: django nginx fastcgi flup deployment

I said in [an earlier article][1] I would outline my Django deployment
recipe. This is largely derived from a recipe for [Deploying A Django
Site Using FastCGI][2] in the Django Advent site.

I will carry on using <http://jeremyday.org.uk/> in my examples.

The basic approach is to have an Nginx front-end with an instance of
Django for each site:

<div>
<img src="nginx-django.png" alt="(diagram)" />
</div>

Static files—such as style sheets and images—are served direct from
disk. Django only handles dynamic pages.

You will remember that we have already created an account for the web
site and copied the files there using Git. Now the continuation …

Virtualenv
==========

[Virtualenv][] is a semi-kludgy way to make an isolated Python
environment, important when you want to host several sites on one
server:

    $ mkdir ~/virtualenvs
    $ virtualenv ~/virtualenvs/jeremyday
    $ source ~/virtualenvs/mysite/bin/activate

Install [pip][] and hence [Flup][]:

    $ easy_install pip
    $ pip install flup

Also install any other special packages.

Edit settings.py
================

Don’t know about you lot, but my `settings.py` has something like this in it:

    STATIC_URL = 'http://localhost/~pdc/jeremyday/'
    …
    TEMPLATE_CONTEXT_PROCESSORS = [
        …
        'jeremyday.template_context_processors.settings',
    ]

where the file `template_context_processors.py` contains the following incantation:

    from django.conf import settings as _settings
    ≈
    def settings(request):
        return {
            'settings': _settings,
        }
        
and I have a symbolic link from `~/Sites/jeremyday` to the 
directory `~/Projects/jeremyday/static`, which is where I put the 
style sheets and suchlike.

This is all so that in my templates I refer to style sheets like this

    <link rel="stylesheet" type="text/css" 
            href="{{ settings.STATIC_URL }}style/base.css" />

and on my development server it gets the files from my local server,
whereas on the production site I can change it to get static files from
a dedicated server if need be. To make this work I now need to edit my
production server’s file to have

    STATIC_URL = 'http://static.jeremyday.org.uk/'

In my current set-up, with only one server, this will just be another
name for the one server I actually own, but in the unlikely event that
demand for the site overloads the server, I can offload it to a separate
server, or even a content-delivery network.

So anyway, now would be a good time to edit the settings file to reflect production-only changes.

FastCGI and Nginx
=================

Now we want to test the FastCGI server:

    $ python manage.py runfcgi method=threaded \
        host=127.0.0.1 port=9002 \
        pidfile=jeremyday.pid minspare=2 maxspare=10 daemonize=false

I have adopted the convention on my server of numbering FastCGI ports
starting at 9001, and `jeremyday.org.uk` as site number 2 gets port
9002.

So now the FastCGI server is running; to see if it does anything useful
we need to get Nginx to talk to it.

Since I compiled Nginx from source, it lives in `/usr/local/nginx` on my
server.

    $ cd /usr/local/nginx/conf
    $ sudo vi nginx.conf

I use [Cog][] to generate the repetitive part of the configuration, but
copy-and-paste would probably work as well. Each server gets three Ngix
clauses as follows.

The first section redirects from `www.jeremyday.org.uk` to
`jeremyday.org.uk`:

    server {
        listen 80;
        server_name  www.jeremyday.org.uk;
        rewrite ^(.*) http://jeremyday.org.uk$1 permanent;
    }

This ensures it does not matter which URL people type in to their
browser, but avoids having caching and statistics split between the two
domain names.

The second is the site itself.

    server {
        listen 80;
        server_name jeremyday.org.uk;
        access_log /var/log/nginx/jeremyday.access.log main;
        error_log /var/log/nginx/jeremyday.error.log info;
    ≈
        location / {
            root /var/www/jeremyday.org.uk;
            try_files $uri @django;
        }
    ≈
        location @django {
            fastcgi_pass 127.0.0.1:9002;
            include fastcgi-params-for-django.conf;
        }
    }
    
Mostly it is about handing
over to Django via the FastCGI server.

Finally, the third clause sets up
the server for static files:

    server {
        listen 80;
        server_name static.jeremyday.org.uk;
        location / {
            root /home/jeremyday/Sites/jeremyday/static;
        }
    }
    
Looking at this now, it occurs to me that  a production site 
there would be more caching and compression options specified.

Now tell the server to reload the configuration:

    sudo ../sbin/nginx -s reload

Now I should be able to visit <http://jeremyday.org.uk/> and see the
front page working perfectly. Or, as seems more likely, I can now debug
the configuration until it works.

Finally, Daemontools
====================

Now the server is running OK but will not automatically restart should
the server be rebooted. I could write an init script for this, or a
script for Ubuntu’s replacement called [upstart][], but the simplest
approach is D.&nbsp;J. Bernstein’s [daemontools][]. The daemontools
philosophy is that, instead of obliging all writers of servers to know
how to detach from the terminal properly (which can be tricky to get
right), you write a single program that does it right, and use it to
daemonize servers written as ordinary programs.

To add a server, I create a folder `/etc/service/jeremyday` and add a
shell script named `run` like this:

    #!/usr/bin/env bash
    ≈
    source /home/jeremyday/virtualenvs/jeremyday/bin/activate
    cd /home/jeremyday/Sites/jeremyday
    ≈
    exec envuidgid jeremyday \
    	python manage.py runfcgi \
    		method=threaded minspare=2 maxspare=12 \
    		host=127.0.0.1 port=9002 \
    		pidfile=jeremyday.pid daemonize=false

The Python command line is the same as the one I have just been testing.
The rest of the script is essentially boilerplate for switching to the
correct environment and user ID.

Once the script is set to be executable it should be noticed by the
daemontools supervisor

    sudo chmod +x /etc/service/mysite/run
    sudo svstat /etc/service/mysite/

Now I should be able to refresh the browser window to verify that everything is running flawlessly.

Updating the Application
========================

Let’s imagine I have been working on the application and have made
changes on a working copy, and committed them to Git. After doing `git
push` on my working copy, I log in to the server with `ssh
jeremyday@spereadsite.org` and update the server with the following
incantation:

    $ cd Sites/jeremyday
    $ git pull
    $ sudo svc -du /etc/services/jeremyday

One day I shall find typing these commands onerous enough that I shall
have to look up an automation system like [Fabric][].

But for the present, that’s how I update Jeremy’s web site.
 

  [1]: 02/25.html "Recipe for Dpeplying with Git"
  [2]:  http://djangoadvent.com/1.2/deploying-django-site-using-fastcgi/
  [Cog]: http://nedbatchelder.com/code/cog/ 
  [daemontools]: http://cr.yp.to/daemontools.html
  [Fabric]: http://docs.fabfile.org/
  [flup]: http://trac.saddi.com/flup
  [pip]: http://pypi.python.org/pypi/pip
  [upstart]: http://upstart.ubuntu.com/
  [Virtualenv]: http://pypi.python.org/pypi/virtualenv



