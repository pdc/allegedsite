Title: New Article Navigator
Date: 2022-12-31
Topics: meta

A [few years back][1] I created an interactive article navigator as an
exercise in learning React. I thought I’d see what it was like doing it over
now I’ve been writing UIs in React for a few years.

# Navigator

The navigator is the table of contents to the right (or below) this entry. Here is what it looked like:

<a href="nav-2015.png"><img src="nav-2015.png" alt="(screensot)" longdesc="#nav-15-desc" style="width: 312px; height: 463px"></a>


<p id="nav-15-desc">
The 2015 navigator has two sections: the first has links to the previous and next articles (if any). The second has the years listed in order from 1997. One year has been expanded in to a tinted box containing a list of months in that year, and one of those months has been expanded to a darker tinted box to show the entries for that month. The current entry is boldface
</p>

When I came to update the blog recently I discovered it had stopped working.
It is written in the React conventions of 2015 (React version 0.14), so debugging and
fixing it would be a pain, and besides I do not like the UX of the old
component: while it exercised React nicely, it is not really very useful for
navigation, and neither intuitive nor accessible.

So I decided I might as well redesign and reimplement it it using the modern
React conventions—and, I thought, I can do a clone in Svelte and see which
produces the leaner JavaScript code.


# Design

An important part of writing less code is designing your UI to go with the
grain of HTML&thinsp;5 (and its built-in ARIA support) rather than against. For my new nav I decided I
wanted something more useful and less showy, and to directly use the HTML&thinsp;5
elements `details` and `summary` to implement it.

The [details disclosure element][] is [available in all modern browsers]
[3] and does exactly what I want: when closed it shows a summary, and the
user can click on that to open it and show the details. A triangular icon
(‘twistie’) to the left of the summary rotates to show whether the details
are shown or not, a UI convention dating back to the 1980s.

<blockquote>
<details>
    <summary>Summary</summary>
    <p>Details details details</p>
</details>
</blockquote>

No JavaScript
required, and accessible via default.

The resulting design looks like this:


<a href="nav-2022.png"><img src="nav-2022.png" alt="(screensot)" longdesc="#nav-22-desc" style="width: 300px; height: 355px"></a>


<p id="nav-22-desc">
The years are listed in reverse chronological order, with disclosure triangles. The current article’s year is open to show a list of months indented under the year. The current article’s month is open and shows articles, of which the current one is highlighted with a tinted background.
</p>

There are a couple of complications.

1. When the list is first displayed, I want the current entry to be
visible and highlighted, and the previous and next entries (if any) to be visible.
This requires making the year and month elements containing them open by default.

2. I wanted the details of the closed elements
to be loaded lazily, so that the entire site index is not needlessly included
in every page view.


# React 2022

A lot has changed since 2015. Apart from improvements to the React framework
itself, the build system around it is infinitely more convenient.

- The
[Create React App][] tool will set up a working React project in a single
command, saving you days of faffing with Webpack or Rollup, Karma or Jasmine
or Mocha or Jest, Typescript-in-Babel or Babel-in-Typescript, and
what-have-you.
- The [React Storybook][] installer sets things up nicely for
developing components bottom-up, and Mock Service Workers [MSW][] facilitates
the writing of tests and storybook stories for components that request data
from the back-end.
- We can use JavaScript with `async`/`await` and `fetch` to
run requests.

All in all developing the component in 2022-style React feels a
lot more productive than the lash-up I came up with in 2015.

My desire to have some nodes open by default made it seem at first I needed to
track the state of the disclosure elements explicitly, which interfered with
my use of `toggle` events to load content lazily. I couldn’t work around this
by tracking `click` events instead, because that would have lost me the
accessible-by-default behaviours. What worked in the end was making toggling
the open nodes make that component uncontrolled (no value supplied for
`open`) rather than controlled (`open` set to false).

Anyway I got something that looked nice in Storybook and was about to start
working out how to integrate it in to the site. I ran `yarn build` to see how
big the bundle was and it turned out to be [FX: record scratch] 288K bytes. Which seems ridiculous.


# No React

OK, I thought, I better try the [Svelte][] version and see if it is reasonably small.
As it turned out, the timing is a but unfortunate and SvelteKit
(the equivalent of Create React App) and Svelte Storybook are not at present
talking to each other. While [I am told][2] the new beta of Storybook-Svelte works
better, I nevertheless took this as a prompt to pause and reconsider my approach.

The thing is, without the excuse of trying out a new web framework, React or Svelte are
overkill for this simple user interface. Last decade it would have been a
trivial jQuery job. The addition of `fetch` and `querySelectorAll` functions
to modern browsers means we do not even need jQuery.

So I went back to basics: what do I want the interaction on the page to be,
and how can I realize it with the least code? Following the old doctrine of
progressive enhancement, I first made it work without JavaScript: the Django
template renders the list of `details` elements, only including the details
of the years needed to display the current entry. The other years cannot load
their content without JavaScript, but they can link to the index page for
that year.

    <details>
        <summary><a href="/pdc/2020/">2020</a></summary>
    </details>

Now thinking about the JavaScript enhancements, I replaced the JSON back-end
call with one returning the HTML for the `details` element. The client code
can convert it to DOM nodes by assigning to the  `outerHTML` attribute of the
placeholder `details` element. This removes the need for client-side
template-rendering.

How does the JavaScript code know which elements need the event handler added
to? And how does it know the URL to request the data from? The answer to both
of these is to add a `data-nav` attribute with the URL to the placeholder
`details` element:

    <details data-nav="/pdc/2020/nav">
        <summary><a href="/pdc/2020/">2020</a></summary>
    </details>

This is destroyed when the `outerHTML` is assigned to, so we do not need our
own code to track which nodes have been loaded so far.

The upshot of all this is that JavaScript code is very short. Here is the
module in its entirety:

    const handleToggle = async e => {
        const elt = e.currentTarget;
        const res = await fetch(elt.dataset.nav);
        elt.outerHTML = await res.text();
    }

    document.querySelectorAll('*[data-nav]').forEach(elt => {
        const s = elt.querySelector('summary');
        s.innerText = s.querySelector('a').innerText;
        elt.addEventListener('toggle', handleToggle);
    })

The first two lines of the body of the `forEach` remove the fallback `a` tag,
since it is not needed if the JavaScript is running.

This is a lot less code than 288K! To be fair, my version requires a modern
web browser: a lot of the extra code in the React bundle is compatibility
code for IE&thinsp;11.


# Conclusion

React and Svelte (and Vue, Angular, et al.) make sense when implementing complex
user interfaces. For straightforward stuff using HTML&thinsp;5 as your UI
framework may prove simpler and more satisfactory to your readers as well.




[1]: ../2015/08/25.html
[Create React App]: https://create-react-app.dev
[React Storybook]: https://storybook.js.org/docs/react/get-started/introduction
[MSW]: https://mswjs.io
[details disclosure element]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details
[Svelte]: https://svelte.dev
[2]: https://techhub.social/@dimfeld/109581226380425535
[3]: https://caniuse.com/details
