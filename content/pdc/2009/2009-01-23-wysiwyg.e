Date: 2009-01-23
Title: Drupal with Wysiwyg and Popups and TinyMCE
Topics: drupal wysiwyg debugging php
Image: ../2008/drupal-64x64.png

Our [Drupal][] site uses the [Popups module][] to show a form containing text areas that our client want to use a <abbr title="What you see is what you get">wysiwyg</abbr> editor. We are doing this using the [Wysiwyg module][], which in turn hooks in one of the popular rich-text editor packages, in our case [TinyMCE][]. With a little [additional effort][] we have managed to get TinyMCE to kick in and make the text areas wysiwygified—but only the first time the form is shown; subsequent pop-up forms have the Wysiwyg module’s additions, but not TinyMCE’s.

Bg
==

The usual format for a Drupal module is a bunch of PHP functions that are invoked by the system at particular points, each mutating some object just enough that the next function in the chain will know to do its thing. This tends to make working out how they work difficult: you have to debug each link of the chain, and the connection between links is sometimes obscure.

After a day poking through the PHP and JavaScript code of the Wysiwyg module I have managed to work out more or less how it is supposed to work. The tricky thing is that, like many modules, it prefers to work magically rather than through explicit activation: the way it determines whether a text are a needs the wysiwyg code applied to it is that the next form item is a list of input filters for the text area. Our form lacked this drop-list, having been designed with quite tight layout constraints (we are working to mock-ups supplied by the designers). So we had to add the form items and then arrange for the extra text to be hidden via CSS (and just to be more inconvenient, the paragraph they add does not have an `id` or `class` attribute). 

There are some more complications because the form is being shown via the popups module, which strips off the `script` elements added to handle the client side of the process; more jiggery-pokery was required to add the JavaScript to the host page instead of the pop-up form.

Once this was done it is possible to show the form and see a wysiwyg editor. Except if you dismiss the pop-up form and then invoke it a second time, the wysiwyg editor is not on show. 

Investigation
=====

Using FireBug I can step through the JavaScript for `wysiwyg.js`as it adds the Enable/Disable Rich Text button and then calls

    tinyMCE.execCommand('mceAddControl', true, params.field);

Presumably TinyMCE remembers something about the previous editor and knows better than to create a new editor with the same name. But if I try to verify this by stepping in to this function I end up in `tiny_mce.js`, which is 158K bytes of JavaScript all in one long line. This makes any more stepping in to things effectively impossible. 

I wasted a considerable period of time trying to get it to use `tiny_mce_src.js` instead. There is code in `wysiwyg.module` and `tinymce.inc` that appears to be intended to allow for different files to be swapped in if you set some setting somewhere but I can’t work out where this setting is set. I tried renaming `tiny_mce_src.js` to `tiny_mce.js` but something in the Wysiwyg module spots the change and infers wrongly that the editor has been uninstalled, and so does not activate the Wysiwyg JavaScript at all. Odd. I was only able to get things working again by reverting all the files (thank goodness we are  using [Subversion][] for the whole site).

So I had a look at the code and found that it does indeed check `tinyMCE.get(x)` when asked to create an editor, and if this returns anything it assumes there is no work to be done. Consulting the [TinyMCE documentation][1], I discover there is indeed a `mceRemoveControl` command that should have been called.

Fix
===

I optimistically tried adding a call to conditionally remove the control before adding it. This almost worked, but tends to crash on account of we are asking it to dismantle a bunch of HTML widgets that no longer exist (the HTML having been removed ages ago when the first pop-up form was dismissed).

The correct solution  is of course to add code to the behaviour-detaching function of the Wysiwyg module, since it is the attachment of the Wysiwyg behaviour that activates it. Sadly Drupal 6 lacks this feature, though it has been [added to Drupal 7][2].

In the meantime I added Wysiwyg-specific code to `popups.js` to fix our particular problem:

    Drupal.popups.removePopup = function() {
        /* Addition for bugs caused by removing TinyMCE editors  -- pdc 2009-02-13*/
        $('#popups textarea').each(function () {
            var id = this.id;
            if (tinyMCE && tinyMCE.get(id)) {
                tinyMCE.execCommand('mceRemoveControl', true, id);
            }
        });
        /* End of addition */

        $('#popups').remove();  
    };

This works for us but if we also used wysiwyg editors in forms loaded with the AHAH mechanism you might also need to modify `ahah.js`.

Another problem
===============

We discovered that under some circumstances you could edit text in the wysiwyg editor in the pop-up form, but the changes would not be made when you clicked the Save button—but only on one particular web browser. After some investigation we realized that there was another point where the popups module needs to talk to the edtior—before saving the form, it needs to tell TinyMCE to save the text from its widgets to the hidden form element which is used to carry the text in to the form submission. Fixing this again required finding a place in the Popups module to add some TinyMCE-specific code.

Lessons
=======

The problem we had is that making it possible to layer different user-interface enhancements on top of each other is harder than it looks. To fix the Wysiwyg module, we made changes to the Popups module. This only works because we use a particular combination of features of these two modules. The correct *general* solution will be to augment the API used by Drupal’s modules to add yet more hooks for module developers to attach functions to. 

The general code will also naturally be longer and more complicated because it has to take notice of the requirement that TinyMCE be swappable with another rich-text editor, which means that the API used internally within the Wysiwyg module to communicate with the editor plug-ins will also need to be further elaborated.

If, instead, we had developed the whole site ourselves—using TinyMCE and jQuery as our JavaScript platform and writing the HTML ourselves rather than assembling it from the outputs of eleventy-one themeing functions—the overall quantity of JavaScript would be smaller, at the cost of having to write it ourselves instead of just plug modules together.


  [Drupal]: http://drupal.org/
  [Popups module]: http://drupal.org/project/popups
  [Wysiwyg module]: http://drupal.org/project/wysiwyg
  [TinyMCE]: http://tinymce.moxiecode.com/
  [additional effort]: http://drupal.org/node/356480
  [Subversion]: http://subversion.tigris.org/
  [1]: http://wiki.moxiecode.com/index.php/TinyMCE:Commands
  [2]: http://drupal.org/node/316225