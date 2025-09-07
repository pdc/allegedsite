# Update 2025


Create system user `alleged` and directory `/home/alleged` with subdirs
`sites`, `etc`. Start the environment file. This will be referenced in the
`EnvironmentFile` key of the Systemd unit for Gunicorn.

    mkdir /home/alleged/{sites,etc}
    ENV=/home/alleged/etc/production.env
    echo SECRET_KEY=$(pwgen 50) >> $ENV
    echo ALLOWED_HOSTS=alleged.org.uk,next.alleged.org.uk >> $ENV

Unpack the site in to the sites folder

    cd /home/alleged/sites
    git clone https://github.com/pdc/allegedsite.git alleged


Create directories for caching downloads & Django objects:

    ENV=/home/alleged/etc/production.env
    HTTPLIB2_CACHE_DIR=/home/alleged/cache/httplib2
    CACHE_DIR=/home/alleged/cache/django
    mkdir  /home/alleged/cache  $HTTPLIB2_CACHE_DIR $CACHE_DIR
    chown alleged:alleged $HTTPLIB2_CACHE_DIR $CACHE_DIR
    echo HTTPLIB2_CACHE_DIR=$HTTPLIB2_CACHE_DIR >> $ENV
    echo CACHE_URL=filecache://$CACHE_DIR >> $ENV


What next? Oh yes, the virtual environment.

    python3 -mvenv /home/alleged/venv
    source /home/alleged/venv/bin/activate
    cd /home/alleged/sites/alleged
    poetry install
    pip install gunicorn

Remember to use the environment file while testing & running management commands.

    ENV=/home/alleged/etc/production.env
    cd /home/alleged/sites/alleged
    env $(cat $ENV) ./manage.py check
    echo STATIC_ROOT=/home/alleged/static >> $ENV
    echo STATIC_URL=https://static.alleged.org.uk/ >> $ENV
    env $(cat $ENV) ./manage.py collectstatic

Test Gunicorn:

    cd /home/alleged/sites/alleged
    env $(cat $ENV) /home/alleged/venv/bin/gunicorn allegedsite.wsgi


Turn it on

    systemctl enable --now gunicorn@alleged.socket

Test the socket works  again

    sudo -u www-data curl --unix-socket /run/alleged.sock http

(WIll get a 400 from Django because it does not have corret allowed host.)

Edit DNS entries on Gandi

In the new-asite-2025 project, Update gen_django_conf, generate conf, copyt to server:

    scp out/alleged.conf root@mismiy.dev:/etc/nginx/sites-available

Onm the server,. link this in to sites-enmabled

Test

    curl -HHost:alleged.org.uk http://localhost

Update `get_certbot_command`






TODO

Swtich from Markdown library to one that is CommonMark-compliant.
- Perhaps a newer version of Markdown;
- Perhaps Misltetoe (as seen in Mismiy), but this will require reworking the munging of URLs
