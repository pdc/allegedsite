Title: Grouping, or, Trying to Say Something Nice About PHP
Date: 2009-06-14
Icon: ../icon-64x64.png
Topics: php

A fairly common requirement on a database-backed website (say) is to read in tabular information and turn it in to a hierarchy. Without a little bit of planning it is easy to let the code for this get obscure and difficult to read. PHP has features that should be used to keep grouping clear.

Scenario
========

Suppose you have acts containing scenes containing lines in your database; in a relational database, when you read back the contents of one book, say, you get tabular data (a sequence of rows) like this:

<table>
	<thead>
		<tr><th>act</th><th>sc</th><th>ln</th><th>text</th></tr>
	</thead>
	<tbody>
		<tr><td>1</td><td>1</td><td>1</td><td>Orl. As I remember it, Adam, it was upon this fashion</td></tr>
		<tr><td>1</td><td>1</td><td>2</td><td>bequeathed me by will but poor a thousand crowns,</td></tr>
		<tr><td>1</td><td>1</td><td>3</td><td>and, as thou sayst, charged my brother on his bles-</td></tr>
		<tr><td colspan="4" align="center">…</td></tr>
		<tr><td>5</td><td>4</td><td>218</td><td>as many as have good beards, or good faces, or</td></tr>
		<tr><td>5</td><td>4</td><td>219</td><td>sweet breaths, will for my kind offer, when I make</td></tr>
		<tr><td>5</td><td>4</td><td>220</td><td>curtsy, bid me farewell.</td></tr>		
	</tbody>
</table>

You want to generate HTML that starts a new section for each act and scene, starting something like this:

    <div class="act">
		<h1 id="act1">Act 1</h1>
		<div class="scene">
			<h2 id="scene1.1">Scene 1</h2>
			<p>Orl. As I remember it, Adam, it was upon this fashion</p>
			<p>bequeathed me by will but poor a thousand crowns,</p>
			<p>and, as thou sayst, charged my brother on his bles-</p>

This admittedly is not the best way to format a play, but it will do for this example.

Conventional Algorithm
======================

The normal approach is probably something like this:

	$prev_act = NULL;
	$prev_sc = NULL;
	while ($row = db_fetch_object($cursor)) {
		if ($prev_act != $row->act || $prev_sc != $row->sc) {
			if (isset($prev_sc)) {
				echo '<p>(End of scene ' . $prev_sc . ')</p>';
				echo '</div>';
			}
		}
		if ($prev_act != $row->act) {
			if (isset($prev_act)) {
				echo '<p>(End of Act ' . $prev_act . ')</p>';
				echo '</div>'; 
			}
			echo '<div class="act">';
			echo '<h2 id="act' . $row->act . '">Act' . $row->act . '</h1>';
			$prev_act = $row->act;
			$prev_sc = NULL;
		}
		if ($prev_sc != $row->sc) {
			echo '<div class="scene">';
			echo '<h2 id="scene' . $row->act . '.' . $row->sc 
				. '">Scene ' . $row->sc . '</h2>';
			$prev_sc = $row->sc;
		}
		echo '<p>' . $row->text . '</p>';
	}

This slightly elaborate code is required to make sure the code for ending a group appears in only one place. The first `if` closes any open scene, the second `if` both closes an open act and opens the new one, and the third `if` opens the new scene. If there were another layer of grouping, there would be five `if` statements.

This works, and it avoids repeating the code for closing or opening sections, but they nevertheless appear out of order, and this makes  it tricky  working out exactly what is going on when reading it. If the HTML code were particularly elaborate or required further processing, this scrambling of the order would be even more of a problem.

PHP’s Magic Grouping
====================

The PHP language has some weird semantics for things like missing declarations, but this is one situation where they actually add up to a useful feature. Here’s a neater way to do the above loop in two steps:

	while ($row = db_fetch_object($cursor)) {
		$lsss[$row->act][$row->sc][] = $row->text;
	}
	for ($lsss as $act => $lss) {
		echo '<div class="act">';
		echo '<h2 id="act' . $act . '">Act' . $act . '</h1>';
		for ($lss as $sc => $ls) {	
			echo '<div class="scene">';
			echo '<h2 id="scene' . $act . '.' . $sc 
				. '">Scene ' . $sc . '</h2>';
			for ($ls as $l) {
				echo '<p>' . $l . '</p>';
			}
			echo '<p>(End of scene ' . $sc . ')</p>';
			echo '</div>';
		}
		echo '<p>(End of Act ' . $prev_act . ')</p>';
		echo '</div>'; 
	}

