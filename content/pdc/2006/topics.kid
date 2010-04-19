<?python
import sys
import re
import sqlite3
import itertools
from xml.etree.ElementTree import XML
from xml.parsers import expat
import sets

def href_from_source(src):
	if src.endswith('.e'):
		src = src[:-2]
	if src < '../2003/20030501':
		href = '%s%s.html#e%s' % (src[:8], src[12:14], src[8:18])
	else:
		href = '%s%s/%s.html' % (src[:8], src[12:14], src[14:16])
	if href.startswith('../2006/'):
		href = href[8:]
	return href
	
named_entity_re = re.compile(r'\&([a-zA-Z0-9]+);')
named_entity_chars = {
	'amp': u'&amp;',
	'frac12': u'\xBD',
	'lsquo': u'\u2018',
	'mdash': u'\u2014',
	'nbsp': u'\xA0',
	'ndash': u'\u2013',
	'Prime': u'\u2033',
	'rsquo': u'\u2019',
	'times': u'\xD7',
}
def named_entity_sub(m):
	w = m.group(1)
	return named_entity_chars[w]
	
def html(s):
	s = named_entity_re.sub(named_entity_sub, s)
	s = '<span>%s</span>' % s
	try:
		return XML(s.encode('UTF-8'))
	except expat.ExpatError, err:
		sys.exit('Could not parse "%s" as XML: %s' % (s, str(err)))

con = sqlite3.connect('topics.db')
c = con.cursor()
c.execute("""
	select 
		ifnull(Parents.name, '_top') parent,
		Topics.name, 
		ifnull(Topics.label, Topics.name) label, 
		source, title, published
	from 
		Topics 
		join Doc_Topics on topic = Topics.id
		join Docs on Docs.id = doc
		left join Topics Parents on Parents.id = Topics.parent
	order by
		published desc
	""")
topic_children = {}
topic_entries = {}
topic_labels = {}
for parent, name, label, source, title, published in c.fetchall():
	topic_children.setdefault(parent, sets.Set()).add(name)
	topic_entries.setdefault(name, []).append((source, title, published))
	topic_labels[name] = label
del c
con.close()
?>
<html xmlns="http://www.w3.org/1999/xhtml"
		xmlns:py="http://purl.org/kid/ns#" xml:lang="en-GB" lang="en-GB">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>Topics - Alleged News</title>  
		<link href="../pdc.css" rel="alternate stylesheet" type="text/css" title="Spirals" />
		<link href="../2005/gentium.css" rel="stylesheet" type="text/css" title="Gentium" />
		<link href="../2005/lod.css" rel="alternate stylesheet" type="text/css" title="Light on Dark" />
		<!--[if lte IE 6]>
		<link rel="stylesheet" type="text/css" href="../2005/gentium-ie6.css" title="Gentium" />
		<![endif]-->
	</head>
	<body>    
		<p class="trail">
		  <a href="../.."><img src="../../img/alleged-03@32x16.png" align="absmiddle" alt="Alleged Literature" width="32" height="16" border="0" /></a> &gt;&gt;
		  <a href="../">pdc</a> &gt;&gt;
		</p>
		<div id="body">
			<h1>Alleged Archive</h1>		
			<p id="tagline">Topic list</p>
			<ul>
				<li py:for="toplevel in topic_children['_top']">
					<div py:content="html(topic_labels[toplevel])">Parent Topic</div>
					<ul py:if="topic_entries.get(toplevel)">
						<li py:for="source, title, published in topic_entries[toplevel]">
							<a href="${href_from_source(source)}" py:content="html(title)">
								Title of the entry goes here
							</a>
							<span class="detail" py:content="' (%s)' % published"> (13 May 2009)</span>				
						</li>
					</ul>
					<ul py:if="topic_children.get(toplevel)">
						<li py:for="topic in topic_children[toplevel]">
							<div py:content="html(topic_labels[topic])">Topic</div>
							<ul py:if="topic_entries.get(topic)">
								<li py:for="source, title, published in topic_entries[topic]">
									<a href="${href_from_source(source)}" py:content="html(title)">
										Title of the entry goes here
									</a>
									<span class="detail" py:content="' (%s)' % published"> (13 May 2009)</span>				
								</li>
							</ul>
						</li>
					</ul>
				</li>
			</ul>
		</div>
	</body>
</html>
