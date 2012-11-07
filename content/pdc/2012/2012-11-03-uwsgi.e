Title: Switching from FastCGI to uWSGI
Date: 2012-11-03
Topics: deployment admin uwsgi fabric

I decided to spend a day updating my web sites to the latest software. In accordance with the laws of sofware enstimation, this took rather longer than I intended, but never mind that. Apart from upgrading the underlying operating system from Ubuntu 10.04 LTS to 12.04 LTS, I also wanted to switch from FastCGI hosting my sites to uWSGI.

Why switch to uWSGI?
====================

According to its web site, [uWSGI][]  is an extremely advanced, sysadmin-friendly, highly-modular application container server written in POSIX-compatible C.

Reasons it looked plausible to me include

- Django now includes a WSGI entry point as standard, so I can drop the requirement to use Flup;

- uWSGI was originally written for Python and is optimized for WSGI;

- Nginx includes a uWSGI module in its standard  configuration; and

- uWSGI’s Emperor mode makes it possible to deploy application updates without needing root access.

The last point relates to my set-up where give each site its own Unix
user account (so `alleged.org.uk` is user `alleged`, and so on), and deploying an
update entails using SSH to log in as that user to update the application
files and a second time to restart the app server.

The main downside is it is trickier to spell or pronounce than FastCGI.

Installing uWSGI
================

I ended up ignoring all the advice on the installation page in the
documentation and instead used the `setup.py` file directly. (I now think I could
instead have used `apt-get`, but nevermind.)

Since uWSGI uses Unix sockets for communication between Nginx and the
application servers, I will create a directory for them to be in. Because the
sockets will be created by non-root processes, the directory will need a group
these processes can belong to, created like so:

    sudo addgroup --system uwsgi

I set up a directory for config files:

    sudo mkdir -p /usr/local/etc/uwsgi/emperor.d
    sudo vi /usr/local/etc/uwsgi/uwsgi.ini

Created `/usr/local/etc/uwsgi/uwsgi.ini` with the following content:

    [uwsgi]
    master = true
    emperor = /usr/local/etc/uwsgi/emperor.d
    emperor-pidfile = /var/run/uwsgi/emperor.pid
    emperor-tyrant = true
    chmod-socket = 777

This sets it to run the emperor in tyrant mode, meaning  the effective UID and
GID of the vassal process comes from the owner and group of the `.ini` files
ifor the sites. I needed the `chmod-socket` line because Linux systems require
sockets to have write permission  for processes to communicate with them.

The other configuration file is the template shared by all the applications,
`/usr/local/etc/uwsgi/emperor.d/app.skel`:

    [uwsgi]
    chdir = /home/%n/Sites/%n
    master = true
    socket = /var/run/uwsgi/%n.sock
    chmod-socket = 777
    env = DJANGO_SETTINGS_MODULE=%n.settings
    home = /home/%n/virtualenvs/%n
    module = %n.wsgi:application
    max-requests = 1000

The idea here is that the `%n` placeholder will be replaced by the site’s
nickname ands thus all Django sites can use the same `.ini` file.

Finally, we need to make uWSGI a persistent daemon. On my server I use D. J.
Bernstein’s [Daemontools][1]. this boils down to creating a new file
`/service/uwsgi/run` containing

    ! /bin/sh

    exec 2>&1

    sockdir=/var/run/uwsgi
    echo Creating $sockdir
    mkdir -p $sockdir
    chgrp uwsgi $sockdir
    chmod g+w $sockdir

    echo Starting uWSGI emperor
    exec uwsgi --ini /usr/local/etc/uwsgi/uwsgi.ini

Why create `/var/run/uwsgi` in this script rather than just doing it once?
Because `/var/run` is a temporary directory and will be erased next time
Ubuntu restarts.


How to Add an Application Server
=============================

This also applies to converting the existing servers from FastCGI to uWSGI.

To add a new server we create a new `.ini` file from the skeleton file (using alleged as an example):

    cd /usr/local/etc/uwsgi/emperor.d
    sudo cp app.skel alleged.ini
    sudo chown alleged.uwsgi alleged.ini

The file ownership controls the UID and GID this application runs as. Using
group `uwsgi` is what gives it permission to create a socket in
`/var/run/uwsgi`.

For the standard skeleton to work, the website called alleged is set up so
that it is in Django’s new default layout.

- Its virtualenv is `/home/alleged/virtualenvs/alleged`;

