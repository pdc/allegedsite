Title: How to use LESS on Ubuntu 14.04 LTS
Topics: lessc npm node ubuntu
Date: 2015-08-06


Here is how I got Less CSS to work on my web server, which runs Ubuntu.


# Previously

The story so far:

1. I have redesigned my site using Less to process the CSS.

1. Processing CSS with Less requires `lessc`.

2. You install `lessc` with `npm` and it requires the `node` command.

3. The `node` package that comes with Ubuntu 14.04 LTS installs the `node`
executable with the name `nodejs`, which prevents programs installed with `npm`
from working.


# A new hope

The new chapter begins with [NVM][], the Node version manager (via
[Justin Ellingwood][1]). This looks to be Node’s answer to RVM and Python’s
Virtualenv. As with Virtualenv, it is installed not as system administrator
but as the individual user. On my server each site has its own user account,
so I do something like this:

    $ ssh alleged@spreadsite.org
    ...
    $ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash
    $ nvm ls-remote
    $ nvm install v0.12.7
    $ nvm alias default v0.12.7

Now we can install [Less][] in the usual way:

    $ npm install -g less less-plugin-clean-css


# Entropy strikes back

Alas! it turns out that despite my best hopes this does not quite work for
deploying via Fabric because the changes to include `nvm` are in `.bashrc`
which does not run for non-interactive shells.

Instead the code in `fabfile.py` must be changed to something like this:

    with cd(code_dir):
        run('. ~/.nvm/nvm.sh && make')

This will activate the default Node installation before running Make.


  [nvm]: https://github.com/creationix/nvm
  [1]: https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server
  [Less]: http://lesscss.org
  [pip-tools]: https://github.com/nvie/pip-tools
