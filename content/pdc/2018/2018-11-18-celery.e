Title: Celerating Ooble
Date: 2018-11-18
Topics: ooble celery django deployment

My latest experimental web server needs a task queue to do asynchronous
processing. Here’s how I deploy Celery on my Ubuntu server.


# First Install Your RabbitMQ

[Celery][] is a task queue, oroginally for Django, and then for any Python app,
and now in principle usable from any programming language. It needs to queue
tasks reliably and one way to do that is with an Advanced Message Queuing
Protocol ([AMQP][]) server such as [RabbitMQ][].

I followed [the procedure recommended in the RabbitMQ site][1] and installed
RabbitMQ from the Bintray repository run by JFrog.  The main gotchas were

1. The `rabbitmqctl` program used to configure the server is installed in a
    mysterious location `/usr/lib/rabbitmq/bin/rabbitmqctl`, which took me a little
    while to find; and

2. For some reason I had an ‘Erlang cookie’ that did not match the
    server’s—perhaps because of previous attemots at installing RabbitMQ—but
    this was easily fixed by copying the correct one:

        rm ~/.erlang.cookie
        sudo cat /var/lib/rabbitmq/.erlang.cookie > ~/.erlang.cookie
        chmod 600 ~/.erlang.cookie


# Celery

On my development system I have already installed Celery in to the app and
created tasks and tested things locally.

I repeated the setup steps from [instructions on the Celery site][2] to create an AMQP user and vhost, and set up the environment variable for the site in the usual way:

    echo amqp://ooble:correct-horse-battery-staple@localhost:5672/ooble |
        sudo tee /service/ooble/env/CELERY_BROKER_URL

The next step was pushing the code to the server and trying it out extemporaneously:

    . ~/virtualenvs/ooble/bin/activate
    envdir /service/ooble/env celery -A linotak.celery worker --loglevel=info

Finally, I wrapped up the startup script as a [Daemontools][] service by creating a
directory with a `run` script like this:

    #! /bin/sh

    SITE=ooble
    PACKAGE=linotak
    SITE_HOME=/home/$SITE

    exec 2>&1
    cd $SITE_HOME/Sites/$PACKAGE

    exec envdir /service/$SITE/env \
        setuidgid $SITE \
            $SITE_HOME/virtualenvs/$SITE/bin/celery \
                -A $PACKAGE.celery \
                worker --loglevel=info

Rather than having its own env dir it uses the env dir of the web server
(hence has identical environment variables).

This site deviates from my usual system in that I called the Python package `linotak` (link
notes taker) but the site it powers is [ooble.uk][].


  [AMQP]: https://www.amqp.org
  [Celery]: http://www.celeryproject.org
  [RabbitMQ]: https://www.rabbitmq.com
  [Daemontools]: https://cr.yp.to/daemontools.html
  [ooble.uk]: https://ooble.uk/
  [1]: https://www.rabbitmq.com/install-debian.html
  [2]: http://docs.celeryproject.org/en/latest/getting-started/brokers/rabbitmq.html#broker-rabbitmq
