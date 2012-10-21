Title: Bootstrapping virtualenv and virtualenvwrapper on Mac OS X
Date: 2012-08-25
Topics: python virtualenv macosx

When I upgraded my iMac to Mac OS X 10.8 Mountain Lion it upgraded Python to
2.7.2, which is nice, but also lost my site-specific changes—such as the
installation of [pip][], [virtualenv][] and [virtualenvwrapper][]. These three
basic tools allow me to create isolated Python installations and install
packages in to them. So it was time to try to work out the neatest way to get
things set up again.

Here’s the cribsheet for installing virtualenvwrapper (where `$` is standing in for your shell prompt):

    $ curl http://python-distribute.org/distribute_setup.py | sudo python
    $ curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | sudo python
    $ sudo pip install virtualenv virtualenvwrapper

Now, if I had not already done this, I would need to wire virtualenvwrapper in to my shell as follows:

    $ mkdir ~/virtualenvs
    $ cat >> ~/.profile
    export WORKON_HOME=~/virtualenvs
    . /usr/local/bin/virtualenvwrapper.sh
    ^D

The `cat` command is a substitute for editing your `.profile` file by hand to add those two lines. Very important to type `>>` rather than `>` if you actually use this command.

I want to use the latest version of Python so I also need to do this (having previously installed [HomeBrew][]):

    $ brew install python
    $ brew link python

Now to create a virtual environment for a project called, say, creosoteelephant, I would do

    $ mkvirtualenv --python=/usr/local/bin/python2.7 --distribute creosoteelephant
    $ echo cd ~/Projects/creosoteelephant >> ~/virtualenvs/creosoteelephant/bin/postactivate

The second line assumes my arrangement, which is to have a `Projects` folder in my home directory containing all my projects.


  [pip]: http://www.pip-installer.org/en/latest/
  [virtualenv]: http://www.virtualenv.org/en/latest/
  [virtualenvwrapper]: http://virtualenvwrapper.readthedocs.org/en/latest/
  [distribute]: http://pypi.python.org/pypi/distribute#installation-instructions
  [HomeBrew]: http://mxcl.github.com/homebrew/