Title: Minification
Date: 2010-08-29
Topics: svg javascript 10k 

I created an [SVG-powered jigsaw app][269] for the [10K Apart][] contest. To get
it under 10K I had to squash the JavaScript and CSS files down as much
as possible (within the rules). 

The brief is to build a web app in less than 10 kilobytes. The rules
allow for the use of a minifying program to squash down the JavaScript
and CSS files.

Minifying JavaScript with Google Closure Compiler
=================================================

For the JavaScript, I used Google’s [Closure Compiler][] on its `SIMPLE_OPTIMIZATIONS` setting (since `ADVANCED_OPTIMIZATIONS` does not seem to be compatible with using jQuery in an external library).

Variable and parameters names are automatically shortened by the minifier, so there was no need to use confusingly short names in the code I was editing. I also eventually though to wrap the whole file up as a module in order to allow the compiler to abbreviate internal function names as well:

    window.Jigsaw = (function () {
        var SVG = 'http://www.w3.org/2000/svg';
        var XLINK = 'http://www.w3.org/1999/xlink';
        var doc = null;
        var rootElt = null;

        // Find an element by ID.
        var getElt = function (idOrElt) {
            if (idOrElt.getAttribute) {
                return idOrElt;
            }
            return doc.getElementById(idOrElt);
        }
        
        … more module function and variable definitions …
        
        return {
            init: function (evt) {
                … set up event handlers and stuff …
            }
        };
    })();

Because all the module definitions are wrapped in a function, they can be renamed by the minifier without changing their meaning.

The effect of this is to reduce the size of `jigsaw.js` from 11K to 3½K (69% reduction).  

Minifying CSS with CSS min
==========================

I had trouble finding a standalone CSS minifier, partly because I was
foolishly reluctant to install a Java application (for fear of spending
the rest of the evening fiddling with Java settings). The alternative I
found via Google was [a JavaScript port of CSS min][1]. After some
fiddling with several command-line JavaScript interpreters, I discovered
Safari’s [JavaScriptCore][], available at

    /System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc
    
I linked this to `/usr/local/bin/jsc` for convenience and created a
script that takes CSS as a command-line argument and stuffs it
through the `cssmin.js` script.

**Note.** I do *not* recommend you do this. Install YUI Compressor or
use [Cssutils][].

Minifying HTML and SVG with sed
===============================

I did not attept a clever HTML compressor. I did, however, create a
`sed` program to remove whitespace at the starts of lines:

    sed -e 's/^ *//'

This actually reduces the file size by 30%.

I did do a few things to keep the file size down in the first place. I
used HTML5 docref and `meta` tags:

    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="utf-8">

HTML5 also permits the short version of a boolean attribute:

    <option value="24" selected>Medium</option>

The ID and class names in the HTML can’t be minified, so I also stuck to
1- and 2-letter names for those.

Automation
==========

I edit and test the app in the non-minified form, and have a Makefile
target that generates the minified files and
assembles the distribution in its own directory.

It also creates the ZIP file, and tells me the compression ratios. The
minified CSS and JavaScript is still able to be reduced by around 50%,
which shows how important it is to get `Content-Encoding:gzip` working
on your web server.


  [269]: http://10k.aneventapart.com/Entry/269
  [10K Apart]: http://10k.aneventapart.com/
  [jigsawr.org]: http://jigsawr.org/
  [Closure Compiler]: http://code.google.com/closure/compiler/
  [1]: http://tools.w3clubs.com/cssmin/
  [JavaScriptCore]: http://webkit.org/projects/javascript/
  [Cssutils]: http://cthedot.de/cssutils/