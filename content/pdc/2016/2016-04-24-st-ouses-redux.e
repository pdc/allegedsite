Title: St Ouses Redux
Date: 2016-04-24
Topics: st-ouses rest redux javascript

I have started building a toy web application to give myself
something to try out some of these newfangled JavaScript frameworks
like React and Redux.

The basis of this is the [HTTP API for St Ouses][1].
The aim for this first version is to get the minimum done to pull
data through HTTP calls and display it on the page.
Some rainy day I will have a go at making a more
interesting display with the data, or making the data editable.


# The layer cake

The app needs three main things:

- a fake source of plausible-looking JSON to consume (described in an [earlier article][9]);

- controller code for retrieving the entities and keeping track of
  which one is displayed; and

- a simple view showing information about an entity and allowing the
  user to navigate to another  by following links.

This article outlines the middle layer, which is implemented using [Redux][].

For the sake of this exercise we are pretending that
this is the start of a more complex app and we are willing to do some
work up front to avoid unmaintainable code in the future.


# Where Redux comes from

If you already know what the Redux framework is you should probably skip this section.


## In the olden days

In the days of yore the views and controller would be server-side
code written in Python or some other language like Ruby or Java, with
the client side being a thin crust of HTML and a little ad-hoc JavaScript to
add flavour. The classic example is
an expandable item that works with a jQuery incantation like this:

    $('.toggleBtn').click(function (ev) {
        ev.preventDefault();
        $(this).parent().toggleClass('expanded');
    });

The information about which expandable items are expanded is not
maintained by our code. This means if you want to expand one of the
items for some other reason you need to know to set the correct class
on the parent element. This is OK for small examples but rapidly
become a confusing ball-of-mud as the application UI becomes more
complex.


## Managing user-interface state

A more structured approach uses JavaScript variables to indicate
which parts of the user interface are doing what. Often there will be
a function called `updateFoobar` examines the state and updates the
DOM accordingly. There may also be a collection of ad-hoc functions
for updating the state consistently.

This will keep things manageable at larger scales, but there will
still come a point where relationships between components are
difficult to understand because so much is glue code of the form of
event handlers that fiddle with the state of other components
directly.


## Doing more and more with JavaScript

Over the last 10–15 years much of the  responsibilities for user-experience has been
shifted from the server-side templates to the
JavaScript layer, supported by ever-more elaborate JavaScript
libraries and frameworks.
The logical conclusion is **single-page apps** with almost all the
application into client-side JavaScript code. It doesn’t just
manipulate the <abbr title="document object-model">DOM</abbr>
provided by the HTML document, but instead builds the UI from scratch:
the actual HTML may be limited to a stub whose only remaining job is
linking to the JavaScript resources and a style sheet. Similarly, the
web server is confined to mostly marshalling and unmarhsalling JSON
objects from or to the database in response to HTTP or websocket
requests from the JavaScript layer.

Whereas before the JavaScript had to only keep track of local state
(whether this menu is displayed or that toggle is toggled) and ad-hoc
approaches were adequate, with larger-scale user interfaces we need
to separate out the abstract state that represents the user’s journey
through the app from the code that projects state in to visible
changes to the page. The state is now an abstract version of data
relevant to the UI, and can be reasoned about and tested in
isolation.

One way to project state in to the UI is **[React][]**.
One way to manage state is **Redux**.



[Redux][] is a predictable state container for JavaScript apps. The
gist is that the state that is shared between components is gathered
in to a tree of immutable objects, and only changed through
dispatching *actions*; the way in which actions change the state is
specified through a *reducer* function. Actions are simple JavaScript
objects, and reducers are pure functions. This makes testing them in
isolation straightforward.


# St Ouses and the download reducer

We want to keep track of what’s been downloaded and what’s being
displayed. The `dl` reducer (so-called because I cannot type
downlaod) keeps track of entities that have been downloaded from the
server.