- Its Django project is `Sites/alleged` and its Django settings file and WSGI entry point are in a
  package named _alleged_ in that project, that is in
  `Sites/alleged/alleged/settings.py` and
  `Sites/alleged/alleged/wsgi.py`.

This all creates the app server. We now need to plug it in to Nginx to make it
published. To do this I create a file `/etc/nginx/sites-available/alleged`
containing (amongst other things) a location definition like this:

    location @django {
        include uwsgi_params;
        uwsgi_pass unix:///var/run/uwsgi/alleged.sock;
    }

At this point it should in principle all be working.

Automated Deployment
====================

This s the payoff: because I don’t need to log in as two different users to do a deploy, it is more straightforward to automate it using [Fabric][]. On the development machine I installed Fabric with the usual command:

    pip install Fabric

and create a new file `fabfile.py` along these lines:

    # -*-coding: UTF-8 -*-
    # Run these commands with fab

    from fabric.api import local, settings, abort, run, cd, env, sudo, prefix
    from fabric.contrib.console import confirm

    env.site_name = 'caption'
    env.hosts = ['{0}@spreadsite.org'.format(env.site_name)]
    env.virtualenv = env.site_name
    env.settings_subdir = env.site_name
    env.django_apps = ['articles']

    def update_requirements():
        local("pip freeze | egrep -v 'Fabric|pycrypto|ssh' > REQUIREMENTS")

    def test():
        with settings(warn_only=True):
            result = local('./manage.py test {0}'.format(' '.join(env.django_apps)),
                    capture=True)
        if result.failed and not confirm("Tests failed. Continue anyway?"):
            abort("Aborting at user request.")

    def push():
        local('git push')

    def deploy():
        test()
        push()

        run('if [ ! -d static ]; then mkdir static; fi')
        run('mkdir -p caches/django')

        code_dir = '/home/{0}/Sites/{0}'.format(env.site_name)
        with cd(code_dir):
            run('git pull')
            run('cp {0}/settings_production.py {0}/settings.py'.format(
                    env.settings_subdir))

            with prefix('. /home/{0}/virtualenvs/{1}/bin/activate'.format(
                    env.site_name, env.virtualenv)):
                run('pip install -r REQUIREMENTS')
                run('./manage.py collectstatic --noinput')

        run('touch /etc/uwsgi/emperor.d/{0}.ini'.format(env.site_name))

The upshot of this is that I can now type a single command

    fab deploy

and automatically it checks the unit tests pass, then on the server it does approximately the following:

    git pull
    cp alleged/settings_production.py alleged/settings.py
    pip install -r REQUIREMENTS
    ./manage.py collectstatic --noinput
    touch /etc/uwsgi/emperor.d/alleged.ini

Before this I was doing the steps by hand – and this required logging in twice.

(Obviously the above recipe is itself ripe for automation, which is something
(I might look in to next time I am creating a new server, I guess.)


Updating an Existing Application
=================================

The main complication with existing apps was that most of them had that old
Django 1.3 layout. So I started by updating them to Django 1.4 and the new layout.

Previosuly I had edited the server settings on the server. Now I have a file
`settings_production.py` in the repo instead.

I used to have passwords on the private keys of the accounts used to access
Git. I reset those passwords to blank so that `git pull` works in the Fabric
script without my entering the password by hand each time.

For the same reason, I added my public key to the file  `.ssh/authorized_keys`
on each account so that no password is needed to SSH in to those accounts from
my development system.

Finally, during the upgrade most of the Python virtual environments were
broken. the fix for that is simple enough: rename the old virtualenv, and
create a new one. Since Python 2.7 is now the default this is a lot simpler
than before: when logged in as the application user I did

    mv virtualenvs/alleged virtualenvs/before-2012-11-02/alleged
    virtualenv --dist virtualenv/alleged

The installing of packages in to the new virtualenv can be left to the `fab
deploy` script.

Finally, the Daemontools directory for that web application can be decomissioned and deleted.

Future
======

The above configuration files are all quite new; it is likely I will discover
vital refinements in the coming weeks. In particular, servers like uWSGI and
PostgreSQL are set up for high performance by default, and on my toy web
server I will probably need to tune them down a little.

I am also suffering from the occasional outage that magically fixes itself
when I start investigating it. Very exasperating. But that is network
administration for you.


  [uWSGI]: http://uwsgi-docs.readthedocs.org/en/latest/
  [Fabric]: http://fabfile.org/
  [1]: http://cr.yp.to/daemontools.html