The first loop uses PHP’s magical behaviour to create nested arrays—a list of acts, each containing a list of scenes, each containing a list of lines. This means the following  nested `for` loops match the structure of the information as it will be presented on the page. The parts which spurt out HTML code are now in the correct order, and it is a lot easier to see when each chunk of HTML code is being generated.

Other Languages
===============

In the Python language, the equivalent of PHP’s 

	while ($row = db_fetch_object($cursor)) {
		$lsss[$row->act][$row->sc][] = $row->text;
	}
	
would be something like the following:

	lsss = {}
	for act, sc, ln, text in cursor.fetchall():
		lsss.setdefault(act, {}).setdefault(sc, []).append(text)

With C#, there are three obvious routes to try, First, using the dictionary method `TryGetValue`  to get the effect of `setdefault`:

	var lsss = new Dictionary<int, Dictionary<int, List<string>>>;
	while (reader.Read()) {
		int act = reader.GetInt32(0);
		int sc = reader.GetInt32(1);
		string text = reader.GetString(2);
		Dictionary<int, List<string>> lss = null;
		if (!lsss.TryGetValue(act, out lss)) {
			lsss.Add(act, lss = new Dictionary<int, List<string>>());
		}
		List<string> ls = null;
		if (!lss.TryGetValue(sc, out ls)) {
			lss.Add(sc, ls = new List<string>());
		}
		ls.Add(text);
	}

Second, you could revert to using the changes in `act` and `sc` to control whether you add a new dictionary or not, which is probably more efficient, but is even more long-winded:

	var lsss = new Dictionary<int, Dictionary<int, List<string>>>;
	Dictionary<int, List<string>> lss = null;
 	List<string> ls = null;
	int prev_act = 0, prev_sc = 0;
	while (reader.Read()) {
		int act = reader.GetInt32(0);
		int sc = reader.GetInt32(1);
		string text = reader.GetString(2);
		if (act != prev_act) {
			lsss.Add(act, lss = new Dictionary<int, List<string>>());
			prev_act = act;
			prev_sc = 0;
		}
		if (sc != prev_sc) {
			lss.Add(sc, ls = new List<string>());
			prev_sc = sc;
		}
		ls.Add(text);
	}

Third, you could see whether LINQ’s `group–by` operator can do the job for you. I haven’t had enough practice with LINQ to write the code properly here without a C# compiler to check the syntax, but you can see something similar on [Microsoft’s 101 LINQ Samples page][2]. It is much shorter than the explicit code above, though obviously it is impossible to match the brevity of PHP’s two-liner.

Why I am Writing This
=====================

I spent a few days disentangling some code that generated [RTF][3] using similar code to my ‘Conventional Algorithm’ above, except with a lot of copy-and-paste code that made it even harder to follow. For example, instead of this fragment (taken from the above code):

	if ($prev_act != $row->act) {
		if (isset($prev_act)) {
			echo '<p>(End of Act ' . $prev_act . ')</p>';
			echo '</div>'; 
		}
		echo '<div class="act">';
		echo '<h2 id="act' . $row->act . '">Act' . $row->act . '</h1>';
		$prev_act = $row->act;
		$prev_sc = NULL;
	}
		
you can write this:

	if (!isset($prev_act)) {
		echo '<div class="act">';
		echo '<h2 id="act' . $row->act . '">Act' . $row->act . '</h1>';
		$prev_act = $row->act;
	} elseif ($prev_act != $row->act) {
		echo '<p>(End of Act ' . $prev_act . ')</p>';
		echo '</div>'; 
		echo '<div class="act">';
		echo '<h2 id="act' . $row->act . '">Act' . $row->act . '</h1>';
		$prev_act = $row->act;
		$prev_sc = NULL;
	}

Now imagine that the `echo` statements are each replaced by several identical (or almost-identical) lines of RTF gobbledegook, and you can see that understanding the grouping code enough to make changes to the RTF was a bit of a mind-bender.

Moral
=====

So the moral of the story is, when you need to group data from a database to match the structure of your template, separate the grouping step from the template step. The person who has to maintain your code six months later will thank you,


  [1]: http://www.python.org/dev/peps/pep-0020/
  [2]: http://msdn.microsoft.com/en-us/vcsharp/aa336754.aspx#nested
  [3]: http://en.wikipedia.org/wiki/Rich_Text_Format
		

	





