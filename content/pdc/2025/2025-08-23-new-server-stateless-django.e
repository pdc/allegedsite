Title: Django sites on a shared server
Date: 2025-08-23
Topics: debian django deployment admin

When I am creating toy web sites I start with Django by default, so as to avoid
wasting time and energy researching the minutae of the myriad alternatives
before deciding which one to use. As a result, my recreational server has a lot
of tiny Django sites.
Here is how I am setting them up on my new server.


## What we need

For this example we use the tiniest [Django] site ever, [Morseless], a site I created
as a side effect of reading the Homestuck comic a while back. It is a stateless
server, so I am not using any of Django’s database features.

They have static resources, which following tradition are served from
a separate URL (`morseless.me.uk` has `static.morseless.me.uk`) as if
one day this site might need a separate static server. Nginx will proxy to a [Gunicorn]
server, which handles the interaction with Django’s WSGI endpoint. The Gunicorn and
hence the site need to run in a Python [virtual environment]. Running Gunicorn entails
creating Systemd unit files for the service and its Unix-domain socket.

The modern fad is for containerizing your servers with Docker, then containerizing
your containers with Kubernetes, and then containerizing your Kubernetes with Helm,
until every code change requires fifty trips to CI to build and redeploy the dozen
microservices that comprise your todo-list application. I am not bothering with
containerizing my own Django sites.

Changes from before:

In [2010] I used Nginx talking to an implementation Flup of a
prootocol named FastCGI. Also it seems I compiled Nginx from source.
And had to install Pip with Easy_install. In the snow, uphill both ways, etc.

In [November 2012] the WSGI protocol had become established so I switched
from FastCGI to a protocol called uwsgi, with its implementation [uWSGI]
(two names differing only by capitalization, and neither of them capitalized properly).

In [2018] I was having issues with uWSGI and Python versions, so switched to
what was then and is now the conventional route to deploying Django: [Gunicorn].
Gunicorn does not define its own protocol, so now the HTTP front-end and the
HTTP back-end communicate via HTTP. The Gunicorn process, same as uWSGI,
was launched and monitored using [D. J. Bernstein]’s ruthlessly simple [Daemontools].

On my new server, Nginx is a standard package, and like all modern Linux systems,
it is launched and supervised by [Systemd]. Hence I might as well use that to
launch my Gunicorn services.


## User account

We want a user and group for the site. I follow the convention of using the
site domain name, stripped of the `.me.uk` part. As root:

    SITE=morseless

    adduser --system --home /home/$SITE --group $SITE

    cd /home/$SITE
    mkdir sites static etc

The `morseless` user can’t log in, but the superuser can use `su` to pretend they did.

    su -l morseless -s /bin/bash

But most of the work setting up the site is done as root; this way the user account
of the service is limited in what mischief it can enact should it be suborned
by hackers, since it will not be able to write to any files.


## Acquire code

Most of my Django web sites are published on GitHub. So we can get the site code
with something like this:

    cd /home/$SITE/sites
    git clone https://github.com/pdc/$SITE.git

Later when redeploying we would run `git pull` in the same directory.


## Virtual env

The  way I currently like to work with Python dependencies and virtual environments
is [Poetry]. We will create its virtual environment ahead of time so to avoid Poetry
creating one with a cryptic name:

    python3 -m venv /home/$SITE/venv
    source /home/$SITE/venv/bin/activate
    cd sites/$SITE
    pip install gunicorn
    poetry install

Running the above as root—assuming you trust Poetry to not be subverted by hackers—means
that once again the web service will be unable to edit its own files if hacked.


## Running management commands

We need a way to pass in environment variables when running Gunicorn. Systemd
has a `EnvironmentFile` directive for that. It uses a file in the same format
as the `.env` file. So let’s create the file.

    SITE=morseless
    DOMAIN=morseless.me.uk
    ENV=/home/$SITE/etc/production.env

    echo >>$ENV <<end
    SECRET_KEY=$(pwgen 48)
    ALLOWED_HOSTS=$DOMAIN
    STATIC_URL=http://static.$DOMAIN/
    STATIC_ROOT=/home/$SITE/static
    end

These environment variables are used in [`settings.py`][settings.py].

Morseless is stateless so it has no need for database credentials, but in the
general case we would have the database URL here too.

We can use this file to run management commands to initialize the site:

    source /home/$SITE/venv/bin/activate
    export $(cat $ENV)

    ./manage.py check
    ./manage.py migrate
    ./manage.py collectstatic --no-input

We can test Gunicorn after deactivating the virtual env:

    deactivate
    env $(cat ~/etc/production.env) ~/venv/bin/gunicorn morselesssite.wsgi

Testing done, we can make the `.env` file be readable by root only (since only
Systemd will need to read it):

    chown root.root /home/$SITE/etc/production.env
    chmod 0600 /home/$SITE/etc/production.env


## Systemd units

Debian GNU/Linux uses [Systemd] as its orchestrator of services and other parts of
the system. So my plan is to make Systemd responsible for running the Gunicorn
servers that Nginx will proxy to.

Systemd services are defined by files called _units_. You can create _template units_
with placeholders for the instance name. So I created templates for the Gunicorn
socket and service, based on the exemplars in the [Deploying Gunicorn]
chapter of the Gunicorn documentation.

The socket unit is named `gunicorn@.socket` and its content looks like this:

    [Unit]
    Description=%i socket

    [Socket]
    ListenStream=%t/%i.sock
    SocketUser=www-data
    SocketGroup=www-data
    SocketMode=0660

    [Install]
    WantedBy=sockets.target

This creates a Unix-domain socket that we will connect to the Gunicorn service.
The ownership of the socket is granted to Nginx, so it can write to the socket.

