Title: Without Writing a Single Line of Code
Date: 2009-08-08
Topics: programming drupal rant
Image: ../icon-64x64.png

I am beginning to get a sinking feeling whenever I hear yet another person demonstrating how they can ‘just slap some controls on a form’ to make an almost-working app in minutes, and concluding ‘and all without writing a single line of code’!  

Just Slapping
-------------

Partly this is because in the just-slapped-together application has been implemented by hundreds of lines of auto-generated code, which some more qualified programmer will later have to maintain. Partly it is because of the implication that writing code is so odious an activity that any alternative, no matter how unwieldy, is preferable.


The ideal just-slap system can be illustrated in a [NeXTSTEP Release Demo][1] by Steve Jobs in 1991. (I would embed the video, but I can’t fugure out how to combine skipping to [23:11][1] with embedding in my page.) To make this work the NeXTSTEP system has a  programming environment using loosely coupled objects that exchange dynamically-typed messages, and he restricts the demo to one that selects data from a pre-existing database and displays it in the simplest possible way. You would expect to be required to write the occasional single line of code should you want to manipulate the data in some interesting way.

Not Writing a Line of Code with Drupal
--------------------------------------

Jumping forward eighteen years, and I find I have spent most of a working day ‘not writing a single line of code’ and it is incredibly frustrating. The particular application is web-based store, using [Drupal][2]’s [e-Commerce module][3]. Pretty simple conceptually—an order (or ‘transaction’) is a list of products and quantities, and has a state (’workflow’) that might be `invoiced` or `in picking`, say, depending on how far the shop-keeper has got with fulfilling the order. As an example of data manipulation that can be expressed easily in code, 
we want to skip the shipping step when the product is a file download:

    if order.is_paid():
        if order.needs_shipping():
            new_state = IN_PICKING
        else:
            new_state = COMPLETE

To save me the trouble of writing a few lines like the above, we can use the point-and-click web interface. First we need two _actions_ to change the state of the order. So the e-Commerce module has the Actions module as a dependency. Click on Administer, wait for the list to be generated, then Site configuration, wait again, then Actions, choose ‘Change transaction workflow’, click Create, wait, click the label field and type in ‘Mark as in picking’, select ‘in picking', click Create. Now again for the ‘complete’ state: click, click, click, wait, click, type, click, click, wait. Now we need to set up a rule. Again there is a module for this. Click ’Site configuration’, wait, then rules, click on a tab, click, click, select, click, click, wait, click, and so on _ad infinutum_.

It takes longer to do all this pointing and clicking than it does for me
to write a few lines of code. Of course, you need to know things to
write code—transferrable knowledge like assignment, function calls,
conditional statements, and so on. But the point-and-click version also
requires knowledge to perform, and in this case it is Drupal-specific
knowledge: you need to know the ins and outs of the Actions, Rules,
Chaos Tools, and Token modules, in addition to the half-dozen or so
e-Commerce modules.

What the point-and-click system saves you from is working out the
architecture yourself by imposing one. It means a person who is not
capable of programming but is nevertheless capable of grasping the
interplay of rules, actions and the rest can configure an e-commerce
site. It is the intellectual equivalent of a crutch, which will allow
allow the lame to walk, but will only slow down an able-bodied person. (Except that I am rather arrogantly implying that anyone who doesn’t have several years’ serious programming experience is lame.)

The other downside of the just-slap systems is the code size. The five lines of code above are replaced with Drupal modules that know how to represent a rule as rows in a database table, which is itself specified in more code, and entails more code to represent the web forms used to manipulate rules, and more code to fit them in to the various modules that provide conditions and events for the rules to be triggered by. The upshot of which is that we increased the size of the codebase by thousands of lines when we added the e-commerce modules. That’s a lot of code to hide bugs in.

It Gets Worse
-------------

The other potential problem can be illustrated with what I got up to yesterday. The request was that, when the ‘Add to cart’ button is hidden because the user is not logged in, could we show a message explaining this. Again, in a hypothetical Django-style template this would mean taking something like this

    …
    {% if user.is_authenticated %}
        <button class="add-to-cart" … etc … >
    {% endif %}
    …

and changing it to

    …
    {% if user.is_authenticated %}
        <button class="add-to-cart" … etc … >
    {% else %}
        <span>Please log in or register to purchase this item.</span>
    {% endif %}
    …

This is literally a single line of code. What is the Drupal equivalent?
The list of items is a Views-module view, so we want to edit the view,
which you do by visiting the page and scrubbing the mouse over the title
of the page until a translucent ‘Edit’ link appears, then click that,
then in the gigantic intimidating form that appears you click the little
cog icon next to ‘Row style’, and in the form that appears there you
look for the checkbox that makes the message appear and discover there
isn’t one. So now the next thing to do is to create a new module with a
`hook_view_field_info` implementation to tell it about a new field, and
some sort of `hook_view_field_get_value` or whatever to supply its value
and so on. This is all in reference to the View module’s API, which I
have not yet learned, so it’s another hour reading through web pages on
some site somewhere to learn the parameters these hook functions require
and what order they are called in.  The result is, what, 100 lines of PHP code so that I can do something by ticking a checkbox.

I should stress this sort of problem is not specific to Drupal; I just happen to be working on a Drupal site this week. I have had the same problem with ASP.NET, where implementing a control that can be just-slapped on to a page is a huge pile of extra work compared with just reading parameters out of a form and updating the damn’ database.

I should also admit that I did not implement the module I just described
but instead switched the view to use the Node row-style instead of the
Fields row-style, and then spent the rest of the afternoon redesigning
the CSS to work with the completely different HTML code that results. Once this was done, the `hook_link` implementation supplies the message we wanted.

Aside on Hook-Oriented Programming
----------------------------------

The next request I have had is for special behaviour in the checkout when the user has chosen a particular type of product and a particular type of payment. I am a little at a loss here, because after spending a few hours looking through the source code I have yet to work out which of the half-dozen or so e-Commerce sub-modules will have a hook that is called at the right time to make the necessary change. 

The problem is that the structure of a Drupal system is not expressed in the code: the hook functions are just functions with funny names. Various other functions to call them at the right time, but without knowing when hooks are called, you can only make guesses as to what their purpose is.

I wonder if it would be possible to come up with a notation or a diagramming convention that sums up the interactions of a set of hooks in a way that would be useful. Perhaps like a state diagram, except with the nodes labelled with a hook and the arcs between nodes labelled with the state change or event that causes the hook to be called.  Displaying the life-cycle of `hook_node_info`, `hook_load`, `hook_form`, `hook_update`, `hook_view` etc. would be quite instructive. It would also make getting up to speed on third-party modules that add new hooks a lot easier.

Less code
--------

There is (was?) a ‘[Less code][4]’ movement dedicated to bemoaning the fact that there is an increased burden of complexity being imposed on programmers in order, supposedly, to save them from themselves.  




  [1]: http://www.youtube.com/watch?v=j02b8Fuz73A#t=23m11s
  [2]: http://drupal.org/
  [3]: http://drupal.org/project/ecommerce
  [4]: http://lesscode.org/