This is mostly handled in `dl-state.js`, which exports functions
`getLoadedEntity` and `withLoadedEntity`. The former is used by views
to extract the requested entity from the state, and returns null if it
is not loaded yet. The latter returns a new state which is the first
state after loading the supplied entity, and is used in the reducer.

With these two primitives defined, the `dl` reducer is quite short:

    import {OPTIONS, DL_REQUESTED, DL_RECEIVED, DL_ERROR} from './actions';
    import {withLoadedEntity, initialDlState} from './dl-state';

    /**
     * Reducer for dl state.
     */
    function dl(state=initialDlState, action) {
        if (!action) {
            return state;
        }
        switch (action.type) {
            case OPTIONS:
                if (action.api && action.api.href) {
                    return Object.assign({}, state, {
                        prefix: action.api.href,
                    });
                }
                break;
            case DL_RECEIVED:
                const {cls, url, entities} = action;
                return withLoadedEntity(state, cls, url, entities);
            default:
                // Pass
        }
        return state;
    }

The `OPTIONS` action is used to convey
settings like the API endpoint to the JavaScript code from the host HTML page.

The asynchronous action used to kick off downloading an entity is also fairly short:

    export function dlRequestAction(cls, href) {
        return (dispatch, getState) => {
            const state = getState();
            const url = resolveHref(state.dl, href);
            const canonicalHref = unresolveUrl(state.dl, url);

            dispatch(dlRequestedAction(cls, canonicalHref));

            return fetch(url)
            .then(response => response.json())
            .then(entity => {
                dispatch(dlReceivedAction(cls, canonicalHref, [entity]))
            })
            .catch(error => {
                dispatch(dlErrorActon(cls, canonicalHref, error));
            });
        };
    }

This broadly parallels [the example given in the Redux tutorial][2].
The controller dispatches `dlRequestAction('cat', '/cats/27/')` and
this in turn asynchronously dispatches the `DL_REQUESTED`,
`DL_RECEIVED` and `DL_ERROR` actions reporting the success or
otherwise of the download. It exploits the new HTML5
`fetch` function, which returns ES6 promises that handle the
deferring of handling the code until the download is resolved.
(The `fetch` function is [not yet widely supported][3] at the time of writing,
but the Babel transpiler has a polyfill.)

The comically named `resolveHref` and `unresolveUrl` functions are
used to ensure the various ways of referring to an entity are
converted to a consistent format. I am distinguishing here between
URL references (called `href` in the code) that may be partial (like
`/cats/27/`) and proper URLs, which are always complete (as in
`http://api.example.com/cats/27/`). Thus resolving an href yields a
URL. The unresolving function shortens URLs to an href relative to
the API starting point, mostly to save space by not storing _N_
copies of the common prefix.


## Shredding and unshredding

Part of the state managed by the `dl` reducer is copies of some
number of loaded entities. Because the reducer on occasion creates a
new copy of the state (as a requirement of immutability), we can’t
safely use JavaScript object identity to compare objects. To see
this, suppose the following JSON has just been downloaded from the
server:

    {
        "href": "cat30.json",
        "name": "Lily",
        "aloofness": 9,
        "kits": {
            "href": "cat30-kits.json"
            "items": [
                {
                    "href": "kit71.json",
                    "name": "Charly"
                },
                {
                    "href": "kit88.json",
                    "name": "Chanel"
                }
            ],
        },
        "sack": {
            "href": "sack5.json",
            "cats": {
                "href": "sack5-cats.json"
            },
            "holder": {
                "href": "person3.json",
                "name": "Deepak"
            }
        }
    }

If we later download `kit71.json`, then we risk having two JavaScript
objects representing this entity: the one in collection attached to
Lily’s entry, and the copy separately downloaded. If we later updated
one to reflect a change made by the user, code using the other object
would not reflect that change.

