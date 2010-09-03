Title: Jigsawr (3): Bookmarklet
Topics: bookmarklet jigsawr javascript
Date: 2010-09-03

I created an [SVG-powered jigsaw app][269] for the [10K Apart][]
contest.
Just for fun, here’s a bookmarklet you can use to create a jigsaw from any page.

<blockquote>
    <p>
        <a href="javascript:(function(){for(var c=document.images,d=0,e,a=0;a<c.length;++a){var b=c[a],f=b.width*b.height;if(f>d){d=f;e=b}}location=&quot;http://jigsawr.org/?u=&quot;+escape(e.src)+&quot;&amp;d=24&amp;j=1&quot;})();return false
">&rarr;Jigsawr</a>
    </p>
</blockquote>

Drag the above link on to your bookmark bar. Then, when you are visiting
the web page of an image you fancy, click the bookmarklet to create
jigsaw (it automatically chooses the largest image on the page).


  [269]: http://10k.aneventapart.com/Entry/269
  [10K Apart]: http://10k.aneventapart.com/