Title: Stories versus Tasks in the Land of the Agile
Date: 2012-04-06
Topics: kanbo agile

The current Kanbo prototype refers to the cards you drag around the board as ‘stories’, but depending on the flavour of agile development you are pursuing, it should instead have tasks, or even both stories and tasks.

The difference between stories and tasks is something it is possible to get
confused, especially as while most people know what task means, the way we use
the word ‘story’ is peculiar to software development. A _user story_ is rougly
the same as a _use case_ or a _feature_: it describes a change in the
behaviour of the system that the customer desires, from the point of view of
someone using it. A story is less formally described than a use case. It is
supposed to be a little more than a unique ID or short name and a one-
paragraph, (preferably one-sentence) description.  The name reflects the shift
to getting the customer to tell stories about how they imagine the system
working, instead of getting bogged down in formal requirements analysis.

Stories when scheduled are depomposed in to _engineering tasks_.  A given
story may give rise to several tasks. The difference between stories and tasks
is that stories are high-level, tasks are low-level; stories come from what
the user wants, tasks are things the developers are going do; stories are what
and why,  tasks are how and when.

This is expressed in the (ideal) form of words classically used to describe them. Stories should be expressibile in the following three-part form:

<table>
    <tr>
        <td>As a</td>
        <td style="border-bottom: 1px solid #000">&nbsp;</td>
        <td>, I want to</td>
        <td style="border-bottom: 1px solid #000">&nbsp;</td>
        <td>so that</td>
        <td style="border-bottom: 1px solid #000">&nbsp;</td>
        <td>.</td>
    </tr>
    <tr>
        <td></td>
        <td>(role or person)</td>
        <td></td>
        <td>(some action)</td>
        <td></td>
        <td>(benefit)</td>
        <td></td>
    </tr>
</table>

Although in practice it is probably snappier to say ‘Customers can search for
shoes by size and colour’ than ‘As a customer I want to search for shoes by
size and colour so that I may find whether they exist.’ But you do need to be
clear on who is interested in this new feature and why they care. It should
also be apparant how this new feature would be demonstrated to that person.

A task is simpler: classically a sentence in the imperative voice starting
with a verb. ‘Add search page’, ‘Index shoes by size and colour’, ‘Present
shoe list as a grid’.

While I’m at it, there is also *unplanned* work—bugs, glitches, and other
defects. Some people try to contort them in to the form of tasks or stories,
but I think they are most straightforwardly expressed as a statement of the
wrong situation (‘Search page shows error message when there are no search
results’, ‘Unpublished articles should not be listed on front page’).

In XP, the schedule is still expressed in terms of stories—liiterally a stack
of story cards with a rubber band around them—whereas in Scrum the task board
shows tasks, not stories. In Kanban there are no stories, only queues of
tasks, planned and unplanned (in other words,  development tasks mixed in with
maintenance tasks and defects). This is only confusing if you call tasks stories.

So how does this matter to Kanbo? If I want it to be applicable to a variety
of develpment styles, then it may be it needs to change whether the cards it
shuffles around are called stories or are called tasks. I may also need a
separate area where stories (or vague wants not yet specific
enough to make a story) can be looked after.
