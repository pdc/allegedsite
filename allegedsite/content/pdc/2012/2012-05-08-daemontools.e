Title: A Quick Daemontools Brain-Dump
Topics: deployment djbernstein caption django
Date: 2012-05-08

On my server I use D.&nbsp;J. Bernstein’s [Daemontools][] package to run the servers for my web sites (other services are automatically installed in to the `init` or `init.d` directories).

The logic with Daemontools is that servers should concentrate on what makes
them unique, and leave the slightly tricky process of running reliably in the
background without being connected to a terminal and logging their output to a
subsystem that does that and nothing else. It’s all about  security through
separation of concerns and simplicity.

In practice it means to set up the Kanbo server, say, I create a shell script
in `/service/caption/run` that does what is necessary to run the server as a
foreground process with errors to standard output. An optional second script
`/service/caption/log/run` can be used to log the output of the script.

In the case of the server for <http://caption.org/>, I had to debug the setup,
first by running the `run` script when logged in as the `caption` user to
check it could work at all, and then with this incantation:

    sudo ./run | (cd log;  sudo ./run)

(And before you ask, I would not suggest you run commands like that (with
`sudo`) casually. The great thing about the `run` scripts is they are simple
enough to scrutinise first!)

The first howler was forgetting to run

    sudo chmod +x run log/run

The other was using `source` as a synonym for `.` in a `/bin/sh` script. The third was getting `setuidgid` and `envuidgid` mixed up. Oops.

For future reference (for myself if no-one else) here is my run script for `caption.org` at present:

    #!/bin/sh

    . /home/caption/virtualenvs/bootstrap/bin/activate
    cd /home/caption/Sites/caption

    exec 2>&1
    exec setuidgid caption \
        python manage.py runfcgi \
            method=threaded minspare=2 maxspare=12 \
            host=127.0.0.1 port=9005 \
            pidfile=caption.pid daemonize=false

The logging script is even simpler:

    #!/bin/sh
    exec setuidgid caption \
        multilog t ./main

You have to remember to `chown` the directory `log/main` to allow the log to
be written. The server should in fact not print anything at all except in case
of errors—web server logs go to `/var/log/nginx`.

I think that is all I have to say about Daemontools.

  [Daemontools]: http://cr.yp.to/daemontools.html