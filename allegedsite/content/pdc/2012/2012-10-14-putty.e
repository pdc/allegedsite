Title: WAMP (1): Copying Files
Date: 2012-10-14
Topics: windows microsoft virtualbox deathmarch

WAMP is a perverted forward-backronym from <acronym title="Linux, Apache,
MySQL, PHP">LAMP</acronym>, for people who want to do web development, but
have some overriding reason to use Microsoft Windows (generally corporate IT
policy). To test a web site on Windows, I have a [VirtualBox][] instance set
up for my by [ievms][], and naturally I need to copy files on to it. Which is
a problem, because Windows is terrible at that sort of complicated system
administration.

Plan A: Shared Folder
=====

My first attempt to test this on Windows was to set up a shared directory
using VirtualBox. I followed their instructions, even read their moderatley
putrid manual, and nothing worked. I Googled to see if other people had
solutions to this and discovered (as is usual with Windows problems) all the
solutions were variations on following the recipe in the manual, with no
discussion of what to do if it fails.

Plan B: Rsync
=============

So I decided to try instead to copy the files in to the virtual disk of the
virtual PC. If my test server were Linux this would be something like:

    rsync -e ssh -av deploy/ foo@spreadsite.org:Sites/foo/

The advantage of using rsync is that you can do it repeatedly and only the
changed parts of changed files get copied, which over a network is much
faster. Since Windows does not have [rsync][] as standard, I spent some time
looking for third-party rsync implementations. So far as I was able to tell,
my options are as follows:

- install all of Cygwin;
- a GUI that thinks rsync is for backups only; and
- a GUI that uses its own protocol rather than rsync.

Cygwin is all about solving the problem that you are not using Unix by
installing something a bit like Unix on Windows. The third option is a non-
starter. I tried the second one. Unfortunately its UI was built around the
idea that you are using it to back up one Windows box on to another, it does
not have a command line, and in the end I stopped trying to make it useful.

Plan C: PuTTY
============

Having given up on having just one copy of the files, I now gave up on having
efficient copying, and switched to using [PuTTY][]’s implementation of
[Scp][]. PuTTY exemplifies as much as anything the inadequacies of Windows for
web development: in order to do two basic things, copying files to your server
and logging in to your server to set it up, you need to install a third-party
application from someone’s personal web pages and with a version number of
0.62. And once you have done so, PuTTY is the most useful piece of software on
your miserable Microsoft-certified genuine-Windows computer.

Now with PuTTY installed, I start up a command window and type

    "C:\Program Files\PuTTY\pscp.exe" pdc@192.168.0.2:deploy.zip Desktop

This puts the ZIP file on the desktop where I can double-click it to open it,
then drag and drop the toplevel folder on to the `C` drive icon in the left
panel of the Explorer window to extract the files with the minimum of mousing.
This is a throwaway server, so there is reason not to use the toplevel of the
`C` drive to store the application files. The main risk is that Windows moves
the icons in the left sidebar around  while you are dragging, which may cause
the files to end up in the wrong place.

Even better, each time I need to tweak something during the test I get to do
the whole nonsense all over again, because I can’t properly automate any of
this stuff. I discovered a useful feature of the ZIP program though. My actual
script for creating the deploy archive looks like this:

    rsync --delete -avC \
        --exclude cookbooks --exclude tests --exclude phpunit.* --exclude Vagrantfile \
        … more exclusions …
        site/ deploy

    zip -r full deploy --difference-archive --out incr.zip
    zip -rq full deploy

This creates two deployment files, `full.zip` is the complete set, whereas
`incr.zip` is the files added to `full.zip` since last time. This makes the
transfer-and-unpack process run faster, because copying files around in a
Virtual PC is pretty slow.

Oh, and every so often my copy of Windows spontaneously reboots in the middle
of a file transfer, just to remind me how wonderful Windows isn’t as a
development platform.

Plan D. FTP
===========

I did not need to resort to this, but I have in the past when both ends of the transaction are Microsoft Windows:

1. Copy the ZIP file to my personal web server with FTP from my development machine.
2. Copy the ZIP file from my personal web server with the `ftp` command on the virtual PC.

In other words, to cross the gulf between my desktop and a virtual PC in my office, go via my node in a datacentre in London.


**Updated 2012-10-17** to add the `--difference-archive` fiag for the `zip` command and Plan D.

  [virtualbox]: https://www.virtualbox.org/
  [ievms]: https://github.com/xdissent/ievms
  [xdissent]: https://github.com/xdissent
  [silex]: http://silex.sensiolabs.org/
  [vagrant]: http://vagrantup.com/
  [composer]: http://getcomposer.org/
  [rsync]: http://rsync.samba.org/
  [putty]: http://www.chiark.greenend.org.uk/~sgtatham/putty/
  [scp]: http://en.wikipedia.org/wiki/Secure_copy
