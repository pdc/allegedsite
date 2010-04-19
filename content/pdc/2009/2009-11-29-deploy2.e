Title: Deploying Django to Debian: Backports
Topics: django  debian deployment
Date: 2009-11-29
Icon: ../icon-64x64.png


This was originally going to be part of [my note on porting *from* Windows 7 *to* Debian 5 ‘lenny’][5], but I split it off in to a separate post.

The second big ‘gotcha’ was that I had been developing my new Django site with the newest version 1.1, but Debian ‘lenny’ still has Django 1.0. I made a few feeble attempts to back-port my Django code, before looking in to ways to get the latest Django release on to the server.

Ubuntu?
=======

I wondered at first if I could upgrade (or cross-grade, if that makes sense) from Debian stable to Ubuntu Server, on the grounds that Ubuntu tends to be a bit more eager to get the latest stable versions of packages in. The idea would be to change the `sources.list` file and then do a distribution upgrade and hope for the best. But when I started to search for mentions of whether this works, I found that all references to converting from Debian to Ubuntu were for much older versions, and reported  problems with version skew. More to the point, this topic seems to have been excised from the official site: the implication is that  it is just too likely to go wrong. 

If this had been a one-off server, I would have been strongly tempted wipe it and install Ubuntu Server from scratch. But the server in question already had more than one site installed on it, and reinstalling all of them would have been more than ‘an afternoon’s work’.

Different Debian?
=================

I considered upgrading to [Debian testing][1]. This is a special automatically maintained distribution that lives partway between the [stable][2] and [unstable][3] versions. It comes with a disclaimer in large type warning that it does not get official security updates. For our purposes—an internal server—this is probably not as bad as it would be on a production server directly connected to the Internet.

Solution: Backports
===================

Then I discovered that there *is* a version of Django 1.1 for Debian ‘lenny’, as part of the [Debian Backports][4] project. This is a fairly young project for building the latest stable versions of various packages for the current version of Debian GNU/Linux. They use some cunning feature of  APT so that after adding their archives to your `sources.list` file, nothing happens until you enable individual packages. This way you make the minimum changes to your stable Debian system, certainly much less than upgrading the whole system to testing or unstable.

The upshot of this is that after much research I added a few lines to a configuration file and thus installed Django version 1.1.1-1~bpo50+1. Not sure if the number 1.1.1-1~bpo50+1 exactly inspires  confidence, but it works, and that’s the main thing.

Next
====

The other thing I faffed about with was getting the settings file sorted for the server as opposed to my develop version. I’ll possibly write about this in a later note, because this one is already too long.

  [1]: http://www.debian.org/doc/FAQ/ch-ftparchives#s-testing
  [2]: http://www.debian.org/doc/FAQ/ch-ftparchives#s-stable
  [3]: http://www.debian.org/doc/FAQ/ch-ftparchives#s-unstable
  [4]: http://backports.org
  [5]: 10/25.html

