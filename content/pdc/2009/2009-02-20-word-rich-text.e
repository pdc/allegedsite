Title: Pasting from Microsoft Word 2003 in to a Rich-Text Editor on a Drupal Web Page, part 1
Date: 2009-02-20
Icon: ../2008/drupal-64x64.png

How hard can it be? Objective is to enable punters to paste text from Microsoft word in to a Rich-Text Editor in a web page and have the results appear in a forum post, resource comment, blog entry, or news article as expected. And yes, this site has forum posts, blog entries, news articles *and* comments.

> **Note.**
> *A draft version of this article escaped on to the site before I had 
> finished it. Sorry for the confusion.*

How it is Supposed to Work and Doesn’t
--------------------------------------

When someone is editing a blog entry (say) they see a rich-text editor (also called a <abbr title="what you see is what you get">wysiwyg</abbr> editor) with a super-simple button bar with only Bold, Italic, Bullet List and Numbered List buttons. Being school teachers, they naturally use Microsoft Word to compose their response, and copy and paste text in to the text field on the web page. When they submit the form, they expect the resulting blog entry to have at least a passing resemblance to the Word document.

<div class="wide_photo_left"><img src="word-to-HTML-1.png" alt="(diagram)" /></div>

Behind the scenes, this works by Word creating a variety of representations of the  document on the system clipboard, one of which the rich-text
widget in the web page copies in to its own data structures. When the form is submitted, the  widget creates an HTML representation of its data structures. The [TinyMCE][] code managing the editor might then munge the HTML to try to repair defective HTML from the rich-text widget. This HTML is sumbitted as part of the form and stored in the [Drupal][] database. Then Drupal starts assembling the HTML of the blog-entry page; it takes the HTML from the databased  and runs it though so-called **input filters** before adding it to the HTML of the page. The purpose of the filters is to

-  repair the HTML if it is not well-formed, 
- strip out tags that are not on its list of safe tags, and 
- suppresses rude words (because school teachers cannot be trusted to use language, apparently).

So by the time the blogger reads their new entry, the HTML has been processed by several different pieces of  software, and should be pretty much perfect, yes?

Sadly no. While everything looks OK in the editor, when you click the Save button, the blog entry (or comment etc.) has a large swathe of apparent gibberish added to the start


So, can we fix it?


Word 2003
----------------------------

We start out by finding out exactly what HTML code ends up in the database.

I created a new document in Microsoft Word 2003 and added a paragraph, a bulleted list, and a numbered list, with four items in each list and extra paragraphs before and after the lists. In the first paragraph I also added some bold, italic, bold italic, coloured, and fonitifed text. As an experiment in nesting I added some bold text, selected a range that overlapped the bold text and italicized that  (**bold** ***bold italic*** *italic*), to see whether the tags get correctly nested.