The service also needs a template unit, called `gunicorn@.service`:

    [Unit]
    Description=%i daemon
    Requires=%p@%i.socket
    After=network.target

    [Service]
    # Gunicorn can let Systemd know when it is ready:
    Type=notify
    NotifyAccess=main

    # Run as per-website user & group.
    User=%i
    Group=%i
    # A directory created for runtime files within /run
    RuntimeDirectory=%i

    WorkingDirectory=/home/%i/sites/%i
    EnvironmentFile=/home/%i/etc/production.env
    ExecStart=/home/%i/venv/bin/gunicorn %isite.wsgi
    ExecReload=/bin/kill -s HUP $MAINPID
    KillMode=mixed
    TimeoutStopSec=5
    ProtectSystem=strict
    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target

When the template is expanded, `%i` will be replaced by `morseless`.
So it runs as user `morseless`, uses environment variables
from `production.env`, and runs Gunicorn from the virtual environment.

These two files go in the directory `/etc/systemd/system`.

The command to instantiate the Morseless version is run as root:

    systemctl enable --now gunicorn@morseless.socket

This results in a suitable symlink being created to cause the socket, and hence
the service, to be available.


## Nginx configuration

So how we have a socket with which one may have HTTP conversations. We need to
plumb it in to Nginx. This is fairly routine and can mostly adapt the example code
from the Gunicorn documentation.

Because I have several Django sites and plan to have them work the same way
as each other, I created the file from a template (in this case a simple Python one).

    template = """
    # Django-powered site. Content of site goes in /home/%(name)s/sites/%(name)s.

    server {
        server_name %(domain)s;
        listen 80;
        listen [::]:80;

        access_log  /var/log/nginx/%(name)s.access.log;
        error_log /var/log/nginx/%(name)s.error.log info;

        # Location of robots.txt, favicon.ico, et al.
        root /home/%(name)s/sites/%(name)s/web;

        location / {
            # First attempt to serve request as file, then try proxying to Gunicorn.
            try_files $uri @proxy_to_app;
        }

        location @proxy_to_app {
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $http_host;
            # Because we set the Host header, the backend will generate URLs that do not require redirects:
            proxy_redirect off;
            proxy_pass http://unix:/run/%(name)s.sock;
        }
    }

    server {
        server_name static.%(domain)s;
        listen 80;
        listen [::]:80;

        root /home/%(name)s/static;

        location / {
            try_files $uri $uri.html =404;
            expires 1d;
            # Gzip options also go here.
        }
    }

    server {
        server_name www.%(domain)s;
        listen 80;
        listen [::]:80;

        rewrite ^(.*) http://%(domain)s$1 permanent;
    }
    """

The three `server` clauses handle the dynamic and static parts of the site and
the redirect from `www.morseless.me.uk` to `morseless.me.uk` to
make the shorter URL the canonical one.

I have a script that generates these files, and I copy them in to `/etc/nginx/sites-available`
using `scp`. Then on the server I symlink it in to `sites-enabled` and restart Nginx
with `nginx -sreload`.


## Domain names & TLS

Modern web sites use TLS by default, that is, the URL is <https://morseless.me.uk> not <http://morseless.me.uk>. ([Why all websites should use HTTPS])

The certificates required to make this work on my server come from [Let’s Encrypt], a
nonprofit providing free TLS certificates to more than 700M websites. The installation
is handled by [Certbot], which uses a protocol called ACME to demonstrate ownership of
the domain name and acquire the certificates. Certbot takes care of munging
my Nginx configuration to reference the certificates and reruns periodically to keep them fresh.



## Future Changes

HTTP/2 is not exactly new but it seems it is not default in Nginx. So I need to experiment with
adding the `http2` directive and consider folding the static server in with the main server
(since having multiple domain names is bad for HTTP/2 in the same way it is good for HTTP/1.1).

A  possible future change might be to add custom error pages.

I should also experiment with Gzip settings.
I’m unsure whether (1) it would be helpful to add Gzip settings to the dynamic
pages, and (2) if it would be better to have the static files Gzipped on disc and
served with `gzip_static on`. Most of my files are so small compression will make little
odds so it is not in any way an urgent bit of optimization.

[Why all websites should use HTTPS]: https://letsencrypt.org/docs/why-all-https/
[12-Factor config]: https://www.12factor.net/config
[2010]: ../2010/04/11
[2012]: ../2012/05/08
[2018]: ../2018/06/17
[Choose an open source license]: https://choosealicense.com/licenses/gpl-3.0/
[Creating custom unit files]: https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html/using_systemd_unit_files_to_customize_and_optimize_your_system/working-with-systemd-unit-files#creating-custom-unit-files
[D. J. Bernstein]: https://cr.yp.to/djb.html
[Daemontools]: https://cr.yp.to/daemontools.html
[Deploying Gunicorn]: https://docs.gunicorn.org/en/stable/deploy.html
[django-environ]: https://django-environ.readthedocs.io/en/latest/
[Django]: https://www.djangoproject.com
[Gunicorn]: https://docs.gunicorn.org/en/latest/deploy.html
[Morseless]: ../2012/12/18
[Morseless]: https://morseless.me.uk/
[November 2012]: ../2012/11/03
[Poetry]: https://python-poetry.org
[Poetry]: https://python-poetry.org
[settings.py]: https://github.com/pdc/morseless/blob/main/morselesssite/settings.py
[Systemd]: https://systemd.io
[uWSGI]: https://uwsgi.readthedocs.io/
[virtual environment]: https://docs.python.org/3/library/venv.html
[Let’s Encrypt]: https://letsencrypt.org
[Certbot]: https://certbot.eff.org
