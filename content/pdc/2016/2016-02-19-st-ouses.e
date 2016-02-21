Title: A RESTful API for Saint Ouses
Date: 2016-02-20
TOpics: saint-ouses rest http json typescript

For no reason at all I want to describe a RESTful protocol based on HTTP + JSON for a made-up scenario.


## A ridiculous scenario

As a starting point I need some information this protocol will be
exposing. Let’s start with an untraditional riddle
(with apologies to [St Ives][2]):

> As I was going to Saint Ouses<br/>
> I met someone with seven spouses.<br/>
> Every spouse had seven sacks,<br/>
> Every sack had seven cats,<br/>
> Every cat had seven kits.<br/>
> Kits, cats, sacks, spouses,<br/>
> How many were going to Saint Ouses?*

The idea here is we are designing a system for tracking the kits,
cats, sacks, and people of Saint Ouses.

For now we will assume we know about one entity in this strange
world, and want to be able to discover the others.


## Don’t start with URL templates

Most analysts nowadays know not to start with a list of remote
procedure calls like `getCats(personID, sackNumber)`, and will instead write a
bunch of URL patterns on the white-board, like the following:

    /people/{personID}/sacks/
    /people/{personID}/spouses/
    /people/{personID}/spouses/{spouseID}/sacks/
    /people/{personID}/spouses/{spouseID}/sacks/{sackID}/cats/
    /people/{personID}/spouses/{spouseID}/sacks/{sackID}/cats/{catID}/kits/

There are two problems with this.

The first problem is that we are not using consistent URLs. Ideally a
given person should have a single URL: this will make it possible to
distinguish people records by comparing URLs. As it is, if Alice, Bob
and Charley are married then it would appear Alice’s cat sacks would
be avaibale at three URLs (`/people/1/sacks`,
`/people/2/spouses/1/sacks`, `/people/3/spouses/1/sacks`, say).

The second  problem is that URLs templates tempt you in to creating
fragile protocols, with code that takes the IDs and munges existing
URLs to have different IDs. This locks you in to serving the data
with these URL patterns. It also makes it hard to access the data
generically. For a REST protocol, the actual URLs should not matter,
because you discover them by following links between resources. This
is great, because it allows us to create a mock server from a
directory of JSON files.


## Describe resources and links between them

This is the REST equivalent of an entity-relationship diagram.

<div class="image-full-width-plus">
    <img src="http://yuml.me/diagram/scruffy;dir:LR/class/[Person|name]2..n---0..n[Marriage], [Person]<>---[Sack], [Sack]<>---[Cat|name;aloofness], [Cat]<>---[Kit|name;fluffiness]" alt="(diagrm)" />
</div>

The hollow diamond indicates an aggregation that does not _own_ the
entities it aggregates. For example, deleting a sack does not delete the cats
that were in it.

There are various notations for describing JSON schemata;
the [TypeScript language type system][1] is convenient for me
and is fairly readable even if you don’t know it.


## Describing Kits

Let’s start with the simple case: a kitten:

    interface Kit {
        name: string;
        fluffiness?: number;
    }

The question mark tells us that `fluffiness` is an optional field.

There are two things missing.
First, we need to know about the cat this kitten is held by.

    interface Kit {
        …
        cat: Resource;
    }
    interface Resource {
        href: string;
    }

The reasons for using an object with an `href` attribute istead of
having an attribute `catHref`  are (a) it will allow generic code to
straightforwardly identify links, and (b) it allows for the addition
of additional link info, such as media-type.

Second, while this representation of the resource may be obtained in
different ways, it should have a single canonical URL. So lets
include that.

    interface Kit {
        href: string;
        …
    }

But now given that any of the attributes we might want to add  to
a linked-to resource also apply to this one, we can use interface
subclassing to shorten this definition:

    interface Kit extends Resource {
        name: string;
        fluffiness?: number;
        cat?: Resource;
    }

For example, a resource might look like this:

    {
        "href": "http://example.com/kits/69/",
        "name": "Maximillian Floofypants III",
        "fluffiness": 9.1,
        "cat": {
            "href": "/cats/34/"
        }
    }

I have shown the resource’s `href` attribute as a complete URL, but
it could be a partial URL, in which case it is resolved relative to
the URL used to retrieve it. For example, suppose you request
`http://example.com/randomizer/fandom-kit` and get the following:

    {
        "href": "/kits/123/",
        "name": "Tinypaws Bufflewuff",
        "fluffiness": 2,
        "cat": {
            "href": "/cats/45/"
        }
    }

Then the canonical URL of the resource is `http://example.com/kits/123/`&thinsp;.


## Cats and lists versus collections

The other entities have one-to-many links. How are these best
represented in JSON?


### Lists of kits

One option is to simply provide a list (JSON array) of links:

    interface Cat extends Resource {
        name: string;
        aloofness?: number;
        sack?: Resource;
        kits?: Resource[];
    }

This is OK so long as the number of items will never be so great you may
want to include them in the initial representation. If the list is extensible, you
add kits to a cat by issuing a `POST` request to the cat’s URL.

We can improve its utility by requiring more information about the
linked-to kits be included:

    interface Cat extends Resource {
        …
        kits: Kit[];
    }

