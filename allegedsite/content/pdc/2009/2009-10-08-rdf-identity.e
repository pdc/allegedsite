Title: Can Topic Maps Help Me Understand Identity in RDF?
Topics: rdf topicmaps identity
Date: 2009-10-08
Image: ../icon-64x64.png

Compared with the overt structure of [ISO Topic Maps][], the better-known [RDF][] is free-wheeling anarchy. To make sense of RDF you need to impose additional structures on top of RDF itself; these can be conventions embodied in your program code, or specifications layered on top of RDF like [RDF Schema][] and [OWL][]. I have found that the concepts of topic maps are useful in understanding the work I have been doing with RDF. Here’s an example.

Background
==========

I am building an application (using [Django][]) called Taskuu to let me
edit my timesheet data before feeding it in to my employer’s timesheet
database TimesheetDB (I have changed the names to protect the innocent).
I need to be able to extract the work-log notes so I can back up the
data. I want the data to last a long time, possibly to outlast this web
app, and to be sufficiently database-agnostic that I can migrate to a
new editor by dumping the data and then loading it in to the new editor.
There are various options, of which I thought I would give RDF a go. The
result looks a bit like this (tidied somewhat for clarity):

    @prefix : <tag:myemployer.example.com,2009:taskuu#>.
    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>.
    @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>.
    @prefix dcterms: <http://purl.org/dc/terms/>.
    @prefix n: <http://devserver.local:8000/resource/>.
    @prefix b: <http://devserver.local:8000/resource/bin/>.
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#>.
    …

     n:n1 dcterms:created "2009-09-17T19:25:20"^^xsd:dateTime;
         dcterms:modified "2009-09-17T19:25:20"^^xsd:#dateTime;
         :about "2009-09-17"^^xsd:date;
         :bin b:internal-marketing-general;
         :class :Note;
         :description """D&BAG - Another round of editing templates.
         
    Incorporated feedback from Bill and Ted.""";
         :hours-worked 7.5;
         :user u:pdc. 
    ≈
     b:internal-marketing-general :class :Bin;
         :is-active 1;
         :label "General";
         :timesheetdb-tag "subdivision-542";
         :project p:internal-marketing;
         :tag "general".     
    …

This shows two resources: a note and a bin. Bins tell us who is charged for the work; a given project may have more than one bin because development work is charged differently from support work.  The information about one note would also include the known facts about the project and client, but I have omitted these to save space.

When I merge an RDF lump in to the database I want it to be robust. I something goes wrong, I want to be able to just merge the RDF again and have the system recognize which of the described entities are new and which already exist. This means you need a good way to tell whether two RDF descriptions describe the same thing.


Topics, Subjects, Resources, and Representations
================================================

In topic maps, a lot of emphasis is put on identity and its use in
merging topic maps. Topic maps distinguish between the *topic* (the
cluster of information), the *subject* (the thing being described) and
URIs and names used to identify these things. To make a feeble analogy,
the topic is like an index card in a library, the subject is the book,
and the URIs are things like ISBNs and accession numbers that identify
the books.

Topic Maps also draw a distinction between URIs (or URI references) used
to identify a unit of electronic information (e.g., the URI of a topic,
or the URI of a web page), and URIs used as subject identifiers. 
Subject identifiers don’t get dereferenced, because all that matters is that they are unique. As a result, people sometimes use special URI schemes like `tag` ([RFC 4151][]) that explicitly cannot be downloaded.

The RDF approach is to talk of URIs, descriptions, and resources almost
interchangeably, and to use ‘resource’ to mean anything. It’s like
holding up an index card and saying ‘This is a play by Shakespeare’. The card itself is not the play. Or
in real life, that <http://dbpedia.org/resource/Oxford> has latitude
51.751945 and longitude −1.257778.

Does this make sense? Yes, but only if you are willing to split a hair
that most people will not be aware of. The resource identified by
<http://google.co.uk/> is not a page in HTML format, it’s just an abstract
thingamabob, one of whose *representations* is a page in HTML format.
Using the card catalogue metaphor again, the card is not the play, but information about a book; but the book itself is not the play, merely one edition (representation) of it. A performance of the play is also a representation, not the play itself. The play itself is an abstraction.
Similarly for <http://dbpedia.org/resource/Oxford>, the resource is the
city of Oxford, and [this HTML page][1] and [this RDF data][2] merely
representations of it. We are not used to distinguishing between
resources and representations, but given that distinction, the habit of
RDF aficionados of referring to people by URI seems a little less demented.

 
Names versus URIs
=================

