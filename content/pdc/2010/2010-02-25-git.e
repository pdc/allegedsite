Title: Recipe for Deploying  with Git
Topics: git django titania
Date: 2010-02-25
Image: ../icon-64x64.png

One of the requests for the new [Jeremy Day site][1] was to have [her
LiveJournal][2] copied to the front page. My first thought was to use
[jQuery’s wrapper around XMLHttpRequest][3] to pull in the Atom feed and
process that with XSLT—but I had forgotten the ban on cross-site
requests. I decided the correct solution was to get my own proper server
at last, so I could host a cached copy of the LiveJournal page there. (I
have since been told that it is possible to instead use some [gadget
from Yahoo][4].)

I am using Git
==============

The new site is implemented in [Django][5], so I can build and test the site easily on my iMac at home. Once it is working I need to copy the files to my server, as efficiently, securely and automatically as possible. I know young people like to drag and drop files with [FileZilla][6], but I prefer to just type a command in to the terminal window I already have open and let the computer do the donkey-work.

The approach I am taking is [Git][7], a distributed source-code-control system created by Linus Torvalds and subsequently beaten in to shape by a cast of thousands. Here’s how it works.

The first time I did this, I created an Git repository with SSH support on my server  using this recipe for [Hosting Git repositories, the Easy (and Secure) Way][8]. The jolly thing about this is that its configuration is (of course) maintained with Git, and this means I can (of course) edit it in a working copy on my desktop and push changes to the server with Git.

Creating a Site User
====================

First, visit [some random password generator][11] to create a password, and then SSH to my server to create a user to own the site, and create an SSH key for them:

    titania$ sudo adduser jeremyday 
    ... enter password when asked ...
    titania$ su - jeremyday
    titania$ ssh-keygen -t rsa
    ... enter password when asked ...

In this snippet, I have changed the server’s prompt to `titania$` for clarity; my desktop is called `oberon`.

The username is the site name minus the `.uk` or `.org` suffixes. In this case the site name is <code><http://jeremyday.org.uk/></code>. (There should be no confusion with user names used for actual people, since I follow the ancient tradition of using initials for users’s accounts.)

The point of creating a separate user for each site I host is containment—if one web site runs amok, its ability to affect other sites’ files should be limited. Given that I am the only one using my server this is probably overkill, but it can’t hurt to keep things tidy, right?

Creating a Repository
=====================

The point of creating the public/private key pair is that I need to add this user to my Gitosis server. So on my desktop, in my [text editor][12]  I open `gitosis.conf` and add something like 

    [group jeremyday]
    readonly = jeremyday
    members = @pdc jeremyday

—and add the site to an existing group I have called `editors`, so:

    [group editors]
    members = @pdc
    writable = jeremyday  …other sites listed here…

The group `pdc` is one I named after myself containing my IDs from a couple of different computers (since I was too dim to just copy the same key pair around). You will want to use something different. 

Now I return to the terminal window containing the SSH session and use this command to display the new user’s public key:

    titania$ cat /etc/.ssh/id_rsa.pub

And thus I can  copy and paste the public key data from the terminal window in to a new file `keydir/jeremyday.pub` in the Gitosis admin folder. Now all I need do to create the new repository is 

    oberon$ git add keydir/jeremyday.key gitosis.conf
    oberon$ git commit -m 'Added repository jeremyday'
    oberon$ git push

Now we are ready to import the site in to the repository. I am trying to get in to the habit of doing

    oberon$ git init

at the start of creating a new site, and to make commits at psychologically important moments. Now we need to introduce this local repository to the server’s repository:

    oberon$ git remote add origin git@spreadsite.org:jeremyday.git
    oberon$ git push origin master:refs/head/master

(where `spreadsite.org` is one of the DNS names for my server that happens to be fairly short). Repository is now filled, so I can switch to the terminal window with SSH in it and do 

    titania$ mkdir ~/Sites
    titania$ cd ~/Sites
    titania$ git clone git@spreadsite.org:jeremyday.git

At this point the repository is set up and I can use `git push` and `git pull` to update the server copy. Because it is going via Git, the updates are pretty fast—Git sends compressed deltas rather than a fresh copy of the whole file tree—and fairly secure—all the copying is done over SSH. It is also convenient in the sense of allowing for editing from odd places: I can now check out the site on my laptop, or even just SSH to my server, check out a copy in my user directory, and work on that.

Not the End
===========

This is not the complete story of deployment, since I have not talked about [setting up FasiCGI, Daemontools, and Nginx][13]. Until I get around to that, check out the [Django Advent recipe for Deploying a Django Site Using FastCGI][9].


  [1]: http://jeremyday.org.uk/
  [2]: http://cleanskies.livejournal.com/
  [3]: http://api.jquery.com/category/ajax/
  [4]: http://developer.yahoo.com/yql/
  [5]: http://www.djangoproject.com/
  [6]: http://filezilla-project.org/
  [7]: http://git-scm.com/
  [8]: http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way
  [9]: http://djangoadvent.com/1.2/deploying-django-site-using-fastcgi/
  [10]: http://www.clemesha.org/blog/2009/jul/05/modern-python-hacker-tools-virtualenv-fabric-pip/
  [11]: http://www.pctools.com/guides/password/
  [12]: http://macromates.com/
  [13]: ../04/11.html