Title: Sorting Algorithms and Books
Topics: programming 

I volunteer at a charity bookshop one afternoon a week, and this has given me
opportunity to consider how physical medium affects the efficiency of sorting
algorithms.


## Sorting and sorting

I should clarify that in the bookshop we often use _sorting_ to mean the
process of winnowing the bags of books donated to the shop, separating the
saleable books from the ones that instead go to an internet book warehouse.
In this post I will instead be using the word _sorting_ as programmers do, to
mean the process of taking a disorganized set of items and arranging them in
order by some property. For the fiction section of the bookshop this means
alphabetizing them by author’s name (rearranged with surname first).

Sorting algorithms can be nicely illustrated through alphabetizing books. Here’s
[a video on the subject] ([via John Kottke]). The approaches shown here work
for books floating weightlessly in infinite space, but in a real bookshop the
physicality of the books makes a difference. I have speculated a bit as to
how one might differently measure algorithms’ efficiency. For example,
swapping two books is a fairly clumsy operation, so it might be more
important to minimize swaps than minimize comparisons, perhaps? Finding the
author’s name is the time-consuming part of comparing two books, so it
follows that comparing _N_ pairs is slower than comparing one book
against _N_ others.

Another difference is that a large number of entirely disorganized books is
the rare case—mostly we work with the shelves of books that are already
alphabetized (even if slightly disorganized by distracted customers), and
small numbers (a few dozen) of book we have just priced and need to put out
for sale.

## Shelving (insertion sort with binary chop)

The most common sorting operation we do is shelving: merging a few dozen
unsorted books in to a much larger, already-sorted set of books spread over
several shelves. For this, _insertion sort_ works pretty well, especially
combined with using _binary chop_ to locate the position of the new book.

This is actually quite a nice illustration of binary chop. Find the correct
shelf. Now we use two fingers to keep track of the part the shelf. Start with
your left finger pointing before at the first book and your right finger
pointing after the last one (imagine you’re pointing at the gaps between
books). Look at the book midway between your fingers. If it belongs _before_
the book you are sorting, move your left finger to point _after_ it,
otherwise your right to point before it. Repeat this a few times until both
fingers point at the same gap (or stop earlier if the position is obvious).
Each iteration chops the portion of shelf you are looking in by half, making
it quick to find the correct gap (O(log _n_)). Shelving _k_ books this way
takes O(_k_ × log _n_) comparisons.

We can further optimize shelving by first sorting the pile of books we are
shelving. This way the search for where to insert a book only has to consider
the books between the previously shelved book and the other end of the
shelves. With a long row of shelves this means you gradually move from one
end to the other rather than having to continually go back and forth to a
different random position.

## Sorting at the table (Quick Sort)

So we want to sort the few dozen books we have priced before shelving them.
This is a situation that better matches the abstract sorting problem: there
is a table on which we can create stacks of books as the algorithm requires.

In recent weeks I have in fact been experimenting with adapting Quick Sort to
this situation. Given a pile of unsorted books, one can _partition_ them as follows:

1. Take three books at random from the unsorted set and lay them out as the
base of three piles, ordered from left to right.

2. The book in the middle is the _pivot_. Go through the unsorted books,
adding each to the left or right pile according to whether they go before or
after the pivot book. If the author matches the book can go on the middle
pile.

This creates two unsorted piles and a small pile containing just the pivot
book. The unsorted piles can be partitioned in turn, taking care to keep the
piles organized from left to right. When the piles are small enough they can
be trivially sorted in ones hands. Now stack the sorted piles on each other
and all the books are in order.

Partitioning is quick because the pivot book and the books you are
comparing it to are face up rather than spine out, which makes reading the
author’s name easier.

## Children’s section (insertion sort again)

The children’s section gets disorganized as customers pull books out and
return them only approximately where they found them. The constraint that
makes Quick Sort unsuitable is we have nowhere to put the books apart from
the shelf they are already on. A computer program can sort an array of items
in place, by keeping track of which sections of the array belong to which
partition, but for a person with a real shelf of books, keeping track of one
split is quite enough.

That’s the way to use insertion sort on the children’s section. You
start by splitting the first shelf into a sorted and an unsorted section.
The sorted section starts out with just the book that happened to be
leftmost. Now take books one by one from the unsorted part, and insert
them in to the correct place in the sorted section. (We say ‘insert’ even when
we are adding to the start or end.) The sorted section grows and the unsorted
section shrinks, until all is neatly organized once more.

This is takes O(_n_ log _n_) comparisons in the worst case. With partially
sorted shelves, it will normally go faster than that: we can often transfer
good chunk of books to the end of the sorted section in one go, skipping the
one-by-one comparisons.


## Lack of analysis

I have not done any serious analysis in to how one might model the trade-offs
involved in organizing books. But binary chop, and the sorting methods based
on it seems like the best balance between being faster and still being simple
enough for a person to do in their head.


[a video on the subject]: https://www.youtube.com/watch?v=WaNLJf8xzC4
[via John Kottke]: https://kottke.org/24/10/whats-the-fastest-way-to-alphabetize-your-bookshelf