When I paste this in to a rich-text control created via TinyMCE 3 running in a page in Firefox, the HTML code I get back starts like this:

    <!--[if gte mso 9]><xml>
     <w:WordDocument>
      … more pseudo-XML  …
     </w:WordDocument>
    </xml><![endif]-->
    <!--[if gte mso 9]><xml> … </xml><![endif]-->
    <!--[if !mso]>
     <object
      classid="clsid:38481807-CA0E-42D2-BF39-B33AF135CC4D"
      id=ieooui></object>
    <style>
     st1\:*{behavior:url(#ieooui) }
    </style>
    <![endif]-->
    <p>
     &lt;!--
      /* Font Definitions */
      @font-face { … }
      … more pseudo-CSS …
     --&gt;
    </p>
    <!--[if gte mso 10]>
     <style> … more CSS … </style>
    <![endif]-->

Note that I have clipped out a great deal of code, represented by ellipses (…) in the above.

This is mostly an wrapped in Microsoft's [conditional comments][2] syntax. For example the the first and second ones apply to Microsoft Office (`mso`) version 9 and later. The `xml` element is a container for something that *resembles* XML but since it lacks namespace declarations it really only fits in with XML circa 1997 when namespaces had not been invented. There is an `object` element added to non-mso readers (e.g., Internet Explorer), presumably using ActiveX to add [behaviours][3] to IE to make it act more like Word. (Behaviours are what make allowing users to add their own CSS  a security risk, by the way.)

Then there is a curious thing, which is a series of clauses resembling CSS rules, but rather than living in a `style` element, they go in a comment. But the comment marker `<!--` has been escaped as `&lt;!--`. This means that the HTML as we see it here will include those font definitions as visible text, causing the problem we are investigating; and indeed there are [examples of this][1] in published documents on-line.

The main thing about this preamble is that we need to recognize it and strip it off, regardless of whether the comment indicator has been escaped&mdash;but not in a way that breaks documents where someone mentions `<!--` in that document…!

What about the HTML representation of our text? It’s not bad as these things go:

	<p class="MsoNormal">First par (Microsoft Word 2003).
	 <strong>Bold</strong>. <em>Italic</em>. 
	 <strong><em>Bold Italic</em></strong>. 
	 <span style="color: red;">Red</span>. 
	 <span style="background: yellow none repeat scroll 0% 0%;">Yellow bg</span>. 
	 <span style="text-decoration: underline;">Underlined</span>.
	 <strong>Bold <em>italic</em></strong><em> italic</em>
	 Normal (Times). 
	 <span style="font-family: Arial;">Arial. </span>
	 <span style="font-family: Corbel;">Corbel. </span>
	 <span style="font-family: &quot;Bodoni MT Black&quot;;">Bodoni</span>
	 <span style="font-family: &quot;Bodoni MT Black&quot;;"> MT</span>
	 <span style="font-family: &quot;Bodoni MT Black&quot;;"> Black.</span>
	</p>

All in all this is OK. The overlapping bold and italic ranges have been turned in to non-overlapping elements. I might quibble that it uses a `span` to get underlining rather than `<u>`…`</u>` but I realize that a lot of people have a superstitious dread of the `u`, `b`, and `i` tags.

	<p class="MsoNormal">Before UL</p>

	<ul style="margin-top: 0cm;" type="disc"><li class="MsoNormal">Item
	     1</li><li class="MsoNormal">Item 
	     2</li><li class="MsoNormal">Item
	     3</li><li class="MsoNormal">Item
	     4</li></ul>

	<p class="MsoNormal">After UL</p>

	<p class="MsoNormal">Another Par</p>

	<p class="MsoNormal">Before OL</p>

	<ol style="margin-top: 0cm;" type="1"><li class="MsoNormal">Item
	     1</li><li class="MsoNormal">Item
	     2</li><li class="MsoNormal">Item
	     3</li><li class="MsoNormal">Item
	     4</li></ol>

	<p class="MsoNormal">After OL</p>

Apart from the extra classes this is fairly clean HTML. The layout of the `UL` and `LI` elements is a little odd but that is small potatoes.

The upshot of this is that the biggest problem is that escaped comment character and the hidden data (which is only a problem in as much as it wastes both database space and bandwidth by adding several kilobytes of data unnecessarily).

Can’t we Fix it with a Filter?
--------

Can’t we just add another filter to munge the bad comment markers? No, because the HTML in the database is what is passed to the rich-text editor widget when the user edits the page. The broken comment marker means the CSS-like code becomes visible in the wysiwyg editor.  So we need to fix it *before* the HTML is stored in the database.

You may be wondering why input filters are applied during the *output* phase in the first place: would it not be better to perform their checks once when the page is saved, rather than every time the page is viewed? There are two main reasons:

1. The person editing the page expects the text they write to remain the same when they go back to edit it; and 

2. It is also safer to leave the underlying text unaltered: the filters might get it wrong, in which case you fix the filter, and then the page is displayed correctly.

Because the site design makes the wysiwyg editor mandatory—we were instructed to remove the button for toggling between HTML and wysiwyg modes—the first reason does not really apply: so long as the HTML we store will be displayed identically when they edit next, that will be good enough. As for safety, well, all we can do is make sure that our changes are carefully thought out and won’t need to be reversed!

Coming Soon
-----------

Next part: A solution for munging HTML as it is saved to the database.

  [1]: http://www.google.co.uk/search?rlz=1C1GGLS_en-GBGB291GB304&sourceid=chrome&ie=UTF-8&q="/*+Font+Definitions+*/"
  [2]: http://msdn.microsoft.com/en-us/library/ms537512(VS.85).aspx
  [3]: http://msdn.microsoft.com/en-us/library/ms531078(vs.85).aspx
  [Drupal]: http://drupal.org/
  [TinyMCE]: http://tinymce.moxiecode.com/
  [hook_nodeapi]: http://api.drupal.org/api/function/hook_nodeapi/6