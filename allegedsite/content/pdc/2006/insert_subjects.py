"""Scan my hand-maintained list of topic tags and update the database in topics.sqlite

pdc 2006-10-27

"""


import sqlite3

subjects_file = '../2003/subjects.data'
topics_db = 'topics.db'

def subjects_iter(file_name):
	# The main complication is the indentation is used to indicate nesting.
	indent_strs = [] # The whitespace from the previous lines, broken at the points the amount of whitespace increased.
	ancestors = [] # Tags that are ancestors of this tag.
	for line in open(file_name, 'rt'):
		line = line.rstrip()
		if not line:
			continue
		is_at_least = len(indent_strs) == 0
		if not is_at_least:
			for indent_count, indent_str in enumerate(indent_strs):
				if not line.startswith(indent_str):
					indent_strs = indent_strs[:indent_count]
					break
				line = line[len(indent_str):]
			else:
				is_at_least = True
		if is_at_least:
			line0 = line
			line = line.lstrip()
			extra_count = len(line0) - len(line)
			if extra_count > 0:
				# This line is more indented.
				indent_strs.append(line0[:extra_count])
			indent_count = len(indent_strs)
		ancestors = ancestors[:len(indent_strs)]
		name, label = line.split(':', 1)
		label = label.strip()
		yield ancestors, name, label
		
		ancestors.append(name)

con = sqlite3.connect(topics_db)
c = con.cursor()
for ancestors, name, label in subjects_iter(subjects_file):
	c.execute('insert or ignore into Topics (name) values (?)', (name,))
	if ancestors:
		c.execute('update Topics set label = ?, parent = (select id from Topics where name = ?) where name = ?',
			(label, ancestors[-1], name))
	else:
		c.execute('update Topics set label = ? where name = ?', (label, name))
con.commit()

	
				
			
