Title: A RESTful API for St Ouses
Date: 2016-02-20
TOpics: st-ouses rest http json typescript

For no reason at all I want to describe a RESTful protocol based on HTTP + JSON for a made-up scenario.


## A ridiculous scenario

As a starting point I need some information this protocol will be
exposing. Let’s start with an untraditional riddle
(with apologies to [St Ives][2]):

> As I was going to St Ouses<br/>
> I met someone with seven spouses.<br/>
> Every spouse had seven sacks,<br/>
> Every sack had seven cats,<br/>
> Every cat had seven kits.<br/>
> Kits, cats, sacks, spouses,<br/>
> How many were going to St Ouses?*

The idea here is we are designing a system for tracking the kits,
cats, sacks, and people of St Ouses.

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
be available at three URLs (`/people/1/sacks`,
`/people/2/spouses/1/sacks`, `/people/3/spouses/1/sacks`, say).

The second  problem is that URLs templates tempt you in to writing
code that takes the IDs and munges existing
URLs to have different IDs. This locks you in to serving the data
with these URL patterns, and makes it hard to access the data
generically. For a REST protocol, the actual URLs should not matter,
because you discover them by following links between resources. This
is great, because it allows us to create a mock server from a
directory of JSON files.


## Describe resources and links between them

This is the REST equivalent of an entity-relationship diagram.

<div class="image-full-width-plus">
    <img src="http://yuml.me/diagram/scruffy;dir:LR/class/[Person|name]2..n---0..n[Marriage], [Person]<>---[Sack], [Sack]<>---[Cat|name;aloofness], [Cat]<>---[Kit|name;fluffiness]" alt="(diagrm)" />
</div>

The hollow diamond are a UML notation that
indicates a one-to-many association.

There are various notations for describing JSON schemata;
the [TypeScript language type system][1] is convenient for me
and is fairly readable even if you don’t know it.


## Describing kits

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
        cat?: {
            href: string;
        };
    }

The reasons for using an object with an `href` attribute instead of
having an attribute `catHref` are (a) it will allow generic code to
straightforwardly identify links, and (b) it allows for the addition
of additional metadata to the link, such as `mediaType`, say.

Second, while this representation of the resource may be obtained in
different ways, it should have a single canonical URL. So let’s
include that.

    interface Kit {
        href: string;
        …
    }

The reason for wanting a canonical URL is to make resolving partial
URLs consistent. It also means that a `Kit` instance that arrives
through some non-HTTP means can be used as if it had been.

The links to a parental cat is lacking sufficient information to properly display a
link to the end user. It would be nice if the link has enough of the
cat-specific information to display a link without further
network requests. Since links to cats and the
entity that represents a cat
share a core of `href` and the information required for the link,
we can use a single interface `Cat` to represent both:

    interface Kit {
        href: string;
        fluffiness?: number;
        cat?: Cat;
    }

    interface Cat {
        href: string;
        name: string;
        aloofness? number;
        …
    }

In this example, the optional attribute `aloofness` stands in for the
more complete data needed to display a cat’s own page. The mandatory
attributes are required whether it is a complete entity or
just a link.

We can use the `extends` syntax to factor out the repeated elements
in this definition:

    interface Kit extends Entity {
        fluffiness?: number;
        cat?: Cat;
    }

    interface Cat extends Entity {
        name: string;
        aloofness? number;
        …
    }

    interface Entity {
        href: string;
        mediaType?: string;
    }

With this definition, a kit entity might look like this:

    {
        "href": "http://example.com/kits/69/",
        "name": "Maximillian Floofypants III",
        "fluffiness": 9.1,
        "cat": {
            "href": "/cats/34/",
            "name": "Deathstroke the Ultrafang"
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
            "href": "/cats/45/",
            "name": "Peach Paws"
        }
    }

Then the canonical URL of the resource is `http://example.com/kits/123/`&thinsp;.


## Cats and lists versus collections

The other entities have one-to-many relationships to represent. How
are these best represented in JSON?


### Lists of kits

One option is to simply provide a list (JSON array) of links:

    interface Cat extends Entity {
        name: string;
        aloofness?: number;
        sack?: Entity;
        kits?: Kit[];
    }

This is OK so long as the number of items will never be so great you
may not want to include them in the initial representation. If the
list is extensible, you add kits to a cat by issuing a `POST` request
to the cat’s URL.

For example:

    {
        "href": "https://example.com/cats/12/",
        "name": "Doomshadow",
        "aloofness": 4,
        "sack": "/sacks/deadbeef/",
        "kits": [
            {"href": "/kits/99/", "name": "Boppinjay"},
            {"href": "/kits/100/", "name": "Quinto"},
            {"href": "/kits/101/", "name": "Flufflewuff"}
        ]
    }

There is also the option of including complete resources instead of just links:

    {
        "href": "https://example.com/cats/12/",
        "name": "Doomshadow",
        "aloofness": 4,
        "sack": "/sacks/deadbeef/",
        "kits": [
            {"href": "/kits/99/", "name": "Boppinjay", "fluffiness": 4},
            {"href": "/kits/100/", "name": "Quinto", "fluffiness": 4},
            {"href": "/kits/101/", "name": "Flufflewuff", "fluffiness": 4}
        ]
    }


### Kit collections

The second alternative is to give the **collection** its own URL.
Something like this:

    interface Cat extends Entity {
        …
        kits: Collection<Kit>;
    }

    interface Collection<T> extends Entity {
        items?: T[];
        next?: Collection<T>;
        prev?: Collection<T>;
    }

This allows greater flexibility in how many items to include.
The first option
is to include nothing but a link to the collection itself:

    {
        "href": "https://example.com/cats/12/",
        …
        "kits": {
            "href": "kits/"
        }
    }

The second is to include links to all the kits:

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

The `next` link would return another collection entity.
You get its URL by resolving the partial URLs.
First get the URL of the collection by combining
`https://example.com/cats/12/` with `kits/` to get
`https://example.com/cats/12/kits/`&thinsp;,
then combine that with `page2` to
get `https://example.com/cats/12/kits/page2`.

This will be
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

    interface Sack extends Entity {
        holder?: Person;
        cats: Collection<Cat>;
    }

I am assuming that both the ‘someone’ and the spouses in the riddle
are all people. The rhyme also implies that plural marriage is a
thing in Saint Ouses. Without going in to
[the complexity of how databases represent marriage][4],
we can assume the API merely needs to expose the current list
of spouses of a person.

    interface Person extends Entity {
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

    interface KitLink extends Link {
        name: string;
    }
    interface KitEntity extends KitLink {
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

1. Entities, like links, always have a URL.
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

Links to other resources and embedded entities use the same base
datatype. When used as a link it can be the bare minimum (probably
just the `href` and fields fro name and icon if any), or can be a complete resource.

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
