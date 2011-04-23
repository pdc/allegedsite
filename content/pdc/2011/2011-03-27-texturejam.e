Title: New Project: Tetxurejam
Date: 2011-03-27
Topics: minecraft texturejam django python
Image: dirt_jam.png

I have created a web app called [Texturejam][] to host remixes of
Minecraft texture packs. The idea is to host [Texturepacker][] in a form
palatable to people who might want to use it.

Motivation
==========

My thinking was that there are many plaintive messages in
[Minecraft Forums][] asking to someone with Photoshop skills to rearrange textures
to their desires, and if I could come up with a way to do this it might
be useful to these people.

Part of the motivation for me is to give me a web app project to work on
to keep my web dev skills fresh.

Approach
========

The basic platform should be no surprise to people who have read earlier
blog entries: Django with MySQL for the remix metadata.

I do not want to face creators of texture packs with yet another place
to upload their files to, so Texturejam obtains its data by downloading
the packs from where they are hosted already.

The download time is unpredictable (many of the storage services people
use have high latency) so the building and caching of remixed packs is
done as an external task, with queuing handled by [Celery][]. This is
the first time I have used Celery and so far it has been simple and
quick to set up, both on my dev system (Mac OS X) and my server (Ubuntu).

I need to track who adds remixes so I can give them permission to edit
their work later; rather than roll my own (which Django makes fairly
straightforward) I am using the ‘log in with Twitter’ service via a
package called [django-social-auth][]. (Possibly overkill, since I am
not using any of the other social networks it supports.) The
advantage of delegating user authentication  is

- they have to worry about most of the security stuff, not me;
- most punters will have an ID already,
- signing up is faster.

The advantage of Twitter over, say, Facebook is that there is no reason
for a new user to worry that I will have access to their Twitter profile
because Twitter does not store private or hidden data about them. To
make it even easier, I don’t ask for ‘write’ permission on their
account, so they know I won’t tweet on their behalf.

Status
======

I do not yet have a way for users to create recipes form scratch—I add
them through the admin app. For now users are limited to creating Beta
1.3 versions of old texture packs that have not been upgraded by their
creators. The form takes care of setting up a remix using the right recipe.


  [Texturejam]: http://texturejam.org.uk/
  [Texturepacker]: http://pdc.github.com/texturepacker/
  [Minecraft Forums]: http://www.minecraftforum.net/viewforum.php?f=1021
  [Planet Minecraft]: http://www.planetminecraft.com/
  [Texturecraft]: http://texturecraft.net/
  [Minecraft Textures]: http://minecrafttextures.com/
  [r/mctexturepacks]: http://www.reddit.com/r/mctexturepacks
  [1]: http://www.minecraftforum.net/viewtopic.php?f=1021&t=12352
  [2]: http://www.planetminecraft.com/resources/texture_packs/
  [Celery]: http://ask.github.com/celery/index.html
  [django-social-auth]: https://github.com/omab/django-social-auth