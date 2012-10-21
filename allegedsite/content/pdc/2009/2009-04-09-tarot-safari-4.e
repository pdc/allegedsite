Title: SVG Tarot in Safari 4
Date: 2009-04-09
Icon: ../tarot/xviii-moon-64x64.png
Topics: svg tarot safari

I created the [Alleged Tarot][1] in 2002 using SVG, which I was confident at the time was the next big thing in web graphics. Seventy thousand years later, I notice that [Safari 4][3] supports SMIL-style animations in SVG, which means that the commentary and animations I incorporated in to the card designs now work again for the first time since Adobe abandoned their SVG Viewer plug-in.

<blockquote><div><embed type="image/svg+xml" src="http://www.alleged.org.uk/pdc/tarot/xiiii-temperance-card3.svgz"
width="400" height="580" /></div></blockquote>

Click on the little orange square to see my insightful analysis of the symbolism of the card.

Also see! the custom font I created for the card titles on the left-hand side also works. Spiffy.

If you are using Microsoft Windows, don’t feel left out—you can [install Safari on Windows][2].

Update
------

The current state of play seems to be as follows:

<table>
	<thead>
		<tr valign="bottom"><th>Browser</th><th>SVG</th><th>SVG fonts</th><th>SVG animation</th></tr>
	</thead>
	<tbody>
		<tr valign="baseline">
			<td>Chrome 1</td>
			<td class="yes">Yes</td>
			<td class="yes">Yes</td>
			<td>No</td>
		</tr>
		<tr valign="baseline">
			<td>Firefox 3</td>
			<td class="yes">Yes</td>
			<td>No</td>
			<td>No</td>
		</tr>
		<tr valign="baseline">
			<td>Internet Explorer 8</td>
			<td>No</td>
			<td>No</td>
			<td>No</td>
		</tr>
		<tr valign="baseline">
			<td>Opera 9</td>
			<td class="yes">Yes</td>
			<td class="yes">Yes</td>
			<td class="yes">Yes</td>
		</tr>
		<tr valign="baseline">
			<td>Safari 3.2</td>
			<td class="yes">Yes</td>
			<td class="yes">Yes</td>
			<td>No</td>
		</tr>
		<tr valign="baseline">
			<td>Safari 4</td>
			<td class="yes">Yes</td>
			<td class="yes">Yes</td>
			<td class="yes">Yes</td>
		</tr>
	</tbody>
</table>

Neither Internet Explorer 6, 7, nor 8 support SVG in any way, except via a plug-in, such as Adobe’s SVG Viewer, which is now officially discontinued. At the other end of the scale, Opera have been quietly supporting SVG well for years now.
		
New versions of some browsers are already being tested:

<table>
	<thead>
		<tr valign="bottom"><th>Browser</th><th>SVG fonts</th><th>SVG animation</th></tr>
	</thead>
	<tbody>
		<tr valign="baseline">
			<td>Chrome next</td>
			<td class="yes">Yes</td>
			<td class="yes"><a href="http://twitter.com/codedread/status/1482987202">Yes</a></td>
		</tr>
		<tr valign="baseline">
			<td>Firefox next</td>
			<td><a href="https://bugzilla.mozilla.org/show_bug.cgi?id=119490">Bug 119490</a></td>
			<td><a href="https://bugzilla.mozilla.org/show_bug.cgi?id=216462">Bug 216462</a></td>
		</tr>
	</tbody>
</table>

You can get a more thorough breakdown at the [When Can I Use][4] page.

  [1]: ../tarot
  [2]: http://www.apple.com/safari/download/
  [3]: http://www.apple.com/safari/
  [4]: http://a.deveria.com/caniuse/#agents=All&eras=All&cats=SVG&statuses=rec,cr,wd,ietf