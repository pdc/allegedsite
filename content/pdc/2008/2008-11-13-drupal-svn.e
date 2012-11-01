Title: Drupal Versus Your Source Code Control System
Image: drupal-64x64.png
Topics: drupal
Date: 2008-11-13

[Drupal][] is provided as PHP source code that is copied directly on to your web server, and if, like us, you develop extra modules to extend Drupal, they slot neatly in to the Drupal directory structure. If you want to co-ordinate your team using a source-code control system like [Subversion][] or you need to plan ahead to allow for Drupal upgrades to be achieved without clobbering your changes.

Why You Need a Process
=======================

Our original approach was to commit ourselves to not modifying the Drupal core, but to rely on the extension [hooks][] built in to the system. This works up to a point, but does not account for two problems we encountered. First, our customers wanted changes to the way Drupal formats parts of the page that could not be accomplished  through overriding [theme functions][], so we had to change core code. Second, bugs in the core needed repair faster than could be done by submitting a patch and waiting for the next version to come out.

This leaves us with a patches in the core code that will be clobbered when we upgrade Drupal itself (which you need to do when they release security fixes). To manage this you need to plan ahead slightly and set up a branch in Subversion that is reserved for Drupal upgrades. 

The Process
===========

Assuming your first check-in of code includes a pristine core, then the branch should come from Revision 1. This branch stands in for the development process of the Drupal project and the third-party modules’ development projects.

When a new upgrade for Drupal is released, you must get a working copy of the branch, unpack the revised source code in to it and commit the change. This makes a non-functioning version of the code (since the core may have changed in ways that stop your changes from working). Don’t do as I did at first, and attempt to get this branch in to a state where it can run the site.

Now begin the web site updating process: put the site in to maintenance mode, back up your database, and so on. Where it says ‘install the new code’, you merge the branch in to the trunk of the repository. At this point there may be conflicts with changes you have made to core, which must be resolved by eye. Now carry on with the upgrade process and, when everything is running smoothly again, check in the changes. Done!

The upgrade branch remains in the repository and will be reused next time you upgrade Drupal.

Adding Modules
==============

So far so good. The trick that has caught us out, and which I hope my readers can avoid, is that when you add third-party modules to Drupal, you *add them on the upgrade branch* and then merge them in to the trunk.  

If instead you do the natural thing 
and add the module to the tree in the same commit as you make the changes to the source code that depend on that module, you 
will make future upgrades of that module more complicated to achieve than anything you can imagine. When Drupal 6.5 came out I spent hours working out how I could branch the repository in order to insert changes to the Advanced Forums module *after* the module has been added to our source three and *before* changes to the module had been introduced by us.  It didn’t help that one of the functions we had modified was one where the authors of the module had renamed one of the function parameters …

Conclusion
==========

The merging and branching features of your revision control-system can be used to track changes to your upstream libraries, but only if you are organized in your head when you set up the repository at the start.


  [Drupal]: http://drupal.org/
  [Subversion]: http://subversion.tigris.org/
  [hooks]: http://api.drupal.org/api/group/hooks/6
  [theme functions]: http://api.drupal.org/api/group/themeable/6