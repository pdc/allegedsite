Title: Gunicorn Checklist
Date: 2018-08-04
Topics: gunicorn deployment meta

Here is a summary of how I set up a new Python-3-backed server on my hobby server.

An appendix to [Part 3 Let’s Try Gunicorn Instead][part3] of the [Running to Stand Still][todo] series.

Earlier notes to myself:

* [Recipe for Deploying with Git][2010a] (the user account and directory structure is still relevant)
* [Deploying Django with Nginx + FastCGI][2010b] (the NGINX parts are still semi-relevant)
* [Switching from FastCGI to uWSGI][2012] (mostly outdated now except perhaps some of the Fabric automation)
* [Let’s Try Gunicorn Instead][part3] (the latest chapter)



# On the Server as the Server Account

I use names without dots for the name of the site for simplicity, so for
example `spreadsite.org` uses the site name `spreadsite`. Lets keep that in a
variable so I can copy-paste these commands verbatim.

    SITE=jeremyday

The files for the site are owned by a user account named after the site.
Start by logging in as that user and creating its virtualenv.

    mv ~/virtualenvs/$SITE ~/virtualenvs/before-$(date +%Y-%m-%d).$SITE
    virtualenv --python $(which python3) ~/virtualenvs/$SITE

Install Gunicorn in the same virtualenv that it will be running code from:

    . ~/virtualenvs/$SITE/bin/activate
    pip install gunicorn


# As User with Sudo Access

Create a directory in `/service` as follows:

    SITE=jeremyday
    HOST=jeremyday.uk
    PORT=8003
    sudo mkdir /service/$SITE

Create logging directory (just in case—if things work as planned then logs go
in `/var/log/gunicorn`):

    sudo mkdir -p /service/$SITE/log/main
    cat /service/alleged/log/run | sudo tee /service/$SITE/log/run
    sudo chmod +x /service/$SITE/log/run

Create an environment directory:

    sudo mkdir /service/$SITE/env
    echo $LANG | sudo tee /service/$SITE/env/LANG
    echo /home/$SITE/static | sudo tee /service/$SITE/env/STATIC_ROOT
    echo //static.$HOST/ | sudo tee /service/$SITE/env/STATIC_URL
    python -c 'import uuid; print(uuid.uuid4())' | sudo tee /service/$SITE/env/SECRET_KEY

Copy the run script and update it for the new service account:

    sed -e s/alleged/$SITE/ -e s/8001/$PORT/ /service/alleged/run | sudo tee /service/$SITE/run
    sudo chmod +x /service/$SITE/run


# Local Tasks

Check there are no editing links in Pipfile. Then update `requirements.txt`.

    pipenv run python -Wall manage.py test &&
        pipenv lock -r > requirements.txt
    git commit -a -m 'Update requirements.txt'

Update `fabfile.py` to no longer tickle the uWSGI emperor. This is also the
time to prefix any `./manage.py` commands with `envdir /service/SITE/env `.
Something like this:

    with prefix('. /home/{0}/virtualenvs/{1}/bin/activate'.format(env.site_name, env.virtualenv)):
        run('pip install -r requirements.txt')
        run('envdir /service/%s/env ./manage.py collectstatic --noinput' % env.site_name)

This is needed so that `collectstatic` knows the correct directories to copy to.

It now should be possible to update the code on the server with:

    fab deploy

At this point the site might still be running but only because the emperor is
still serving the old environment.


# Check it Runs

Ideally it will already be running in `supervise` and you can check as follows:

    cd /tmp
    wget http://localhost:$PORT/

Where `$PORT` is the port number in the `run` file.

If this fails you can check the server by running Gunicorn extemporaneously like so:

    cd /tmp
    envdir env /home/$SITE/virtualenvs/$SITE/bin/gunicorn \
        --name $SITE-gunicorn \
        --chdir /home/$SITE/Sites/$SITE \
        --bind 127.0.0.1:7001 \
        --access-logfile $SITE-access.log \
        --error-logfile $SITE-error.log \
        $SITE.wsgi

And in another window

    cd /tmp
    wget http://localhost:7001/


# Finally, Update NGINX

Back on the server update the NGINX configuration with this command:

    sudo vi /etc/nginx/sites-available/$SITE.conf

Modify the `@django` clause to look like this:

    location @django {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://localhost:8003;
    }

Where the port number in `proxy_pass` must of course match that in `/service/$SITE/run`.

    sudo nginx -s reload


# And Remove uWSGI Configuration

    sudo rm /usr/local/etc/uwsgi/emperor.d/$SITE.ini


  [todo]: 06/17.html
  [part3]: 07/08.html
  [2010a]: ../2010/02/25.html
  [2010b]: ../2010/04/11.html
  [2012]: ../2012/11/03.html
