Title: Programming in the Future with Webpack
Topics: webpack meta javascript babel
Date: 2016-01-24

I figured that the first step in fiddling with the JavaScript code I use on my navigation widget will be to convert it
in to a more fashionable build system, such as Webpack.


Why is Webpack?
================

In primitive times, JavaScript files were individually linked to from your HTML page. As you use more and more
third-party JavaScript libraries, this ends up with dozens of `script` tags in a row just before the closing `body` tag.

The malleability of JavaScript and the fact it can manipulate the DOM to include additional `script` tags means that you
can create dynamic loaders; several packages arrived that work by supplying a `require` function that works like the
equivalent in [Node][]: each module can use it to load the modules it in turn depends on. There are alas! several module
conventions (Node’s CommonJS, <abbrev title="Asynchronous Module Definition">AMD</abbrev> as used by [RequireJS][], and
<abbrev title="UNIVERSAL Module Definition">UMD</abrev> which tries to harmonize the two). The
[ECMAScript6][]/[ES2015][] and TypeScript languages include an `import` … `from` syntax that transpilers transpile in to
one of these formats according to command-line options chosen by baffled programmers.

The trick with all of these is that they involve extra web requests to download the modules as they are required. This overhead is lessened with [SPDY][] or [HTTP/2][HTTP2] but it is still an overhead that delays the start of your JavaScript code.

If the `require` variants are analogous to dynamic linking, [Webpack][] is the static linker: it scans the dependency
tree of your application and bundles the modules together in to one large file. This can then be minified and compressed
as a unit, which should get the best bang for your bandwidth buck. In addition it allows JavaScript modules to use the
`require` function to acquire CSS style sheets. Webpack arranges for them to be appear to JavaScript runtime as another
module, one that happens to add `style` elements to the page. This makes the code even more self-contained.

Webpack also allows you to write your app in CoffeeScript + SASS or TypeScript + Less through adding loaders to the
configuration.


Applied to my Entry Nav
=======================

The main change to support Webpack is to pull the main entry point in to its own file; this gets fed to Webpack and it
trances dependencies from there. It ended up looking like this:

    import React from 'react';
    import {render} from 'react-dom';

    import {EntryStore} from './entry-store';
    import {EntryNav} from './entry-nav';

    window.entryPage = function (options) {
        var entryStore = new EntryStore(options.store);
        render(<EntryNav entryStore={entryStore} initialDate={options.date} />, options.element);
    }

In my case I am invoking it from my `make` files, and the `webpack.config.js` file lives inside the `alleged.blog`
Python package within my Django file structure. (A standalone app or library project would have `weebpack.config.js` at
the top level.)

The Webpack config file looks like this:

    var webpack = require("webpack");

    module.exports = {
        entry: './components/entry-page',
        output: {
            filename: 'entry.js',
            path: './static/js',
        },
        module: {
            loaders: [
                {
                    test: /\.jsx?$/,
                    loader: 'babel-loader',
                    exclude: /node_modules/,
                    query: {
                        presets: ['es2015', 'react'],
                    }
                }
            ],
        },
        plugins: [
            new webpack.optimize.OccurenceOrderPlugin(),
            new webpack.optimize.UglifyJsPlugin({}),
        ],
        resolve: {
            extensions: ['', '.webpack.js', '.web.js', '.js', '.jsx'],
        }
    }

I am not (yet) using the CSS loaders, since I already have a build system for the CSS.

Because this module imports the React libraries, I can remove the corresponding `script` tag in the HTML.


Future Promise (and fetch) vs jQuery
===============

With React being in charge of DOM manipulation, I am only using jQuery in two places:

1. for its `$.ajax` function that wraps the unpleasantness of `XMLHttpRequest` calls, and
2. one occurrence of `$(elt).addClass` in the code for the animated transition.

The second of these is just a case of writing a simple `addClass` function of my own. The first issue is best tacked by
importing some JavaScript features from the future.

We can replace my simple use of `$.ajax` with the futuristic new HTML5 function [`fetch`][fetch]. This
replaces`XMLHttpRequest` hackery with a simpler function that exploits the futuristic new JavaScript concept
[`Promise`][Promise].

The code for maybe loading the data now looks like this:

    loadYearData(year, onYearDataReady) {
        if (!(year in this._promisesByYear)) {
            this._promisesByYear[year] = fetch(this.yearDataApi + '?year=' + year)
            .then(response => {
                if (response.status >= 200 && response.status < 400) {
                    return response.json();
                } else {
                    var error = new Error(response.statusText)
                    error.response = response
                    throw error
                }
            })
            .then(obj => {
                if (!('years' in this.data)) {
                    this.data.years = {};
                }
                this.data.years[year] = obj;
                return {year: year, yearData: obj};
            });
        }

        return this._promisesByYear[year];
    }

The `fetch` function starts the download and returns a promise; the first `then` call arranges to parse it as JSON when
and if it succeeds or raise an error otherwise; the second `then` takes the JSON once it is parsed, stores it, and
returns it. By storing the promise and returning to subsequent callers we ensure the API call is made once but all the
callers get the return value once it is ready.

[Promises are supported natively in most browsers][1]. A polyfill is I believe supplied by `core.js` which in turn is supplied by Babel’s `babel-preset-es2015` preset, so I don’t need to do anything special to use it.

The [`fetch` function is available on some browsers][2] but will need a polyfill for now.
The neatest way to do that using Webpack is to use its `ProvidePlugIn`. The following
voodoo code added to the `webpack.config.js` does the trick:

    plugins: [
        new webpack.ProvidePlugin({
            'fetch': 'imports?this=>global!exports?global.fetch!whatwg-fetch',
        }),
        …
    ],

This syntax is more than a little obscure, but I think it translates roughly as ‘load the module `whatwg-fetch`, import
its global `fetch`, then use this to create a global variable named `fetch`’. This removes any need for lines like
`import fetch from 'whatwg-fetch'` in the calling code, which is nice because both `fetch` and `Promise` will be global
variables on browsers that support them.


So is this less code?
====================

Part of the point of this—apart from moving my development practices towards the future—is to reduce the amount of
JavaScript code downloaded to show my silly entry navigator. Is adding bundling and polyfills a win?

<table>
    <thead>
        <tr><th>Resource</th><th>Before/KB</th><th>After/KB</th></tr>
    </thead>
    <tbody>
        <tr><td><code>react.min.js</code></td><td class="td-number">36.2</td><td class="td-number">—</td></tr>
        <tr><td><code>jquery.min.js</code></td><td class="td-number">29.4</td><td class="td-number">—</td></tr>
        <tr><td><code>entry-nav.js</code></td><td class="td-number">11.9</td><td class="td-number">—</td></tr>
        <tr><td><code>entry.js</code></td><td class="td-number">—</td><td class="td-number">57.8</td></tr>
    </tbody>
</table>

This takes the total for the navigation code from 77.5&thinsp;KB to 57.8&thinsp;KB.



  [Node]: https://nodejs.org/en/
  [ECMAScript6]: http://es6-features.org/
  [ES2015]: https://babeljs.io/docs/learn-es2015/
  [RequireJS]: http://requirejs.org
  [UMD]: https://github.com/umdjs/umd
  [SPDY]: https://www.chromium.org/spdy
  [HTTP2]: https://http2.github.io
  [Webpack]: http://webpack.github.io
  [fetch]: https://developers.google.com/web/updates/2015/03/introduction-to-fetch
  [Promise]: http://www.html5rocks.com/en/tutorials/es6/promises/
  [1]: http://caniuse.com/#search=Promise
  [2]: http://caniuse.com/#search=fetch
