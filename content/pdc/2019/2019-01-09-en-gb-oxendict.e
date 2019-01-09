Title: Oxford Spelling on macOS
Date: 2019-01-09
Topics: english oxford macos

It is possible to set up a Mac to permit Oxford spelling (organize _vs_ organise).


# Oxford Spelling

Many words formed by adding _-ize_ to a noun or adjective have two correct
spellings in British English, one ending _-ize_ and the other _-ise_, for
example _organize_ and _organise_, _realize_ and _realise_.

The _-ize_ ending is more directly related to the etymology (from the Greek as
opposed to indirectly via French), corresponds to the pronunciation, and is
used by Shakespeare, Tolkein, the [United Nations][], ISO, and other
international institutions. This is, or was, the preferred spelling for the
Oxford University Press house style, and is generally known outside Oxford as
[Oxford spelling][].

Given a choice, I prefer the Oxford spelling myself.


# The Tyranny of American British English

The (American) companies that supply spelling dictionaries assume wrongly that
_-ize_ is incorrect in British English. This makes following Oxford spelling a
continual fight against the spell-checker.

As a result, many organizations whose house style specified Oxford spelling in
the past have given up and switched to specifying _-ise_ for the sake of a
quiet life.

So we need a dictionary for English with Oxford Spelling—what OUP might prefer
to call World English.


# Available Dictionaries

There are [rumours][] that spelling dictionaries for Oxford spelling exist,
but if they do they are not at all easy to find. Links to dictionaries (like
in [this exchange][]) are invariably to non-existent servers, or wiki pages
that have been replaced with a link to an extensions marketplace that doesn’t
have anything suitable. You can google for the language
tags `en-GB-oxendict` (from the [IANA registry][]) or its grandfathered
equivalent `en-GB-oed`, but you mostly find plaintive bug reports.

What I eventually found this was is a dictionary `en-GB-oed` version _R_ 1.19, edited by
David Bartlett in 2005, that can be downloaded from  an attachment on a
[long-forgotten OpenOffice bug][]. But is installing dictionary unmaintained in 14 years
going to be more trouble than it’s worth?

But then a breakthrough.
I was writing a version of this entry which discussed the spell-checking software.
There are several software libraries for spell-checking, with confusing
relationships between them.  [Hunspell][] is used by LibreOffice, OpenOffice,
web browsers like Chrome and Safari, and macOS.
Chasing links starting from its GitHub page I found a [collection of
dictionaries][] that includes an `en_GB` dictionary updated (by Marco A.G. Pinto) as recently as
2018. Eyeballing its `.aff` file suggests it
permits  _-ize_ as well as _-ise_. Great!


# Installing Spelling on macOS X

I can install the dictionary by copying the `.dic` and `.aff` files in to
`~/Library/Spelling` and restarting my Mac.  Once I had restarted I could
visit System Preferences → Keyboard → Text → Spelling → Set Up and replace
British English with the dictionary I had added.

This seems to work: I can type _organize centre colour_ in to a text editor
and all three words are accepted as correctly spelled.

This solution is unsatisfactory in that it took me half a day of googling and
more background technical knowledge that the average writer should be expected
to need to implement this solution.  I would also have preferred to be able to
specify a more strict _en-GB-oxendict_ spelling that would reject _organise_
in favour of _organize_.



  [language tag]: https://en.wikipedia.org/wiki/IETF_language_tag
  [rumours]: https://bugs.documentfoundation.org/show_bug.cgi?id=100462
  [Oxford Spelling]: https://en.wikipedia.org/wiki/Oxford_spelling
  [IANA registry]: http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
  [United Nations]: http://dd.dgacm.org/editorialmanual/ed-guidelines/style/spelling.htm
  [this exchange]: https://apple.stackexchange.com/questions/21429/uk-spelling-dictionary-teach-os-x-all-ize-spellings
  [Oxford Dictionaries]: https://en.oxforddictionaries.com/definition/retcon
  [_rationalize_]: https://en.oxforddictionaries.com/definition/rationalize
  [_defence_]: https://en.oxforddictionaries.com/definition/defence
  [long-forgotten OpenOffice bug]: https://bz.apache.org/ooo/show_bug.cgi?id=51093
  [Hunspell]: http://hunspell.github.io
  [collection of dictionaries]: https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/

