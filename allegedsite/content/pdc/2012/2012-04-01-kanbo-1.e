Title: Kanbo: A Sortable Task Grid
Topics: kanbo django
Date: 2012-04-01

Today is the traditional date for announcing improbable projects and absurd
collaborations, so here’s mine. [Kanbo][] is a task board based vaguely on the
boards used in agle-development approaches like [Scrum][] and [Kanban][] (and
variations with names like Scrum-ban, Lean, Agile, and what-have-you).

To illustrate the concept, here’s what Kanbo looks like today:

<div class="image-full-width">
    <a href="kanbo-wip-1.png"><img src="kanbo-wip-1-540w.png" /></a>
</div>

The cards represent tasks; the columns tell us how far we’ve
got with them. Ideally the grid is a real notice board, with actual
cards (or sticky notes). When you complete a task you get to march
over to the board, pluck the card out of the ‘in progress’ column and
add it to the ‘completed’ column. Daily stand-up meetings can be held around the board.

What if a real board is not practicable? If some team members do not
always work in the same site, say?  The Kanbo vision is to be as good an
electronic substitute for a real board as  can be achieved with a web
app. For example, you drag stories out of columns and drop them in to
new ones to move them on. I plan to add automatic updating so
collaborators in different offices can see each other‘s changes to a
shared board immediately.

The other way my grid tries to be realistic is that you can also drag
tasks about to change the order they are displayed in. Some
flavours of agile development, require this: the
backlog is a queue of tasks, not list a list. Making cards
remember what order you left them in comes naturally with a real board
but is surprisingly tricky to get right with a web app. I plan to
write another article about the way I approached this: my method  is
probably not novel, but it was new to me.

For now Kanbo is merely a proof of concept: it will need a lot of
features added to be useful on real projects. I am doing this as an occasional weekend project, so progress will be upredictable. Who knows, I might get
as far as implementing interoperability with your favourite issue
tracker and charge for hosting and make a mint!



  [Kanbo]: http://kanbo.me.uk/
  [Scrum]: http://en.wikipedia.org/wiki/Scrum_(development)
  [Kanban]: http://en.wikipedia.org/wiki/Kanban_(development)
  [Extreme Programming]: http://c2.com/cgi/wiki?ExtremeProgramming