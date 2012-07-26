Title: The Problem with the EU Cookie Law
Date: 2012-07-07
Topics: cookies

The so-called EU Cookie Law has been a classic case of entirely foreseeable unforeseen consequences. Its net result will be to make people less protected against privacy-invading tracking. This is because after a few weeks of sites asking ‘Do you want to read 5 pages of gobbledegook or just press the Accept Cookies button?’, everyone can be confidently expected to press Accept Cookies reflexively in order to be able to get on with buying that comedy sock they came to the site to buy in the first place.

## The problem

There are several reasons for this. First, cookies are a low-level mechanism that cannot be easily explained to the causal punter. The term ‘cookie’ is unusually poor, even by the standards of an industry notorious for abusing English words to mean things entirely unintuitive to a lay person. Most people do not have an accurate mental model of how web browsers work, or that they function by copying data to and fro between the user’s computer and the one at the far end. They are much more focussed on the higher-level functionality these low-level mechanisms are used to implement.

Until such time as primary schools have lessons in which children role-play a web server and client by passing  bits of paper around the classroom so that all citizens understand how the WWW works, prefixing your Cookie Excuses Page with a  paragraph trying to explain cookies serves no purpose except as a barrier to reading the rest of the document.

One of the complaints about the Cookie Law was that it was not clear which cookies could be given a pass and which needed to be explicitly given permission.
the Information Commissioner’s Office’s attempts to address this by issuing 20-page clarifications that failed to clarify much just added to the confusion. The upshot is that anyone asked to give advice can only advise publishers to detail the effects of *every* cookie. It is less risky to advise people to be over-cautious. The result of this is that on non-trivial commercial sites the list of cookies is very long and highly technical. Having one undifferentiated list  also makes it hard for the user of the site to tell which cookies are useful and which are sneaky tracking cookies.

Finally, because there was no attempt to create a standardized mechanism for seeking permission, sites use a baffling mixture of pop-downs, pop-ups, footnotes, and other mechanisms to request permission. Many sites have only two options: Accept and Read More. Often they imply that the site will not work at all without allowing all cookies.

The upshot of this is that users will still never really understand the question they are being asked, because the privacy policy page in question is too long to read, and will get in to the habit of clicking Accept Cookies. If in a year’s time there is a scandal at how their privacy was sold to the highest bidder, the site owner will be able to claim that they explicitly consented in advance.

## Something That the ICO Might Have Done

Instead of saying sites should make their own guesses as to which cookies are OK, and to write their own waffle about how cookies are used, the ICO could have said that sites should

1. Use the term ‘tracking’ rather than talking about cookies.

2. Use the strictly controlled syntax for summarizing their tracking habits described below.

The idea being (1) to describe the function that cookies perform (tracking) instead of obfuscating the matter using technical jargon, and (2) to make a summary of tracking habits that can be read at a glance, so that it becomes feasible for most people to knowingly consent rather than throw their hands up and click the Accept button without reading what they are accepting.

By a controlled syntax I mean that I am proposing that the statements be English sentences but to restrict them to productions of a simple grammar (in the programming-language sense). The result might look like:

> - We record your login and shopping cart using cookies so you can purchase items.

> - We track you anonymously using server logs.

> - Adco track you anonymously using cookies unless you disable third-party cookies.

Here is a sketch of the grammar. It is not complete.

    ⟨tracking⟩ ::= ⟨necessary statement⟩* ⟨tracking statement⟩* ⟨excuses⟩

    ⟨necessary statement⟩ ::=
        We record your ⟨what⟩ using ⟨methods⟩+
        so you can ⟨benefit⟩.

    ⟨what⟩ ::= ( login | shopping cart | … )+

    ⟨tracking statement⟩ ::= ⟨who tracks you⟩
        ⟨anonymously or not⟩
        using ⟨method⟩+ .

    ⟨who tracks you⟩ ::= We track you
        | ( Our advertisers | ⟨company name⟩ ) may? track you ( on our behalf )?

    ⟨anonymously or not⟩ ::= anonymously | personally

    ⟨method⟩ ::= server logs
        | the cookie ⟨name⟩
        | cookies (unless you disable third-party cookies)?
        | invisible images
        | …

    ⟨excuses⟩ ::= …

Where the metasyntax uses ⟨…⟩  to surround nonterminal symbols, a vertical bar `|` separates alternatives, a `?` suffix marks an optional element, and star and plus (`*` and `+`) allow sequences to be repeated (star means the item is optional, plus means there must be at least one).

Note that the ⟨_necessary statement_⟩s describe uses of cookies that the user  needs   to make the site work. That is why the grammar requires that a benefit to the user be spelled out.  The tracking statements don’t include a benefits clause; the user can assume that it is in order to learn how to tweak the site  to improve conversion. The  ⟨_excuses_⟩ clause is available for any fuller explanation the site owners think will help.

The aim here is to create a system with these properties:

- The tracking statement is concise and clear and can be skimmed in a hurry by someone who just want to use the site damnit.

- It will be hard to hide nefarious cookies in waffle.

- It will be fairly clear for site owners how they should write it.

- It says what we are doing (tracking) rather than discussing details of mechanism (cookies).

It would not entirely eliminate the tendency to train users in to just clicking Accept Tracking without thinking, but it would help.

