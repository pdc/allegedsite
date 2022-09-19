Title: Fabric Emergency
Topics: fabric
Date: 2020-04-20

So I wanted to deploy an update to my web site [Ooble][] but I need to update or replace Fabric first.


The Problem with Fabric
=======================

Fabric is a tool for orchestrating shell commands run locally and via SSL on a
server using Python.  For example, after writing an article for [Alleged
Literature][], I use the command `fab deploy` to run the unit tests, push to
the upstream Git repository, log in to the server, run `git pull` and  various
other commands to update the web server.

The problem I have is that my website deployment used Fabric&nbsp;1.14, which
only runs on Python&nbsp;2. The new version, Fabric&nbsp;2 supports
Python&nbsp;3, but it is a ground-up rewrite with a new API so cannot be
easily used with my existing `fabfile.py`.



The Problem With Python 2
=========================

Python&nbsp;2 has been superseded by Python&nbsp;3. I have converted my
Django-powered web sites to use Python&nbsp;3, so it seemed to make sense to
tidy away some of the redundant copies of Python&nbsp;2 I still have on my
MacBook Air, but Alas! it turns out one of them was the one into which I had installed
Fabric. As a result the Fabric shell script still exists but fails.

I could in principle reinstall Fabric. There are a few blockers.

First, the remaining Python-2 install on my Macbook is the one provided with
the operating system. This is Python&nbsp;2.7 but (a) lacks Pip and (b) will
be removed in a future macOS update. So I am reluctant to rely on that.

I thought I could reinstall the `python@2` package I had installed via
Homebrew, but  as of 2020 is no longer included in [Homebrew][]’s repertoire.
Down the memory hole with you!

I tried building Python 2.7.17 from source (it really is just a case of
`./configure && make && make test`), but it fails its tests! The issue seems
to be [issue38295][], probably fixed in umcomming Python 2.7.18. So I could try
installing the release candidate but that seems a bit cavalier.

There is another implementation of Python&nbsp;2: [PyPy][]. It is still
available on Homebrew, for now. With a bit of finessing the build environment
I got it to install complete with the  crypto packages it uses to implement
SSH. This makes it possible to run Fabric one last time, using

    $ /usr/local/share/pypy/fab --version
    Fabric 1.14.1
    Paramiko 2.7.1

But I really do want to be abandonning Python&nbsp;2 now it is no longer
supported (2.7.18 is the last last final final release), so I have to migrate
away from this solution as soon as I can.


How About Fabric 2?
===================

Isn’t it about time I ported my Fabfiles to use Fabric&nbsp;2?

In the longer term I definitely want to escape from Fabric&nbsp;1.
Given I&nbsp;will need to rework my task definitions anyway, there is no
particular reason not to migrate to a different platform altogether.
I could try tricking out my
hobby server with an Ansible or turn it in to a Kubernetes cluster if I am
feeling especially masochistic.

But first I need to understand Fabric 2 enough to see whether it is still the
shortest path to getting back to something that works.

My copy was broken so I started by reinstalling it:

    $ brew reinstall fabric
    $ fab --version
    Fabric 2.5.0
    Paramiko 2.7.1
    Invoke 1.4.1

The [introductory documentation][] starts with a script that imports `fabric`, which fails because installing Fabric (the command) apparently does not install `fabric` (the package) where Python can see it. So I tried wrapping the tutorial script as a Fabfile:

    from fabric import task

    @task
    def whatever(c):
        result = c.run('uname -s')
        print(result.stdout.strip())

And when I run I get a stack trace and a complaint that it cannot find its own libraries.

    $ pipenv run fab -f neofabfile.py -H ooble@spreadsite.org whatever
    Traceback (most recent call last):
      File "/usr/local/bin/fab", line 11, in <module>
        load_entry_point('fabric==2.5.0', 'console_scripts', 'fab')()
      File "/usr/local/Cellar/fabric/2.5.0_4/libexec/lib/python3.8/site-packages/invoke/program.py",
      …
      File "/Users/pdc/Projects/linotak/fabfile.py", line 5, in <module>
        from fabric.api import local, settings, abort, run, cd, env, prefix
    ModuleNotFoundError: No module named 'fabric.api'

Even though I specified a config file with `-f` it is trying to read the old `fabfile.py`. So I rename the old fabfile & renamed the new one to fabfile.py.

Tried this in `fabfile.py`:


    @task
    def update_requirements(c):
        """Update requirements.txt to match Pipfile."""
        c.run('pipenv lock -r > requirements.txt')

It is essentially a straight copy from the old fabfile. I can run

    pipenv run fab update-requirements

But after printing messages from Pipenv complaining about my Python versions,
I end up with an empty `requirments.txt`. I don’t know whether the problem is
Pipenv being bloody-minded about Python minor versions, or something I need to
change with the task definition.

I am wondering if the best thing to do is to create Makefile entries for the
things I need to have run on the server and invoke them via `ssh … sh -c '…'`.
If all I am doing is running canned shell commands, how much value is Fabric providing?

(To be [continued][])

  [Alleged Literature]: https://alleged.org.uk/pdc/
  [Ooble]: https://pdc.ooble.uk
  [install pip]: https://pip.pypa.io/en/stable/installing/
  [Homebrew]:
  [issue38295]: https://bugs.python.org/issue38295
  [PyPy]: https://www.pypy.org
  [introductory documentation]: https://docs.fabfile.org/en/2.5/getting-started.html#run-commands-via-connections-and-run
  [continued]: ../2022/09/18.html
