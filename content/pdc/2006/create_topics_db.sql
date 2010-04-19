/* Definitions for the topics database. 

To create the database do

sqlite3 topics.sqlite < topics_definitions.sql

*/

create table if not exists Topics (
	id integer
		not null 
		primary key 
		autoincrement,
	name text -- The short, name used to identify this topic
		not null,
	label text,	-- HTML text used to display this label
	parent integer -- The topic that this topic is a subtopic of, or (more usually) null.
);

create unique index if not exists ix_Topics_name on Topics (name);

create table if not exists Docs (
	id integer
		not null
		primary key
		autoincrement,
	source text -- Names the `.e` file the document is stored in.
		not null,
	title text -- Title of this entry
		not null,
	published datetime -- Nominal publication date of this entry
		not null,
	scanned datetime -- When we last scanned this file.
		not null
		default current_timestamp
);

create unique index if not exists ix_Docs_source on Docs (source);

create table if not exists Doc_Topics ( -- Which topics a document refers to.
	doc integer
		not null,
	topic integer
		not null,
	primary key (doc, topic)
);
		

