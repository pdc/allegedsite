Title: Submit Picture page versus caching
Date: 20040624
Image: ../2003/picky-80x80.png
Topics:picky web

The [Picky Picky game][3] had a bug which mainly affected 
[Teacake][1] ([badasstronaut][2]): pictures submitted for the current
panel would instead turn up in last week's panel (the one being voted
on), or even once in the panel from the week before!

  [1]: http://www.teacake.comics.org.nz/ "Debra Boyask"
  [2]: http://www.livejournal.com/users/badasstronaut/ "Her LiveJournal"
  [3]: http://caption.org/picky/

I have tracked down the problem to the URL used for the submission
form, which *includes the panel number* for reasons more to do with
elegance than practicality.  As a result, if you are looking at an
out-of-date version of the picture form, it will submit the picture to
the wrong panel.

The HTML page containing the form is returned as a static page, and
should be cacheable in the usual way.  My guess as to why Debra's
seeing this problem is that perhaps her campus network is being
over-enthusiastic with its  caching.  

My fix for the problem is to allow the special panel number `current`,
which always means the current panel!