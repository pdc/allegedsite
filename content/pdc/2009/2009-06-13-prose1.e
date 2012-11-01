Title: Proseworlds: Exit Theory
Date: 2009-06-13
Icon: ../icon-64x64.png

I have a get-to-know-you project on [Google App Engine][1], and that project is [Proseworlds][2]. I am building a simple browser-based game, adding features one at a time in spare moments of time.

# The Vision Thing

The concept is a mud implemented with HTML, a [mud][3] being a multi-user real-time virtual world described entirely in text. In other words, imagine Second Life without the pictures. 

Muds are very similar to [text adventure games][4]—nowadays also called [interactive fiction][5]—where the player explores a fictional world by entering simple commands  like `TAKE LAMP` or `NORTH`. (This was in the olden days, before lower-case letters has been  invented.) The most important difference with muds is that  you can see other players as they, too, interacted with the game world. TinyMUCK—the mud  I played on in the early 1990s—also allowed players to build more of the game world. This gives you a way to interact with other players even when you live in different time zones so rarely log in at the same time.

The idea with Proseworlds is to allow for visitors to build parts of the game world and connect them together. The use of commands to navigate will be replaced with  appropriate web-application features, like buttons or forms.

# Structure of the Game World

The map is represented by data structures called *rooms* and *conduits* between rooms. 

<div>
	<img src="sample-map.png" alt="(diagram)" />
</div>

A room is a place you can visit and where things may be left. It does not necessarily represent a room in the game world—it may just as easily be a path in a forest or a town square. A room is mostly defined by its description, which is text—in my version, using the [Markdown][8] notation to allow for formatting—thus allowing for it to represent anything from a corner of a great hall to a spaceship bridge to an underwater ballroom.

A conduit is how you get from one room to another. On the above diagram the lines between boxes represent conduits. Conduits have two end-points, called *exits*. When you visit a room you see a list of the exits from that room. When you follow the exit, your avatar is transferred to  the room with the other exit. 

It follows that conduits are symmetrical—this is different from the one-way links I was used to in FurryMUCK and other muds, and indeed my first prototype used one-way links, where you had to create a second link from the second room to the first. Apart from making it a bit less tedious to create the game map, it also provides a mechanism for sharing control of the game world.

# Building the World Together

I want players to be able to build their own areas of the world. How do we manage the links between them? In Proseworlds  the plan is that someone, let’s call her Alice, owns a room. She can create an exit from that room—this automatically creates the conduit and the other endpoint. At this point she can attach the other endpoint to another room of her own, or she can assign it to her friend Bob. Now Bob can create a room to link the exit to, or can link it to one he prepared earlier. The result is a conduit where Alice owns one end and Bob owns the other.

In order to avoid certain forms of shenanigans, once a conduit is shared between two players, they can’t change their endpoints. This way Bob won’t wake up one morning to discover the way in to  his ninth-floor flat has been moved to Alice’s city dump.

What’s missing here is a way for Bob to acquire an exit he can build on automatically. In many muds, this is done through some form of vending machine dispensing exits. That kind of automation does not exist in Proseworlds yet. In effect the provision of an exit is like an invite code, and for now that will suffice. 


# Future for Exits

To make it possible to create simple puzzles in the game we need to add a way to control whether an exit can be used or not—for example, to forbid going through a door if you don’t have the key. My idea for this is to have conditions on exits in terms of *tags*. Tags are applied to things, much like they are to photos on Flickr. The key to the treasure room might be tagged `unlockstreasureroom`, for example; the precondition for the exit leading to the room mentions that tag, and you have to be holding the key to travel through it.

There are some kinks to work out here. First is the problem of tag forgery: I want tags to be simple to create and remember for the person designing a puzzle, but if anyone can create a key by making a thing with the correct tag on it, it won’t be very water-tight. I think the solution to that is to allow for namespaces (in the style of [machine tags][6]), with player having ownership of their avatar’s namespace (e.g., only the user `korvar` can set tags starting  `korvar:`…). 

Conditions also allow for one-way exits: all you do is attach a condition to the other direction that is never satisfied. (This implies that the conditions are checked when the menu of exits is created for display on the page, not when you try to follow the exit.) 

Conditions also allow for an exit that leads to different rooms depending on some condition. This would work by allowing conduits to have more than two endpoints. The pre-condition of the exit in the room you are in controls whether you can ‘enter’ the conduit. The postconditions of the other exits controls which rooms you can arrive in. If exactly one exit has a satisfied post-condition, you arrive in its room. If more than one is satisfied, your destination is chosen randomly (useful for making truly annoying mazes). If none are satisfied, you end up back where you started. 

This is still more of a misty plan in my head than a finished design; I may need to think more about the details to try to find a good balance between supporting interesting automation, versus making things too complicated for world builders, versus making it too easy to cheat or create mischief in the game.

Goals
=====

I don’t think I will be funding my retirement with this application: the
allure of Second Life Minus the Graphics is bound to be a bit limited!  I would like to get it to the state where I can port the original [Collossal Caves Adventure][7], say, complete with working lamp and magic words. Along the way I will have to work out some interesting user-interface issues and also come up with a way to have players in the same room communicate with each other, otherwise the multi-player aspect will not add up to much.





  [1]: http://code.google.com/appengine/
  [2]: http://proseworlds.appspot.com/
  [3]: http://en.wikipedia.org/wiki/Multi-User_Dungeon
  [4]: http://en.wikipedia.org/wiki/Adventure_game
  [5]: http://en.wikipedia.org/wiki/TinyMUCK
  [6]: http://www.flickr.com/groups/api/discuss/72157594497877875
  [7]: http://www.digitalhumanities.org/dhq/vol/001/2/000009.html
  [8]: http://daringfireball.net/projects/markdown/