To avoid this problem, the shared state records each entity
separately, indexed by an ID generated as it is loaded in:

    {
        ...
        19: {
            id: 19,
            cls: 'cat',
            href: "cat30.json",
            name: "Lily",
            aloofness: 9,
            kits: {
                href: "cat30-kits.json",
                ids: [20, 21],
            },
            sack: {id: 22}
        },
        20: {
            id: 20,
            cls: 'kit',
            href: "kit71.json",
            name: "Charly"
        },
        21: {
            id: 21,
            cls: 'kit',
            href: "kit88.json",
            name: "Chanel"
        },
        22: {
            id: 22,
            cls: 'sack',
            href: "sack5.json",
            cats: {href: "sack5-cats.json"},
            holder: {id: 23},
        },
        23: {
            id: 23,
            cls: 'person',
            href: "person3.json",
            name: "Deepak"
        }
    }

This extra indirection between entities means
when we update an entity,
all entities that reference it will see the updated copy.


## Flexible depth

The St Ouses conventions allow the server some
discretion in how deep a copy if the object graph it supplies for any
given request, and we want to allow the views to request an object
graph with the information they need; this shredding and unshredding
process means that the two sides do not need to match.

The flip side to this flexibility is that the views must be able to
cope with their data being temporarily incomplete. For example, if it
is showing Lily (`cat30.json`) and wants to display details of her
kits, then an extra asynchronous request may be needed to retrieve
that data. In the meantime, the view must be prepared to show a
spinner or some other loading indicator.


## Is it loaded yet?

One thing I have not yet got a fully worked out story for is telling
whether the copy of the entity in the app state is the full entity or
just the minimal link information.

The one thing that is definite is that directly requesting an entity
will get you the whole thing. Otherwise the client can check for
individual fields (in this case, kits have fluffiness only if they
are fully loaded). What’s missing is a generic test that can be used
by the plumbing without knowing the details of what fields different
classes have.


## Classlessness

I started writing this expecting to end up writing JavaScript classes for the
various types of entity. Because I was using a
[behavior-driven development][BDD] approach,
I was able to defer gathering the methods in to a class hierarchy
until after the point when it became apparent that I did not need
a class hierarchy after all.

The reason for this is that given we are processing a sack entity,
when we find an object named `cats` that has an `items` member, we
can recognize it as a collection, and infer that the entities it
links to are `cat` entities. For the few cases where the collection
name is not the same as a the class name of the entity, a dictionary
supplies the overrides to the default assumption.

The risk of this approach is it relies on the JSON
format being correctly designed and the server generating it correctly.


# Navigation

This is the throwaway part of the app that lets me move through the entity graph
demonstrating that the links and the loading and unloading is all
working. In a real app we would be doing something much more ambitious.

There is one navigation action, `NAV_ENTITY`. This is dispatched to
say that the user has asked to see a particular entity, identified by
its URL reference (relative to the API prefix as usual).

The `nav` reducer takes not not just of `NAV_ENTITY` actions, but
also `DL_REQUESTED` and `DL_RECEIVED` actions. The last two tell it
whether the requested entity is being loaded or is available to
display.


# What next

So far all I have is a bunch of actions, initial states and reducers.
These can be exercised through the specs (tests), but where is the
app itself?

The final part of this silly example is the React-based views. (Not
that the views used in Redux-based apps need to use React, but the
two frameworks are designed to fit together well.) This article is
already long enough so I will leave React for the next one.


  [1]: 02/19.html
  [2]: http://redux.js.org/docs/advanced/AsyncActions.html
  [3]: http://caniuse.com/#search=fetch
  [9]: 04/03.html
  [prev]: 04/24.html
  [Jasmine]: http://jasmine.github.io/2.4/introduction.html
  [Karma]: https://karma-runner.github.io/0.13/index.html
  [React]: https://facebook.github.io/react/
  [Redux]: http://redux.js.org
  [Webpack]: https://webpack.github.io
  [BDD]: http://c2.com/cgi/wiki?BehaviorDrivenDevelopment

