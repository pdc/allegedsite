Date: 2012-12-18
Title: Morseless and Progressive Enhancement
Topics: web morseless

I created a miniature web app for decoding Morse code called [Morseless][2]
for the fun of it yesterday. It makes for a nice little case study in
progressive enhancement.

## Progressive

Wikipedia has this to say on the subject of progressive enhancement:

>  [Progressive enhancement][1] uses web technologies in a layered fashion
>  that allows everyone to access the basic content and functionality of a
>  web page, using any browser or Internet connection, while also providing
>  an enhanced version of the page to those with more advanced browser
>  software or greater bandwidth.

It fits with the agile development strategy of making the simplest possible
version of your app first, then enhancing it in rapid iterations.

The trick is that what the ‘simplest’ version of a site is might be a little
less obvious what is simple. As a concrete illustration, here’s the first
version of Morseless:

<div class="image-full-width">
    <a href="morseless-1-anim.gif">
        <img src="morseless-1-anim.gif" width="540" height="250" alt="(screenshot)" />
    </a>
</div>

There is a form at the bottom of the page in to which you can enter some Morse
code text and a button to press to show the same page again except with the
decoded text displayed in the box at the top.

This app is using HTML features
that worked just as well in 1997 as in 2012, which means it should work in
practically any web browser, even old ones or locked-down browsers with
JavaScript disabled for security reasons, or specialised browsers for people
with sensory disabilities.

But I wanted to make the user experience slicker by showing the decoded text
as you type it in, or after you copy & paste code in from another page:

<div class="image-full-width">
    <img src="morseless-3.png" width="540" height="135" alt="(screenshot)" />
</div>

The first version of the site is still there,  with the spiffy new user
interface (conceptually) layered on top of it: the JavaScript code starts
by removing the elements that no longer needed (such as the Decode button) and
adding some others (like the field labelled Text). So people without
JavaScript will see the old UI, which is not as nice but at least  works.

## Scheduling

In the context of agile development it makes sense to split this two versions in to separate user stories:

1. User can enter Morse and see text
2. User sees text as they type Morse

Then, if time were running short, if necessary the second story could be
jettisoned or deferred in order to make the deadline. The result will not be
as nice, but at least the site is usable. Trying to get the whole Ajaxified
user interface to work in one go might instead lead to failure to have either
version done in time.

## Conclusion

In this little case the difference is moot, of course, but in a larger
application there will be lots of features that can be split up like this. And
JavaScript is just one feature; the HTML5 movement has created a lot of new
glitzy features, of which different web browsers have implemented different
subsets. Progressive enhancement (and some approach to JavaScript modularity)
is the key to enabling the most spiffy user experience to as many people as
possible without neglecting the essentials.

  [1]: http://en.wikipedia.org/wiki/Progressive_enhancement
  [2]: http://morseless.me.uk/
