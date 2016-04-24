Title: The Imaginary Cats of St Ouses
Topics: st-ouses python tdd
Date: 2016-04-03

I have started building a toy web application to give myself something to
try out some of these new-fangled JavaScript frameworks like React and Redux.
But first I needed a fake data server to supply the data for it to serve.


# The layer cake

The aim here is a demonstrator for the [HTTP API for St Ouses][1]:
the minimum to pull
data through HTTP calls and display it on the page.
Some rainy day I will have a go at making a more
interesting display with the data, or making the data editable.

The demonstrator needs three main things:

- a fake source of plausible-looking JSON to consume;

- model and controller code for retrieving the entities and keeping track of
  which one is displayed; and

- a simple view showing information about an entity and allowing the
  user to navigate to another  by following links.

This entry describes fake back-end. It will be short because there is not much to it.


# Approach

I wanted a cheap implementation of the HTTP
API I outlined earlier. The easiest way to fake an HTTP API is to
create a directory full of JSON files and point a web server at it.

I wrote [a Python module mkfake][mkfake] to generate the fake data. Once you take
correcting mistakes in to account, this is faster than
creating the individual files by hand.

After trying a few ways of having the parent entities create their
child entities (for example, having the constructor for cat have a
parameter for how many kits to create), I switched to generating the
child entities afterwards, assigning them to randomly chosen parents.
For example, given a list `cs` of cats and `ns` of cat names, this
generates kit entities spread randomly amongst the cats in `cs`:

    ks = [
        Kit(name=n, cat=random.choice(cs), fluffiness=random.randint(3, 10))
        for n in ns[20:]
    ]

After several unsuccessful attempts to generate random names
algorithmically, I made a list of cat and kit names by combining
[popular cat names from a few random countries][3]. I used the first
20 names for cats and the remaining forty-odd for kits.

The entity classes themselves all derive from an abstract base class
`Entity` that has code to generate the JSON-encoded information.
Because the attributes are supplied in the constructor in the same
way as each other I found myself moving more and more common code in
to the base class, until the subclasses ended up reduced to almost
nothing:

    class Cat(Entity):
        """Represents a cat."""

        class_name = 'cat'
        link_fields = ['name']
        entity_fields = ['aloofness']
        member_fields = {'sack': 'cats'}
        collection_fields = {'kits': 'cat'}

This compact style is possible in Python because methods are just
attributes that happen to have a function as their value and—or to
put it another way, member variables can be acquired from an
instance’s class and its superclasses in the same way member
functions are, and can therefore be overridden in the same way
functions can be. In languages like C++ and Java you would instead
define functions called `getLinkFields` that can be overridden in
derived classes.

I did not write these classes like this first time around, of course.
Instead they evolved in that form through adding features and
refactoring the code in
[Test-Driven Development][TDD] style.


# Output

If you want to see the raw HTTP protocol, you can clone [the
repository][7] and run these commands

    cd fake
    ./mkfake.py
    python -m SimpleHTTPServer 8086

and then visit <http://localhost:8086/person1.json> to see something
like the following:

    {
        "href": "person1.json",
        "name": "Alice",
        "sacks": {
            "href": "person1-sacks.json"
            "items": [
                {
                    "href": "sack7.json"
                }
            ]
        },
        "home": {
            "href": "index.json",
            "name": "St Ouses",
            "inhabitants": {
                "href": "index-inhabitants.json"
            }
        },
        "spouses": {
            "href": "person1-spouses.json",
            "items": [
                {
                    "href": "person3.json",
                    "name": "Deepak"
                },
                {
                    "href": "person2.json",
                    "name": "Bob"
                }
            ]
        }
    }

The URLs are simple enough that it should be possible to follow them
by copy-pasting them in to the URL bar of your web browser.

The next step is creating code to consume the API and do something
with the entity data.


  [1]: 02/19.html
  [mkfake]: https://github.com/pdc/st-ouses/blob/master/fake/mkfake.py
  [3]: https://en.wikipedia.org/wiki/Popular_cat_names
  [Redux]: http://redux.js.org
  [React]: https://facebook.github.io/react/
  [TDD]: http://c2.com/cgi/wiki?TestDrivenDevelopment
  [7]: https://github.com/pdc/st-ouses
