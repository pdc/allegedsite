Title: Using Make instead of Fabric
Date: 2022-09-18
Topics: fabric make 

A quick follow-up to my problems with Fabric to note that I ended up just using Make instead.

In [an earlier entry][] I outlined the issues I had been having with Fabric,
the library I had been using to automate the deployment of this web site and
[Ooble][]. I decided to try setting up Ooble to instead just use Make and SSH
and it turns out to be relatively straightforward.

All it really needs to do is

1. on the local machine:
    - run tests one last time
    - generate `requirements.txt` if needed
    - push to GitHub
2. then on the server:
    - pull from GitHub
    - run any database migrations
    - copy any new static files
3. as root on the server:
    - run `svc -h /service/alleged`

The first part of this is straightforwardly what Makefiles are for.

The second part is straightforward enough once I set up a public-private key
pair so my script can SSH in to the server without my typing a password.
There may be a more clever way to do this but I just did the simplest thing I
could think of, which is pipe commands into the `ssh` command:

    sshsh=ssh $(HOST) sh
    prefix=. /home/$(SITE)/virtualenvs/$(VIRTUALENV)/bin/activate; \
        cd $(SITE_DIR);
    manage=$(prefix) envdir /service/$(SITE)/env ./manage.py

    deploy: tests requirements.txt
        git push
        echo "mkdir -p static caches/django" | $(sshsh)
        echo "cd $(SITE_DIR); git pull" | $(sshsh)
        scp requirements.txt $(HOST):$(SITE_DIR)
        echo "$(prefix) pip install -r requirements.txt" | $(sshsh)
        echo "$(manage) migrate" | $(sshsh)
        echo "$(manage) collectstatic --noinput --ignore Rules.mk" | $(sshsh)

The variable `prefix` ensures the commands run within the virtualenv for this
site (I have several sites on one server; each has its own virtualenv).

The `manage` prefix further adds the environment variables encoded as files in
`/service/$(SITE)/env` (the same as is used by the script that runs Gunicorn)
and invokes the `manage.py` script.

The third part requires doing something dodgy security-wise—either allowing my
script to log in as root, allowing the user on the server to run `sudo`
(definitely not!), or creating a setuid script containing
`svc -h /service/alleged`. Oh, except setuid scripts have at some point been
banned by the kernel for being too tricky to write safely. To be honest, it
is probably easier for now to just type the one command extemporaneously.


[an earlier entry]: ../2020/04/20.html
[Ooble]: https://pdc.ooble.uk/
