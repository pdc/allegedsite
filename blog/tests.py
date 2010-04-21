"""
This file demonstrates two different styles of tests (one doctest and one
unittest). These will both pass when you run "manage.py test".

Replace these with more appropriate tests for your application.
"""

from django.test import TestCase
from alleged.blog.entries import *

import os
from datetime import datetime, date, timedelta

BASE_DIR = 'test_blog'

class SimpleTest(TestCase):
    def setUp(self):
        if not os.path.exists(BASE_DIR):
            os.mkdir(BASE_DIR)
        else:
            for y in ['2008', '2009', '2010']:
                if not os.path.exists(os.path.join(BASE_DIR, y)):
                    os.mkdir(os.path.join(BASE_DIR, y))
            for subdir, subdirs, files in os.walk(BASE_DIR):
                for file_name in files:
                    os.unlink(os.path.join(subdir, file_name))
        
    def test_entry_list_1(self):
        with open(os.path.join(BASE_DIR, '2010-04-17-testa.e'), 'wt') as output:
            output.write('Title: FOO\n\nBAR\nBAZ\n')
        entries = get_entries(BASE_DIR, '/masterblog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('FOO', e.title)
        self.assertEqual('<p>BAR\nBAZ</p>', e.body)
        self.assertEqual(datetime(2010, 4, 17, 12, 0, 0), e.published)
        self.assertEqual('testa', e.slug)
        self.assertEqual('/masterblog/2010/04/17.html', e.href)
        
    def test_archaic(self):
        with open(os.path.join(BASE_DIR, '19970611.e'), 'wt') as output:
            output.write("""<!-- -*-HTML-*- -->
<entry date="19970611" icon="1997/19980529h-stamp.jpg">
  <h1>CAPTION96 Photo album</h1>
  <body>
    This is <a href="http://caption.org/1996/pdc/">a selection of
    images</a> collected at the <a
    href="http://caption.org/1996/">CAPTION96</a> comics convention (in the
    summer of 1996). 
    Attentive readers will have noticed that there is almost a
    year-long gap between the con and the photo album.  This is partly
    explained by the amount a manual labour involved in scanning all
    those 7&times;5 photos on my none-too-fast scanner and moving the
    files from the Mac with the scanner to the Linux box with all my
    web site stuff on.
    <strong>Update:</strong>
    With the creation of the <a href="http://caption.org/">CAPTION</a>
    web site, this album has moved home and in the process has been
    redesigned with a less archaic  look. 
  </body>
</entry>""")
        entries = get_entries(BASE_DIR, '/blog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('CAPTION96 Photo album', e.title)
        expected = u"""This is <a href="http://caption.org/1996/pdc/">a selection of
    images</a> collected at the <a href="http://caption.org/1996/">CAPTION96</a> comics convention (in the
    summer of 1996). 
    Attentive readers will have noticed that there is almost a
    year-long gap between the con and the photo album.  This is partly
    explained by the amount a manual labour involved in scanning all
    those 7\xD75 photos on my none-too-fast scanner and moving the
    files from the Mac with the scanner to the Linux box with all my
    web site stuff on.
    <strong>Update:</strong>
    With the creation of the <a href="http://caption.org/">CAPTION</a>
    web site, this album has moved home and in the process has been
    redesigned with a less archaic  look."""
        self.assertEqual(expected, e.body)
        self.assertEqual(datetime(1997, 6, 11, 12, 0, 0), e.published)
        self.assertEqual('', e.slug or '')
        
    def test_entry_list_chron(self):
        with open(os.path.join(BASE_DIR, '2010-03-02-foo.e'), 'wt') as output:
            output.write('Title: FOO\n\nFoo bar baz\n')
        with open(os.path.join(BASE_DIR, '2010-04-17-bar.e'), 'wt') as output:
            output.write('Title: BAR\n\nBar baz quux\n')
        entries = get_entries(BASE_DIR, '/blog/', '/images/')
        self.assertEqual(2, len(entries))
        
        # Entries are listed in forward chronological order.
        self.assertEqual(datetime(2010, 4, 17, 12, 0, 0), entries[1].published)
        self.assertEqual(datetime(2010, 3, 2, 12, 0, 0), entries[0].published)
        
        # Next and prev refer to chronology
        self.assertEqual(entries[0], entries[1].prev)
        self.assertEqual(entries[1], entries[0].next)
        self.assertEqual(None, entries[1].next)
        self.assertEqual(None, entries[0].prev)
        
    def test_href_munging(self):
        with open(os.path.join(BASE_DIR, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello [world](17.html)\n')
        entries = get_entries(BASE_DIR, '/banko/', '/plugh/')
        entry = entries[-1]
        self.assertEqual('<p>Hello <a href="/banko/2010/17.html">world</a></p>', entry.body)
    
    def test_src_munging(self):
        with open(os.path.join(BASE_DIR, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello ![world](x.jpg)\n')
        entries = get_entries(BASE_DIR, '/banko/', 'http://localhost/~pdc/alleged.org.uk/pdc/')
        entry = entries[-1]
        self.assertEqual('<p>Hello <img alt="world" src="http://localhost/~pdc/alleged.org.uk/pdc/2010/x.jpg" /></p>', entry.body)
    
    def test_src_munging2(self):
        with open(os.path.join(BASE_DIR, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello <img alt="world" src="x.jpg" />\n')
        entries = get_entries(BASE_DIR, '/banko/', 'http://localhost/~pdc/alleged.org.uk/pdc/')
        entry = entries[-1]
        self.assertEqual('<p>Hello <img alt="world" src="http://localhost/~pdc/alleged.org.uk/pdc/2010/x.jpg" /></p>', entry.body)
    
    def test_filtering(self):
        with open(os.path.join(BASE_DIR, '2010/2010-04-18-a.e'), 'wt') as output:
            output.write('Title: A\n\nHello [world](17.html)\n')
        with open(os.path.join(BASE_DIR, '2010/2010-04-21-b.e'), 'wt') as output:
            output.write('Title: B\n\nHello [world](17.html)\n')
        with open(os.path.join(BASE_DIR, '2010/2010-03-07-c.e'), 'wt') as output:
            output.write('Title: C\n\nHello [world](17.html)\n')
        with open(os.path.join(BASE_DIR, '2009/2009-12-31-d.e'), 'wt') as output:
            output.write('Title: D\n\nHello [world](17.html)\n')
        with open(os.path.join(BASE_DIR, '2008/2008-07-11-e.e'), 'wt') as output:
            output.write('Title: E\n\nHello [world](17.html)\n')
        entries = get_entries(BASE_DIR, '/x/', '/i/')
        entry, this_month, years = get_entry(entries, 2010, 4, 18)
        
        self.assertEqual('A', entry.title)        
        self.assertEqual(['E', 'D', 'C', 'A', 'B'], [x.title for x in entries])
        self.assertEqual(['A', 'B'], [x.title for x in this_month])
        self.assertEqual(['E', 'D', 'B'], [x.title for x in years])