For example:

    {
        "href": "https://example.com/cats/12/",
        "name": "Doomshadow",
        "aloofness": 4,
        "sack": "/sacks/deadbeef/",
        "kits": [
            {"href": "/kits/99/", name": "Boppinjay"},
            {"href": "/kits/100/", name": "Quinto"},
            {"href": "/kits/101/", name": "Flufflewuff"}
        ]
    }

By embedding of abbreviated versions of the kitten resources, we may
be able to avoid further round trips to the server if all we want to do is
present a bare-bones list of this cat’s kits. This is the reason for
making many of the attributes optional.


### Kit collections

The second alternative is to give the **collection** its own URL.
Something like this:

    interface Cat extends Resource {
        …
        kits: Collection<Kit>;
    }

    interface Collection<T> extends Resource {
        items?: T[];
        next?: Collection<T>;
        prev?: Collection<T>;
    }

We allow the server to determine how many items to include in
the representation. The first option
is to include nothing but a link to the collection itself:

    {
        "href": "https://example.com/cats/12/",
        …
        "kits": {
            "href": "kits/"
        }
    }

The second is to include links to all the kits in the response:

    {
        "href": "https://example.com/cats/12/",
        …
        "kits": {
            "href": "kits/"
            "items": [
                {"href": "/kits/99/", name": "Boppinjay"},
                {"href": "/kits/100/", name": "Quinto"},
                {"href": "/kits/101/", name": "Flufflewuff"}
            ]
        }
    }

The third is to include links to the top _N_ items and a `next` link to get more:

    {
        "href": "https://example.com/cats/12/",
        …
        "kits": {
            "href": "kits/"
            "items": [
                {"href": "/kits/99/", name": "Boppinjay", fluffiness: 5},
                {"href": "/kits/100/", name": "Quinto", fluffiness: 7},
            ],
            "next": {
                "href": "page2"
            }
        }
    }

The `next` link would return another collection object. This will be
the same format as the `kits` object, except it can have both `prev`
and `next` links, depending on whether there are further pages of
kits to be had. In our example the next page is also the last one,
so it only has a `prev` link:.

    {
        "href": "https://example.com/cats/12/kits/page2",
        "items": [
            {"href": "/kits/101/", name": "Flufflewuff", fluffiness: 9},
        ],
        "prev": {
            "href": "./"
        }
    }

Collections could also include `totalCount` and  `pageCount`
attributes for the benefit of UIs that show this information. For
merely scanning the data they are not needed.

In the last two cases the server also has the option of including
full resources for the kits rather than the abbreviated links.


### Lists versus collections

In designing a protocol, it is generally best to avoid unnecessary
optional features. For this reason it makes sense to not to make the
choice of list or collection available to the server, but instead to
decide which as part of the specification of the resource formats.

While it might be possible to use lists for some fields and
collections for others, it will be simpler to remember if we use
collections always. Also, collections are probably more
‘future-proof’ than simple lists. The downside is the client-side library needs to allow
for the fact that getting the child resources might require
another server request (even if the server is set up to alway
embed them in the parent resource).


## Sacks and people

The format for sacks is simplest of all, at least if can assume sacks
are only used for carrying cats.

    interface Sack extends Resource {
        holder?: Person;
        cats: Collection<Cat>;
    }

I am assuming that both the ‘someone’ and the spouses in the riddle
are all people. The rhyme also implies that plural marriage is a
thing in Saint Ouses. Without going in to
[the complexity of how databases represent marriage][4],
we can assume the API merely needs to expose the current list
of spouses of a person.

    interface Person extends Resource {
        name: string;
        spouses: Collection<Person>;
        sacks: Collection<Sack>;
    }

The `name` attribute is the name
used to refer to this person on this system, and need not be their
full legal name.


## Optional parts

In the above spec I have divided most resource types in to two parts:
the bare minimum needed (attributes not marked with a `?`) and the
full monty (if you include all the optional fields). When embedding
one resource in another the server can be expected to use the minimal
form, but if the resource is requested directly the long form will be
returned. There is not much difference in this tiny example, but in a
more realistic system the ‘full’ version of resources would include a
lot more data.

A different way to formulate this with the type definitions would be
to define a minimal and full datatype:

    interface KitLink extends Resource {
        name: string;
    }
    interface KitResource extends KitLink {
        fluffiness: number;
        cat: CatLink;
    }

This is roughly equivalent. The difference is that if `fluffiness` is
defined, you know that all the other fields in the optional part are
also defined.

The practical effect of making links and embedded resources interchangeable
is that the client-side library can be dumb
and ignore embedded resources
and that will work, or can be more sophisticated and
keep the embedded resources piggy-backed with the data to
fulfill a future request without a network round-trip.

This can be exploited to optimize the use of network bandwidth by the
protocol. The minimum-work server will just provide the minimal links
to things. A fancier one might bundle a level or two of information
that the user is likely to request next.


## Summary of rules

I worked through this exercise to try to clarify some ideas about JSON formats.
The most important rules I have discovered are:

1. Resources, like links, always have a URL.
2. The URL of a resource is always in an attribute named `href`.
3. Partial
URLs are resolved relative to the `href` of the resources that
enclose them.
4. The outermost resource’s `href` (if it is not absolute)
is resolved relative to the URL used to retrieve the resource.

Always using the same attribute name will allow for proxying and other
transformations of resources that involve rewriting URLs.)

The URL of a resource can be used to retrieve the
unabbreviated version of that resource.

Links to other resources and embedded resources use the same base
datatype. When used as a link it can be the bare minimum (probably
just the `href` and a name field), or can be a complete resource.

Collections are also resources (hence a mandatory `href`) and may
contain `items` and links to other pages of the same collection. The
`next` and `prev` links are technically also collections of the same
type, but in practice it would be surprising for them to be anything
other than just an `href` parameter. The presence of a collection
implies you can `POST` a resource of the correct type to that
collection to add another item.

I think these rules can be used as a the basis of a human-readable
and yet properly RESTful API.


\*Answer: One

  [1]: http://www.typescriptlang.org/Handbook#basic-types
  [2]: https://en.wikipedia.org/wiki/As_I_was_going_to_St_Ives
  [3]: http://stackoverflow.com/questions/2676178/joining-relative-urls
  [4]: http://qntm.org/gay
  [5]: http://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/
