Title: Deploying Django from Windows: Subversion
Topics: django windows deployment
Date: 2009-10-25
Image: ../icon-64x64.png

We use Windows desktops at work, but naturally nowadays even our customers expect web sites to be deployed to Linux servers. Here’s a couple of things I learned in the process of deploying a Django app from my workstation—running Windows 7—to a development server running [Debian GNU/Linux 5 ‘lenny’][1].

Using Subversion
================

Both computers are on our internal network, so I just used Subversion to update the staging server. Before you do this you need to set Subversion properties on your source files to tell it to convert end-of-line character-sequences properly. I failed to do this the first time I checked out a copy on to a Unix system and the results were messy.

How to Set Subversion Properties on Windows
===========================================

[Subversion properties][3] can be set with the command-line tool. On Windows you will probably want to use  [TortoiseSVN][2] instead.

Start by selecting your source files, right clicking and choosing TortiseSVN&rarr;Properties. 

The first time you do this, click the New button to another dialogue, choose `svn:eol-style` from the menu button and `native` as the value. Optionally repeat the process with `svn:keywords` and `Id` to allow the use of `$Id$` to insert the revision number in comments. Now in the first dialogue box, choose Export to save these properties in a file `sourcefile.svnprops`, say, for reuse the next 50,000 times you need to mark a source file. 

Every subsequent time you add properties you use the Import button to retrieve the canned properties.  The Import button remembers the folder you saved them in, which is convenient. I created a folder just for canned properties files, which makes selecting the right one easy.

Deployment with Subversion
==========================

On the internal staging server I went for the simple option: the Apache configuration refers to a `.wsgi` file in a directory in my home directory. This directory in turn was set up with `svn checkout`. Doing a redeployment is as simple as doing `svn update`.

There are two ways to further complicate this sort of deployment, which I mention here even though they were not used in the Django case:

It got a little more complicated on a project (Drupal this time) when two of us were updating different modules. Just for the sake of the exercise I created a [RabbitMQ][5]-powered setup, with a queue consumer that ran `svn up` when it received a message, and a script my colleague could run that queued a message when he wanted to do an update.

A second way to complicate matters is to use Subversion-over-HTTPS as
the deployment system for a hosted server. The production server talks
to a read-only clone of the repository. This clone is accessible via a
sever on our network. It updates itself from the real repository with
with `svnsync`. It uses Apache’s configuration file to only accept
connections from the web server’s IP address. We run a Python script on
the server that updates a working copy of the code and munging some of
the files before copying them to the actual site with `svn export`. The
munging mainly consists of tweaking one of the CSS files so that the
staging site has a different background image from the production site.

Next
====

Next, [deploying to Debian 5 ‘lenny’][6].





  [1]: http://www.debian.org/releases/stable/
  [2]: http://tortoisesvn.tigris.org/
  [3]: http://svnbook.red-bean.com/en/1.5/svn.ref.properties.html
  [4]: http://backports.org/dokuwiki/doku.php
  [5]: http://www.rabbitmq.com/
  [6]: 11/29.html
  
  