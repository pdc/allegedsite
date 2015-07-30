"""
Entries for my web site live in .e files. This program extracts metadata from
the .e files and stores it in an SQLite database topics.sqlite.

pdc 2006-10-27

"""

import os
import re
import sqlite3
import time
import getopt
import sys
import email
import datetime

VERSION = '1.0 (pdc 2006-10-26)'

db_name = 'topics.db'

UNCLASSIFIED = 'unclassified'

xml_re = re.compile(r'^\s*(<!--|<\?xml|<entry)')
entry_re = re.compile("""
    <entry
    [^<>]*
    date="([0-9]{8})"
    """, re.VERBOSE)
heading_re = re.compile(r'<h1?>(.*)</h1?>', re.DOTALL)
dc_subject_re = re.compile(r'<dc:subject>([^<>]+)</dc:subject>')
topics_re = re.compile(r'\nTopics:([^\n]+)\n')


class Entry(object):
    """Information about one entry."""
    def __init__(self, file_name):
        """Create an entry by reading data from the named file."""
        text = open(file_name, 'rt').read()
        if xml_re.search(text):
            self.tags = dc_subject_re.findall(text) or [UNCLASSIFIED]
            try:
                self.title = heading_re.findall(text)[0]
            except IndexError:
                sys.exit('%s: could not find heading' % file_name)
            when = entry_re.findall(text)[0]
            self.published = datetime.date(*time.strptime(when, '%Y%m%d')[:3])
        else:
            m = email.message_from_string(text)
            tags = m['Topics']
            self.tags = tags.split() if tags else [UNCLASSIFIED]
            self.title = m['Title']
            when = m['Date']
            if '-' in when:
                self.published = datetime.date(*time.strptime(when, '%Y-%m-%d')[:3])
            else:
                self.published = datetime.date(*time.strptime(when, '%Y%m%d')[:3])


def update_entry(con, file_name):
    """Update the database with information about the entry in this file."""
    entry = Entry(file_name)
    print entry.published, entry.title, entry.tags
    c = con.cursor()
    for tag in entry.tags:
        c.execute('insert or ignore into Topics (name) values (?)', (tag,))

    c.execute('delete from Doc_Topics where doc = (select id from Docs where source = ?)', (file_name,))
    c.execute(
        'insert or replace into Docs (source, title, published) values (?, ?, ?)',
        (file_name, entry.title, entry.published))
    c.execute('select id from Docs where source = ?', (file_name,))
    doc_id, = c.fetchone()
    c.executemany(
        'insert into Doc_Topics (doc, topic) select ?, id from Topics where name = ?',
        [(doc_id, tag) for tag in entry.tags])
    con.commit()


def maybe_update_entry(con, file_name):
    """Update this entry, if the file is more recently updated than the last scan."""
    is_new = True
    c = con.cursor()
    c.execute('select scanned from Docs where source = ?', (file_name,))
    row = c.fetchone()
    if row:
        last_scanned = time.strptime(row[0], '%Y-%m-%d %H:%M:%S')[:6]
        last_modified = time.localtime(os.stat(file_name).st_mtime)[:6]
        is_new = last_modified > last_scanned
    if is_new:
        update_entry(con, file_name)
    return is_new


class Usage(Exception):
    pass

help_text = """usage:
    entry_topics.py -h | --help
    entry_topics.py -V | --version
    entry_topics.py file_name...
"""


def main(argv=None):
    """What to do when run from the command line."""
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], 'hVv', ['help', 'version', 'verbose'])
        except getopt.Error, err:
            sys.exit(str(err))

        is_help = False
        is_verbose = False
        for flag, arg in opts:
            if flag == '-h' or flag == '--help':
                print help_text
                is_help = True
            elif flag == '-V' or flag == '--version':
                print VERSION
                is_help = True
            elif flag == '-v' or flag == '--verbose':
                is_verbose = True
        if is_help:
            return 0

        con = sqlite3.connect(db_name)
        for file_name in args:
            if maybe_update_entry(con, file_name) and is_verbose:
                print 'updated', file_name
    except Usage, err:
        sys.exit('usage: entry_topics.py -h | -V | file_name...')


if __name__ == '__main__':
    sys.exit(main())
