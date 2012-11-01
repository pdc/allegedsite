Title: Identity and CAP Alert Messages
Date: 2008-05-31
Icon: ../icon-64x64.png
Topics: cap xml oasis identity

CAP is the [OASIS Common Alerting Protocol][1], which is a  specification of an XNL
format for disseminating warnings of hurricanes, earthquakes, and suchlike. The [CAP v1.1][2] format is mandated by the European R&D project I am
working on. This is an inconvenience, because CAP is badly flawed XML standard. I am going
to discuss here some of the problems I have had with message identity as defined by CAP.

Message Identity
=====

We want to be able to analyse the content of a thread of messages, meaning an alert message
indicating an incident has occurred, and update messages for that incident. For that we
need to be able to stored and retrieve messages, which may arrive from a variety of
sources, and for that they need identifiers that are globally unique.

Sadly for us, there is no guaranteed universal, unique identifier for CAP messages. This makes aggregation difficult.

Failed to use URIs
==================

There *is* an element called `identifier` which the standard says is 

> A number or string uniquely identifying this message, assigned by the sender

Since there is no central repository of identifiers, so there is nothing that guarantees
that different senders will not coincidentally choose the identifier `msg0045`. So the
intention must be that `identifier` is unique in the scope of a namespace maintained by the
sender.

This is OK so long as the sender is uniquely identified: then the combination of sender name and message identifier would be unique. But the `sender` element is described as

> Identifies the originator of this alert. Guaranteed by the assigner to be unique
> globally; e.g., may be based on an Internet domain name

How are assigners (presumably the same as senders) to guarantee their sender ids are unique? There is no registration process described. Saying it *may* be ‘based on an internet domain name’ is not good enough, although in practice the examples they give are

- `KARO@CLETS.DOJ.CA.GOV`
- `trinet@caltech,edu`
- `KSTO@NWS.NOAA.GOV`
- `hsas@dhs.gov`

These all match the pattern of [RFC 2822][] addresses and message-ids, which would not have
been an entirely unreasonable approach to making unique identifiers, but only if they had
made this format mandatory. Doing so would have represented good practice if this standard
had been drafted in 1985.

On the other hand, it is no longer 1985. In 2005 we have the World-Wide Web, founded on
universal resource locators (URLs). There are plenty of precedents of using the URL syntax
for universal resource identifiers (URIs), which make a better alternative for universally
unique identifiers than any application-specific identifier scheme: URIs satisfy uniqueness
and universality automatically, so anyone owning a domain name can mint their own URIs that
are guaranteed not to clash with anyone else's. In the case of CAP, a better approach would
have been to require senders and messages to be identified by URI, or at least to have
senders identified by URI and messages assigned ids of a form suitable for combining to the
sender URI to make a message URI.

References messages using datetime
==================================

To make matters worse, when they *do* want to identify messages -- such as in the
`references` element -- they use a comma-separated triple of the form

> _sender_ `,` _identifier_ `,` _sent_

where _sender_ and _identifier_ are as previously discussed and _sent_ is

> (1) The date and time is represented in **\[dateTime\]** format ...
> (2) Alphabetic timezone designators such as "Z" MUST NOT be used.

by which they mean the format [specified in XML Schema][3] except that the canonical format (UTC, indicated with a `Z` suffix) is forbidden. 

The first thing to say here is to repeat the point that inventing your own system of
resource identifiers is always less desirable than simply specifying that URIs should be
used.

The second thing is that earlier we were told that the message identifier was unique in the
scope of the sender; now we are told that identifiers must be further qualified with a
timestamp. I guess we must infer that the same identifier might be reused with different
timestamps on modified versions of the same message. In other words, this implies that
messages are mutable, which complicates matters when aggregating messages. It also raises
philosophical questions, such as whether two updates to the original alert are
modifications of the same message (so should share an identifier) or separate messages in
their own right. This issue is simply not addressed in the spec.

The next question is, are these the same message reference?

    KARA@CLETS.DOJ.CA.GOV,KAR0-0306113339-SW,2003-06-11T22:39:00-07:00
    KARA@CLETS.DOJ.CA.GOV,KAR0-0306113339-SW,2003-06-12T05:39:00+00:00

I would say yes, since they refer to the same moment in time. But this means that we cannot
rely on string comparisons to compare message references, because we have to parse the
timestamp portion. The standard could have mandated that the timestamp always be passed on
verbatim, or always be expressed in some canonical form (e.g., UTC), but is silent on the
subject. Will timestamps be be altered by intermediaries? It seems likely, especially as
most of my colleagues want to use XML schema to decode messages in to data structures
before dealing with them -- so the `sent` element will be parsed in to a `DateTime` object,
and re-formatted when the message is passed on. The `DateTime` classes in Mcirosoft .NET
converts timestamps to what it considers to be the local time zone of the computer it
happens to be on. This is bad if the computer in question is a web server with global
audience. Similar things go wrong when you save a timestamp in a database and retrieve it,
or format a timestamp using JavaScript, and so on. Also, timestamps got from `DateTime.Now`
are recorded in decimicroseconds, which means they can be different from the
timestamp retrieved from the database even if they look identical when printed out.


The Path Not Taken
==================

The specification could start by discussing the relationship between the resources it
discusses (the information about some event) and the representations of that resource (the
XML messages sent to recipients). If the resource is mutable, so there can be updated
representations in play, then the representations should have the same URI but different
last-modified timestamps; there will be no need to list the old versions within the
message, as the recipient can simply store the most-recent representation and
discard the others.

For a given incident there may be several messages that cover different aspects of the event. For example, a hypothetical sequence

1. Storm predicted at future date _xxx_ in area _yyy_

1. Storm now predicted at future date _xxx_ in areas _yyy_ and _zzz_

2. Storm imminent; take shelter as described here ...

3. Storm has passed, extra resources needed

4. Summary of storm recovery

These are still what people would call ‘updates’, but because at another level they are all
separate resources, hence separate URIs. A recipient that wants a full picture will need to
remember the latest versions of each message in the set. Someone who only wants to know the
current status will discard versions of all messages all except the last.



Conclusion
==========

Identity of messages in CAP is fuzzy and uses date-time values to distinguish between
messages, which makes processing them needlessly complicated. Modern web standards should
instead define when two representations (in this case, an alert message) can be different
views of the same resource, or are different enough to represent distinct resources (with
unique URIs).


  [1]: http://www.oasis-open.org/committees/tc_home.php?wg_abbrev=emergency
  [2]: http://www.oasis-open.org/committees/download.php/15135/emergency-CAPv1.1-Corrected_DOM.pdf
  [3]: http://www.w3.org/TR/xmlschema-2/#dateTime
  [RFC 2822]: http://tools.ietf.org/html/rfc2822