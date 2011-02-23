Title: Lucid
Date: 2011-02-19
Topics: ubuntu linux
Image: ../icon-64x64.png

My vast empire of web sites—well, my blog and some side projects like
[Jigsawr][] and [Spreadsite][]—all run on a [Linode][] node in
London. When I bought it—375 days ago—Ubunty 9.10 ‘Karmic Koala’ was all
the rage. Karmic loses security support in April 2011, so I have
upgraded my server to 10.04 LTS ‘Lucid Lynx’. I chose Lucid because it is
a LTS (long-term support) release.

This was just a case of following the
[recipe on the Linode documentation site][1].
After a few tense minutes it was rebooted with
the new operating system (and 512 MiB of RAM rather than the 360 MiB I
originally had, which is a nice bonus). But no <http://www.alleged.org.uk/>! Panic!!

Actually there were two things going wrong, both easily fixed. First, I
never did get around to making Nginx start up at reboot automatically,
so I had to log in and start the daemon myself.

Second, it seems that one or more of the packages installed for the
Python on Karmic are not compatible with Lucid. This was relatively easy
to fix. First I logged in with SSH using the `alleged` login, then
disposed of the old virtualenv and created a fresh one:

    alleged@titania$ mv ~/virtualenv/alleged{,-karmic}
    alleged@titania$ virtualenv --no-site-packages --distribute ~/virtualenv/alleged

The list of packages I need to install (including Django) is all
recorded for in `REQUIREMENTS`, so I can reconstruct the
environment in a couple of commands:

    alleged@titania$ . ~/virtualenv/alleged/bin/activate
    alleged@titania$ cd Sites/alleged
    alleged@titania$ pip install -r REQUIREMENTS
    alleged@titania$ pip install flup

(The Flup package is used on the server but not on the development
version. It is the FastCGI library [used to connect the application to
Nginx][2].) Once this was done it was just a case of restarting the
FastCGI service and voilà.

There is one gotcha: the above leaves a file
`/tmp/distribute-0.6.8.tar.gz` that must be removed before running these
commands as another user (and I have a separate user account for each
site).


  [1]: http://library.linode.com/troubleshooting/upgrade-to-ubuntu-10.04-lucid
  [2]: 04/11.html
  [Jigsawr]: http://jigsawr.org/
  [Spreadsite]: http://spreadsite.org/
  [Linode]: http://www.linode.com/?r=a247779fcaa562cb742bcd18ffd6eb15491f7681