Topics can have *names*, a term defined so strictly that most everyday
uses of ‘name’ in everyday use do not qualify: a name must be guaranteed
*never* to apply to a different topic, and to *never* fail to apply to
this topic. Because different people can have the same name as each
other, and so on, what we normally call a person’s name is really what
topic maps call a label.

In the fragment above, the `timesheetdb-tag` property of the bin is a
name (within the scope of TimesheetDB, our timesheet repository). Here
is that fragment again:

    b:internal-marketing-general :timesheetdb-tag "subdivision-542";
        :label "General"; …

The TimesheetDB system does not give entities symbolic names, so we use
the combination of table name and the ID within that table. This is
guaranteed unique within TimesheetDB, and the database itself is unique.
It follows that data from different instances of Taskuu can both refer
reliably to the same bin.

The trick here is that, while topic maps have a syntax for specifying
scoped names, in RDF so far as I know there is only one sort of
identifier, and that is a URI. So perhaps instead of recording the
TimesheetDB tag I should record a URI. In other words, replace it with
something like this:

    b:internal-marketing-general = timesheetdb:subdivision-542;
        :label "General"; …
    
where `=` is an abbreviation for `<http://www.w3.org/2002/07/owl#sameAs>` and `timesheetdb` would have to be the prefix for a namespace for TimesheetDB identifiers. Or better still, use this URI as the the URI we are describing:

    timesheetdb:subdivision-542 :label "General"; …
        
I am not in charge of TimesheetDB, so inventing a URI scheme for it somehow seems even more presumptuous than inventing a naming scheme—especially as I am not in a position to set up a web server serving RDF at that address. That said, it is acceptable RDF to refer to URLs that cannot be dereferenced, so maybe that is not a reason to not switch to using this pattern. (This may be one of those annoying cases where documenting a decision makes you think maybe you should have done it the other way.)

Notes’ URIs
===========

The notes—unlike bins, projects, and clients—are ‘owned’ by this application: there is no need to coordinate with identifiers defined elsewhere, because this app is authoritative. This is philosophically simpler, but presented the technical problem of implementing the URIs in a reasonably future-proof fashion.

In Django you don’t have the address of the web site specified anywhere in particular. Instead you often find a URI by asking the dispatcher to run in reverse: you give it a view function and parameters, and it calculates the URL that, when submitted to the dispatcher, will end up calling that function.  This is great, because you can redesign the URLs by fiddling with `urls.py` and all links within the application will magically point to the correct new URLs.  That is actually very cool.

It did mean that my code for generating the RDF description of a note needs to be passed the URL to use as the namespace for notes identifiers. When I first realized this, I had to go through all the functions that call each other to add this as an extra parameter. 

To allow the RDF to be fed in to any instance of Taskuu, including the one it originated in, the code that imports RDF and assimilates it in to the application’s database needs to recognize its own URI prefix and thereby match the note to its existing entry. 

Otherwise it has to use the URL of the note as its identifier. For this I created a separate table model class, `SubjectIndicator` (not a great name, but I could think of none better), which lists external URIs of objects in this application. When adding the note, it looks for a `SubjectIndicator` entry with that URI, and if it exists, this note has already been added in a previous merge; otherwise it adds the note and a subject indicator entry. Thereafter the note behaves as normal so far as the rest of the application is concerned; its only difference is how it identifies itself in subsequent RDF exports.

Is RDF Better than Not-RDF?
============================

My reader will have discovered that what started out as a simple dump-&amp;-restore system has unexpectedly ended up dipping in to some fairly complicated philosophical tangents, some of which have prompted me to change the way I am expressing my data structure in RDF. Is this a mark against RDF as an archival format?

I think in the end these issues would need to be addressed one way or another. Some ad-hoc format would in the end have to solve the same issues, and would have the disadvantage of needing its solution to be detailed as part of its documentation. 

As discussed earlier, Topic Maps have identity features built in to the base syntax, whereas RDF requires you to adopt conventions over and above the RDF basics. But until you have assimilated the thinking behind it, the Topic Maps syntax does not prevent you from accidentally using non-unique labels as names or whatever. So the difference is a matter of whether you like self-contained specifications or specification stacks.

Now I need to go off and update the code to match the changes I realized were necessary while writing this documentation!


  [ISO Topic Maps]: http://en.wikipedia.org/wiki/Topic_Maps
  [RDF]: http://www.w3.org/RDF/
  [Django]: http://www.djangoproject.com/
  [RDF Schema]: http://www.w3.org/TR/rdf-schema/
  [OWL]: http://www.w3.org/TR/owl-guide/
  [RFC 4151]: http://tools.ietf.org/html/rfc4151
  [1]: http://dbpedia.org/page/Oxford
  [2]: http://dbpedia.org/data/Oxford.n3