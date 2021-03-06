# Encoding: UTF-8

import json
import os
from datetime import datetime
import shutil
import tempfile
import textwrap

from django.urls import reverse
from django.test import TestCase
from unittest.mock import patch, ANY
from xml.etree import ElementTree as ET  # noqa

from alleged.blog.entries import get_entries, get_entry, get_toc, get_named_article
from alleged.fromatom import nested_dicts_from_atom, summary_from_content
from alleged.blog import views


class TestEntry(TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.mkdtemp()
        for y in ['1998', '2002', '2003', '2008', '2009', '2010', '2015', '2018']:
            os.mkdir(os.path.join(self.tmp_dir, y))

    def tearDown(self):
        shutil.rmtree(self.tmp_dir)

    def test_entry_list_1(self):
        with open(os.path.join(self.tmp_dir, '2010-04-17-testa.e'), 'wt') as output:
            output.write('Title: FOO\nTopics: alpha beta\n\nBAR\nBAZ\n')
        entries = get_entries(self.tmp_dir, '/masterblog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('FOO', e.title)
        self.assertHTMLEqual('<p>BAR\nBAZ</p>', e.body)
        self.assertEqual(datetime(2010, 4, 17, 12, 0, 0), e.published)
        self.assertEqual('testa', e.slug)
        self.assertEqual('/masterblog/2010/04/17.html', e.href)
        self.assertTrue('alpha' in e.tags)
        self.assertTrue('beta' in e.tags)

    def test_freskish_markdown_extension(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-05-08-zum.e'), 'wt') as output:
            output.write(
                'Title: FOO\nTopics: alpha beta\n\nBAR\n\n'
                '    Hullo\n    ≈\n    World\n\nBAZ\n')
        entries = get_entries(self.tmp_dir, '/masterblog/', '/images/')
        e = entries[0]
        self.assertHTMLEqual('<p>BAR</p>\n<pre><code>Hullo\n\xA0\nWorld\n</code></pre>\n<p>BAZ</p>', e.body)

    def test_archaic(self):
        with open(os.path.join(self.tmp_dir, '19970611.e'), 'wt') as output:
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
        entries = get_entries(self.tmp_dir, '/blog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('CAPTION96 Photo album', e.title)
        expected = """This is <a href="http://caption.org/1996/pdc/">a selection of
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
        self.assertHTMLEqual(expected, e.body)
        self.assertEqual(datetime(1997, 6, 11, 12, 0, 0), e.published)
        self.assertEqual('', e.slug or '')

    def test_dc_subject(self):
        with open(os.path.join(self.tmp_dir, '19980425.e'), 'wt') as output:
            output.write("""<!-- -*-HTML-*- -->
                <entry date="19980425" icon="http://caption.org/img/caption94-64x64.gif">
                      <h1>CAPTION97 photo album</h1>
                      <body>
                            I took almost 200 pictures of small-press-comics folk
                            at the convention
                            <a href="http://caption.org/1997/">EuroCAPTION97</a>.  Here's
                            <a href="http://caption.org/1997/pdc/">the finished album</a>,
                            with many of the duff pictures discarded.
                            <strong>Update:</strong>
                            With the creation of the <a href="http://caption.org/">CAPTION</a>
                            web site, this album has moved home and in the process has been
                            redesigned with a less archaic  look.
                      </body>
                      <dc:subject>photos</dc:subject>
                      <dc:subject>caption</dc:subject>
                </entry>""")
        entries = get_entries(self.tmp_dir, '/blog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('CAPTION97 photo album', e.title)
        expected = """I took almost 200 pictures of small-press-comics folk
            at the convention
            <a href="http://caption.org/1997/">EuroCAPTION97</a>.  Here's
            <a href="http://caption.org/1997/pdc/">the finished album</a>,
            with many of the duff pictures discarded.
            <strong>Update:</strong>
            With the creation of the <a href="http://caption.org/">CAPTION</a>
            web site, this album has moved home and in the process has been
            redesigned with a less archaic  look."""
        self.assertHTMLEqual(expected, e.body)
        self.assertEqual(datetime(1998, 4, 25, 12, 0), e.published)
        self.assertEqual('', e.slug or '')
        self.assertTrue('photos' in e.tags)
        self.assertTrue('caption' in e.tags)

    def test_h_rather_than_h1(self):
        with open(os.path.join(self.tmp_dir, '2002/20021229.e'), 'wt') as output:
            output.write("""<!-- -*-HTML-*- -->
                <entry date="20021229" icon="../tarot/x-wheel-100w.png">
                      <h>Alleged Tarot: a better dial-a-reading</h>
                      <body>
                            <p>
                                  My <a href="../tarot/">Alleged Tarot 2002</a> project has been
                                  stuck with an ersatz dealer for far too long (since
                                  <a href="08.html#e20020809">August</a>, in fact).  I&nbsp;have
                                  now added to the <a href="../tarot/aboutDealer.html">JavaScript
                                  used for the dealer</a> so it takes a question and converts that
                                  to a seed number, rather than requiring the querent to supply
                                  their own.  Entering the question corresponds to the shuffling
                                  of the deck that you do in a tarot deal in real life.
                            </p>
                      </body>
                      <dc:subject>tarot</dc:subject>
                </entry>""")
        entries = get_entries(self.tmp_dir, '/blog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('Alleged Tarot: a better dial-a-reading', e.title)
        expected = """<p>
              My <a href="/blog/tarot/">Alleged Tarot 2002</a> project has been
              stuck with an ersatz dealer for far too long (since
              <a href="/blog/2002/08.html#e20020809">August</a>, in fact).  I\xA0have
              now added to the <a href="/blog/tarot/aboutDealer.html">JavaScript
              used for the dealer</a> so it takes a question and converts that
              to a seed number, rather than requiring the querent to supply
              their own.  Entering the question corresponds to the shuffling
              of the deck that you do in a tarot deal in real life.
            </p>"""
        self.assertHTMLEqual(expected, e.body)

    def test_with_namespaces_supplied(self):
        with open(os.path.join(self.tmp_dir, '2003/20031228.e'), 'wt') as output:
            output.write("""<!-- -*-HTML-*- -->
                <entry date="20031228" icon="picky-80x80.png"
                        xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
                  <h>Dates Dates Dates</h>
                  <body>
                    <p>
                      Once again <a href="http://caption.org/picky/">the Picky Picky
                      Game</a> had problems calculating dates.  Alas! that the
                      Python-2.3 datetime module arived too late to carry this burden
                      on my behalf.  This time it was not month #0 that caused
                      problems, but, predictably perhaps, month #13.  Feh.
                    </p>
                  </body>
                  <dc:subject>picky</dc:subject>
                </entry>
                """)
        entries = get_entries(self.tmp_dir, '/blog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('Dates Dates Dates', e.title)
        expected = """<p>
              Once again <a href="http://caption.org/picky/">the Picky Picky
              Game</a> had problems calculating dates.  Alas! that the
              Python-2.3 datetime module arived too late to carry this burden
              on my behalf.  This time it was not month #0 that caused
              problems, but, predictably perhaps, month #13.  Feh.
            </p>"""
        self.assertHTMLEqual(expected, e.body)

    def test_entry_list_chron(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-03-02-foo.e'), 'wt') as output:
            output.write('Title: FOO\n\nFoo bar baz\n')
        with open(os.path.join(self.tmp_dir, '2010/2010-04-17-bar.e'), 'wt') as output:
            output.write('Title: BAR\n\nBar baz quux\n')
        entries = get_entries(self.tmp_dir, '/blog/', '/images/')
        self.assertEqual(2, len(entries))

        # Entries are listed in forward chronological order.
        self.assertEqual(datetime(2010, 4, 17, 12, 0, 0), entries[1].published)
        self.assertEqual(datetime(2010, 3, 2, 12, 0, 0), entries[0].published)

        # Next and prev refer to chronology
        self.assertEqual(entries[0], entries[1].prev)
        self.assertEqual(entries[1], entries[0].next)
        self.assertEqual(None, entries[1].next)
        self.assertEqual(None, entries[0].prev)

    def test_should_munge_relative_href_attribute(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello [world](17.html)\n')
        entries = get_entries(self.tmp_dir, '/banko/', '/plugh/')
        entry = entries[-1]
        self.assertEqual('<p>Hello <a href="/banko/2010/17.html">world</a></p>', entry.body)

    def test_should_also_munge_realative_script_src(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\n<script src="foo.js"></script>\n')
        entries = get_entries(self.tmp_dir, '/banko/', '/plugh/')
        entry = entries[-1]
        self.assertEqual('<script src="/plugh/2010/foo.js"></script>', entry.body)

    def test_should_not_attempt_to_munge_inline_script(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\n<script>MAGIC</script>\n')
        entries = get_entries(self.tmp_dir, '/banko/', '/plugh/')
        entry = entries[-1]
        self.assertEqual('<script>MAGIC</script>', entry.body)

    def test_when_type_attr_included_should_still_munge_script_src(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\n<script type="text/javascript" src="SCRIPT.js"></script>\n')
        entries = get_entries(self.tmp_dir, '/banko/', '/plugh/')
        entry = entries[-1]
        self.assertEqual('<script type="text/javascript" src="/plugh/2010/SCRIPT.js"></script>', entry.body)

    def test_munging_xml(self):
        with open(os.path.join(self.tmp_dir, '2002/20021229.e'), 'wt') as output:
            output.write("""<!-- -*-HTML-*- -->
              <entry date="20021229" icon="../tarot/x-wheel-100w.png">
                <h>Alleged Tarot: a better dial-a-reading</h>
                <body>
                  <p>
                    My <a href="../tarot/">Alleged Tarot 2002</a> project has been
                    stuck with an ersatz dealer for far too long (since
                    <a href="08.html#e20020809">August</a>, in fact).  I&nbsp;have
                    now added to the <a href="../tarot/aboutDealer.html">JavaScript
                    used for the dealer</a> so it takes a question and converts that
                    to a seed number, rather than requiring the querent to supply
                    their own.  Entering the question corresponds to the shuffling
                    of the deck that you do in a tarot deal in real life.
                  </p>
                </body>
                <dc:subject>tarot</dc:subject>
              </entry>""")
        e = self.get_entry()

        self.assertEqual('Alleged Tarot: a better dial-a-reading', e.title)
        expected = """<p>
            My <a href="/blog/tarot/">Alleged Tarot 2002</a> project has been
            stuck with an ersatz dealer for far too long (since
            <a href="/blog/2002/08.html#e20020809">August</a>, in fact).  I\xA0have
            now added to the <a href="/blog/tarot/aboutDealer.html">JavaScript
            used for the dealer</a> so it takes a question and converts that
            to a seed number, rather than requiring the querent to supply
            their own.  Entering the question corresponds to the shuffling
            of the deck that you do in a tarot deal in real life.
          </p>"""
        self.assertHTMLEqual(expected, e.body)
        self.assertEqual('/images/tarot/x-wheel-100w.png', e.image.src)

    def test_um(self):
        with open(os.path.join(self.tmp_dir, '2003/20030703.e'), 'wt') as out_stream:
            out_stream.write("""<!-- -*-HTML-*- -->
                <entry date="20030703" icon="../../2005/percy/1/1a1.jpg"
                xmlns="http://www.alleged.org.uk/2003/um"
                xmlns:dc="http://purl.org/dc/elements/1.1" href="../../2005/percy/1/">
                  <h>Percy Street, Page 1</h>
                  <body>
                    <p>
                      If you&rsquo;ve been wondering why I&rsquo;ve not added anything
                      to my site for the last few weeks, it&rsquo;s because I have
                      been spending my spare time playing with <a href="06/12.html">my new graphics tablet</a> instead.
                    </p>
                  </body>
                  <dc:subject>graphics</dc:subject>
                  <dc:subject>percy</dc:subject>
                </entry>
            """)
        e = self.get_entry()

        self.assertEqual('Percy Street, Page 1', e.title)
        expected = """<p>
              If you\u2019ve been wondering why I\u2019ve not added anything
              to my site for the last few weeks, it\u2019s because I have
              been spending my spare time playing with <a href="/blog/2003/06/12.html">my
              new graphics tablet</a> instead.
            </p>"""
        self.assertHTMLEqual(expected, e.body)
        self.assertEqual(set(['graphics', 'percy']), e.tags)

    def test_markdown(self):
        with open(os.path.join(self.tmp_dir, '2015/20150802-fictional.e'), 'wt') as out_stream:
            out_stream.write(textwrap.dedent("""\
                Title: Title of entry
                Topics: foo bar baz
                Date: 2015-08-02

                First paragraph

                Second paragraph
                """))
        e = self.get_entry()

        self.assertEqual('Title of entry', e.title)
        expected = """
            <p>
              First paragraph
            </p>
            <p>
              Second paragraph
            </p>"""
        self.assertHTMLEqual(expected, e.body)
        self.assertEqual(['foo', 'bar', 'baz'], e.tags)

    def test_markdown_with_links(self):
        with open(os.path.join(self.tmp_dir, '2018/2018-09-01-something.e'), 'wt') as output:
            output.write(textwrap.dedent("""\
                Link: <https://example.com/1>; rel=foo
                Link: <https://example.com/2>; rel=bar

                Content
                """))
        e = self.get_entry()

        self.assertEqual(e.links[0].url, 'https://example.com/1')
        self.assertEqual(e.links[0].rel, 'foo')
        self.assertEqual(e.links[1].url, 'https://example.com/2')
        self.assertEqual(e.links[1].rel, 'bar')

    def test_markdown_h1_becomes_h2(self):
        with open(os.path.join(self.tmp_dir, '2015/20150802-fictional.e'), 'wt') as out_stream:
            out_stream.write(textwrap.dedent("""\
                Title: Title of entry
                Topics: foo bar baz
                Date: 2015-08-02

                First paragraph

                # Heading 1

                Second paragraph

                ## Heading 2
                    """))
        e = self.get_entry()

        expected = """
            <p>
              First paragraph
            </p>
            <h2 id="heading-1">Heading 1</h2>
            <p>
              Second paragraph
            </p>
            <h3 id="heading-2">Heading 2</h3>
            """
        self.assertHTMLEqual(expected, e.body)

    def test_markdown_toplevel_h2_remains_h2(self):
        with open(os.path.join(self.tmp_dir, '2015/20150802-fictional.e'), 'wt') as out_stream:
            out_stream.write(textwrap.dedent("""\
                Title: Title of entry

                First paragraph

                ## Heading 1

                Second paragraph

                ### Heading 2
                """))
        e = self.get_entry()

        expected = """
            <p>
              First paragraph
            </p>
            <h2 id="heading-1">Heading 1</h2>
            <p>
              Second paragraph
            </p>
            <h3 id="heading-2">Heading 2</h3>
            """
        self.assertHTMLEqual(expected, e.body)

    def test_invents_title_when_none_specified(self):
        with open(os.path.join(self.tmp_dir, '2015/20150802-fictional.e'), 'wt') as out_stream:
            out_stream.write('\n\nQuick notes on an entry I will finish off soon')
        e = self.get_entry()

        self.assertHTMLEqual('Untitled entry', e.title)

    def test_href_not_munging_external_link(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello [world](http://google.com/)\n')
        entries = get_entries(self.tmp_dir, '/banko/', '/plugh/')
        entry = entries[-1]
        self.assertEqual('<p>Hello <a href="http://google.com/">world</a></p>', entry.body)

    def test_src_munging_img_from_markdown(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello ![world](x.jpg)\n')
        entries = get_entries(self.tmp_dir, '/banko/', 'http://localhost/~pdc/alleged.org.uk/pdc/')
        entry = entries[-1]
        self.assertEqual(
            '<p>Hello <img alt="world" src="http://localhost/~pdc/alleged.org.uk/pdc/2010/x.jpg" /></p>',
            entry.body)

    def test_src_munging_img(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello <img alt="world" src="x.jpg" />\n')
        entries = get_entries(self.tmp_dir, '/banko/', 'http://localhost/~pdc/alleged.org.uk/pdc/')
        entry = entries[-1]
        self.assertEqual(
            '<p>Hello <img alt="world" src="http://localhost/~pdc/alleged.org.uk/pdc/2010/x.jpg" /></p>',
            entry.body)

    def test_srcset_munging_img(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello <img alt="world" src="x.jpg" srcset="y.jpg 100w" alt="x">\n')
        entries = get_entries(self.tmp_dir, '/banko/', 'http://localhost/~pdc/alleged.org.uk/pdc/')
        entry = entries[-1]
        self.assertEqual(
            '<p>Hello <img alt="world" src="http://localhost/~pdc/alleged.org.uk/pdc/2010/x.jpg"' +
            ' srcset="http://localhost/~pdc/alleged.org.uk/pdc/2010/y.jpg 100w" alt="x"></p>',
            entry.body)

    def test_src_munging_embed(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello <embed src="zergukk.svg" type="image/svg" />\n')
        entries = get_entries(self.tmp_dir, '/banko/', 'http://localhost/~pdc/alleged.org.uk/pdc/')
        entry = entries[-1]
        self.assertEqual(
            '<p>Hello <embed src="http://localhost/~pdc/alleged.org.uk/pdc/2010/zergukk.svg" type="image/svg" /></p>',
            entry.body)

    def test_src_munging_embed_unsvgz(self):
        """When including a SVG file iwth the old-style .svgz ending, change it to .svg."""
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-links.e'), 'wt') as output:
            output.write('Title: Links!\n\nHello <embed src="zergukk.svgz" type="image/svg" />\n')
        entries = get_entries(self.tmp_dir, '/banko/', 'http://localhost/~pdc/alleged.org.uk/pdc/')
        entry = entries[-1]
        self.assertEqual(
            '<p>Hello <embed src="http://localhost/~pdc/alleged.org.uk/pdc/2010/zergukk.svg" type="image/svg" /></p>',
            entry.body)

    def test_find_by_tag(self):
        """Create a bunch of entries and show that you get the correct ones in the filtered list."""
        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-a.e'), 'wt') as output:
            output.write('Title: A\nTopics: a b\n\nHello [world](17.html)\n')
        with open(os.path.join(self.tmp_dir, '2010/2010-04-21-b.e'), 'wt') as output:
            output.write('Title: B\nTOpics: b c d\n\nHello [world](17.html)\n')
        with open(os.path.join(self.tmp_dir, '2010/2010-03-07-c.e'), 'wt') as output:
            output.write('Title: C\nTopics: c d\n\nHello [world](17.html)\n')
        with open(os.path.join(self.tmp_dir, '2009/2009-12-31-d.e'), 'wt') as output:
            output.write('Title: D\nTopics: d\n\nHello [world](17.html)\n')
        with open(os.path.join(self.tmp_dir, '2008/2008-07-11-e.e'), 'wt') as output:
            output.write('Title: E\nTopics: a e\n\nHello [world](17.html)\n')
        entries = get_entries(self.tmp_dir, '/x/', '/i/')
        toc = get_toc(entries)
        self.assertEqual(5, len(toc))
        self.assertEqual('E', toc[0].title)
        self.assertEqual(['a', 'e'], toc[0].tags)
        self.assertEqual(datetime(2008, 7, 11, 12, 0), toc[0].published)
        self.assertEqual('B', toc[-1].title)
        self.assertEqual(['b', 'c', 'd'], toc[-1].tags)
        self.assertEqual(datetime(2010, 4, 21, 12, 0), toc[-1].published)

        a_entries = toc.filter(tag='a')
        # Check the resultis a list with A and E in it, since they are the only ones with tag 'a'
        self.assertEqual(2, len(a_entries))
        self.assertEqual('E', a_entries[0].title)
        self.assertEqual(['a', 'e'], a_entries[0].tags)
        self.assertEqual(datetime(2008, 7, 11, 12, 0), a_entries[0].published)
        self.assertEqual('A', a_entries[1].title)
        self.assertEqual(['a', 'b'], a_entries[1].tags)
        self.assertEqual(datetime(2010, 4, 18, 12, 0), a_entries[1].published)

        # Now chech we have the info needed to navigate to narrower or wider searches.
        self.assertEqual(1, len(a_entries.selected_tag_infos))
        self.assertEqual('a', a_entries.selected_tag_infos[0].tag)
        self.assertEqual(2, len(a_entries.available_tag_infos))
        self.assertEqual('b', a_entries.available_tag_infos[0].tag)
        self.assertEqual(1, a_entries.available_tag_infos[0].count)
        self.assertEqual('e', a_entries.available_tag_infos[1].tag)
        self.assertEqual(1, a_entries.available_tag_infos[1].count)

        ae_entries = a_entries.filter(tag='e')
        self.assertEqual(1, len(ae_entries))
        self.assertEqual(a_entries[0], ae_entries[0])
        self.assertEqual(['a', 'e'], [info.tag for info in ae_entries.selected_tag_infos])
        self.assertEqual([], ae_entries.available_tag_infos)

        # List of selected tags is always alphabetically ordered.
        self.assertEqual(['a', 'e'], [
            info.tag
            for info in toc.filter(tag='e').filter(tag='a').selected_tag_infos])

    def test_gets_entry_image_from_header(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-17-testa.e'), 'wt') as output:
            output.write('Title: FOO\nTopics: alpha beta\nImage: hazmat-64.png\n\nBAR\nBAZ\n')
        entries = get_entries(self.tmp_dir, '/masterblog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('/images/2010/hazmat-64.png', e.image.src)

    def test_gets_default_entry_image_if_no_header(self):
        with open(os.path.join(self.tmp_dir, '2010/2010-04-17-testa.e'), 'wt') as output:
            output.write('Title: FOO\nTopics: alpha beta\n\nBAR\nBAZ\n')
        entries = get_entries(self.tmp_dir, '/masterblog/', '/images/')
        self.assertEqual(1, len(entries))
        e = entries[0]
        self.assertEqual('/images/icon-64x64.png', e.image.src)
        self.assertTrue(e.image.is_fallback)

    def test_entry_href_before_june_2003(self):
        with open(os.path.join(self.tmp_dir, '2003-05-17.e'), 'wt') as output:
            output.write('Title: FOO\nTopics: alpha beta\n\nBAR\nBAZ\n')
        es = get_entries(self.tmp_dir, '/x/', '/i/')
        self.assertEqual('/x/2003/05.html#e20030517', es[0].href)

    def test_entry_href_from_june_2003(self):
        with open(os.path.join(self.tmp_dir, '2003-06-14.e'), 'wt') as output:
            output.write('Title: FOO\nTopics: alpha beta\n\nBAR\nBAZ\n')
        es = get_entries(self.tmp_dir, '/x/', '/i/')
        self.assertEqual('/x/2003/06/14.html', es[0].href)

    def test_summary_old_style(self):
        """Old entries (before June 2003) are just a summary and may link to an article."""
        with open(os.path.join(self.tmp_dir, '2003/2003-05-17.e'), 'wt') as output:
            output.write('Title: FOO\nTopics: alpha beta\n\nBAR\nBAZ\n\nQUUX\n')
        es = get_entries(self.tmp_dir, '/x/', '/i/')
        self.assertEqual('<p>BAR\nBAZ</p>\n<p>QUUX</p>', es[0].summary)

    def test_summary_new_style(self):
        """New entries are complete articles use the first paragraph as their summary."""
        with open(os.path.join(self.tmp_dir, '2003/2003-06-14.e'), 'wt') as output:
            output.write('Title: FOO\nTopics: alpha beta\n\nBAR\nBAZ\n\nQUUX\n')
        es = get_entries(self.tmp_dir, '/x/', '/i/')
        self.assertEqual('<p>BAR\nBAZ\n<a class="more" href="/x/2003/06/14.html">Read more</a></p>', es[0].summary)

    def test_named_article(self):
        with open(os.path.join(self.tmp_dir, '2003/ancient.html'), 'wt') as stream:
            stream.write("""<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN'
            'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
            <html xmlns="http://www.w3.org/1999/xhtml">
              <!-- Generated from graphics-the-hard-way.th on 2006-10-29 09:49 GMT -->
              <head>
                <title>Colour graphics the hard way - Alleged Literature</title>
                <link href="../pdc.css" rel="alternate stylesheet" type="text/css" title="Spirals" />
              </head>
              <body>
                <p class="trail">
                  <a href="./">2002</a> &gt;&gt;
                  <strong>graphics-the-hard-way</strong>
                </p>
                <div id="body">
                  <h1>Colour graphics the hard way</h1>
                  <p>
                  On my badly broken Linux desktop,
                  the Gimp is missing its file-saving plug-ins, so it cannot save
                  files except in a format I&nbsp;cannot use.
                  </p>
                  <p><a href="11.html#e20021125a">25 November 2002</a></p>
                </div>
                <div class="links">
                  <h3>Archives</h3>
                  <ul>
                    <li><a href="../2006/topics.html">by topic</a></li>
                    <li><a href="../2006/">2006</a></li>
                    <li><a href="../2005/">2005</a></li>
                  </ul>
                </div>
                <div class="links">
                  <p><a title="Link to an XML summary in RSS 2.0 format"
                    href="../rss091.xml" type="text/xml"><img src="../../img/xml.gif"
                    alt="XML" width="36" height="14" border="0" /></a></p>
                </div>
              </body>
            </html>""")
        article = get_named_article(self.tmp_dir, '/blog/', '/im/', 2003, 'ancient')
        self.assertEqual('Colour graphics the hard way', article.title)
        self.assertEqual('/blog/2003/ancient.html', article.href)
        self.assertHTMLEqual("""<p>
            On my badly broken Linux desktop,
            the Gimp is missing its file-saving plug-ins, so it cannot save
            files except in a format I\u00A0cannot use.
            </p>
            <p><a href="/blog/2003/11.html#e20021125a">25 November 2002</a></p>""", article.body)

    def test_named_article_with_image(self):
        with open(os.path.join(self.tmp_dir, '1998/bike.html'), 'wt') as stream:
            stream.write("""<html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                <title>Colour graphics the hard way - Alleged Literature</title>
                <link href="../pdc.css" rel="alternate stylesheet" type="text/css" title="Spirals" />
                </head>
                <body>
                <div id="body">
                  <h1>My recently deceased bike</h1>
                  <p class="initial">
                    <a href="19980529g.jpg"><img src="19980529g-stamp.jpg" align="right"
                        alt="[Link to bike photo&mdash;22K JPEG]" width="86" height="64" border="0" /></a>

                    This is my new bike (at least, new in Summer 1998).
                  </p>
                </div>
                </body>
                </html>""")
        article = get_named_article(self.tmp_dir, '/blog/', '/im/', 1998, 'bike')
        expected = """<p class="initial">
            <a href="/im/1998/19980529g.jpg"><img src="/im/1998/19980529g-stamp.jpg"
                align="right" alt="[Link to bike photo\u201422K JPEG]" width="86" height="64" border="0" /></a>

            This is my new bike (at least, new in Summer 1998).
          </p>"""
        actual = article.body
        self.assertHTMLEqual(expected, actual)

    def get_entry(self, index=-1, expected_count=1):
        entries = get_entries(self.tmp_dir, '/blog/', '/images/')
        self.assertEqual(expected_count, len(entries))
        e = entries[index]
        return e

    def assertEqualStrings(self, expected, actual):
        if expected == actual:
            return
        for i in range(min(len(expected), len(actual))):
            beg = i - 5 if i > 5 else 0
            end = i + 15
            indent = ' ' * (i - beg + 2)
            self.assertEqual(
                expected[i],
                actual[i],
                ('Strings differ at position %d\n %r\n %r\n %s^'
                    % (i, expected[beg:end], actual[beg:end], indent)))


class TestThisMonthList(TestCase):
    """Create a bunch of entries and show that you get the correct ones in the this_month list."""

    def setUp(self):
        self.tmp_dir = tempfile.mkdtemp()
        for y in ['1998', '2002', '2003', '2008', '2009', '2010', '2015']:
            os.mkdir(os.path.join(self.tmp_dir, y))

        with open(os.path.join(self.tmp_dir, '2010/2010-04-18-a.e'), 'wt') as output:
            output.write('Title: A\n\nHello [world](17.html)\n')
        with open(os.path.join(self.tmp_dir, '2010/2010-04-21-b.e'), 'wt') as output:
            output.write('Title: B\n\nHello [world](17.html)\n')
        with open(os.path.join(self.tmp_dir, '2010/2010-03-07-c.e'), 'wt') as output:
            output.write('Title: C\n\nHello [world](17.html)\n')
        with open(os.path.join(self.tmp_dir, '2009/2009-12-31-d.e'), 'wt') as output:
            output.write('Title: D\n\nHello [world](17.html)\n')
        with open(os.path.join(self.tmp_dir, '2008/2008-07-11-e.e'), 'wt') as output:
            output.write('Title: E\n\nHello [world](17.html)\n')

        self.entries = get_entries(self.tmp_dir, '/x/', '/i/')

    def tearDown(self):
        shutil.rmtree(self.tmp_dir)

    def test_entries_sorted_by_date(self):
        self.assertEqual(['E', 'D', 'C', 'A', 'B'], [x.title for x in self.entries])

    def test_get_article_by_date(self):
        entry, this_month, years = get_entry(self.entries, 2010, 4, 18)

        self.assertEqual('A', entry.title)
        self.assertEqual(['A', 'B'], [x.title for x in this_month])
        self.assertEqual(['E', 'D', 'B'], [x.title for x in years])

    def test_no_article_specified_gets_last_article(self):
        entry, this_month, years = get_entry(self.entries, None, None, None)

        self.assertEqual('B', entry.title)
        self.assertEqual(['A', 'B'], [x.title for x in this_month])
        self.assertEqual(['E', 'D', 'B'], [x.title for x in years])

    def test_get_by_year(self):
        by_year = self.entries.get_by_year()
        self.assertEqual(3, len(by_year))
        self.assertEqual(3, len(by_year[2010]))
        self.assertEqual(['C', 'A', 'B'], [x.title for x in by_year[2010]])
        self.assertEqual(['D'], [x.title for x in by_year[2009]])
        self.assertEqual(['E'], [x.title for x in by_year[2008]])

    def test_year_data_for_react(self):
        year_data = self.entries.get_react_year_data(2010)

        expected = {
            'months': [
                {
                    'label': 'March',
                    'month': 3,
                    'entries': [{'title': 'C', 'day': 7, 'href': ANY}],
                },
                {
                    'label': 'April',
                    'month': 4,
                    'entries': [
                        {'title': 'A', 'day': 18, 'href': ANY},
                        {'title': 'B', 'day': 21, 'href': ANY},
                    ],
                },
            ]
        }
        self.assertEqual(expected, year_data)

    def test_react_data_for_entry(self):
        entry, this_month, years = get_entry(self.entries, 2010, 4, 18)
        react_data = self.entries.get_react_data(entry)

        expected = {
            'minYear': 2008,
            'maxYear': 2010,
            'years': {2010: ANY},
        }
        self.assertEqual(expected, react_data)

        expected2 = self.entries.get_react_year_data(2010)
        expected2['months'][1]['entries'][0]['isActive'] = True
        self.assertEqual(expected2, react_data['years'][2010])

    def test_react_year_api(self):
        path = reverse('blog-react-api')
        with patch.object(views, 'get_entries_cached', lambda blog_dir, blog_url, image_url: self.entries):
            response = self.client.get(path + '?year=2010')

        self.assertEqual(200, response.status_code)
        self.assertEqual('application/json', response['Content-Type'].split(';')[0])
        obj = json.loads(response.content.decode('UTF-8'))
        self.assertEqual(self.entries.get_react_year_data(2010), obj)


FIXTURE_DIR = os.path.join(os.path.dirname(__file__), 'test_data')


def fixture_data(file_name, from_encoding=None):
    """Find a test file and return its contents.

    Arguments --
        file_name -- names the file within the fixtures directory
        from_encoding -- if not None, then convert the file data to
            a Unicode string using this encoding

    """
    file_path = os.path.join(FIXTURE_DIR, file_name)
    with open(file_path, 'rb') as strm:
        data = strm.read()
    if from_encoding:
        data = data.decode(from_encoding)
    return data


class TestJsonfromAtom(TestCase):
    def test_from_flickr(self):
        data = fixture_data('from_flickr_2012.atom')
        ndix = nested_dicts_from_atom(data, group_by='published')
        self.assertDictContainsSubsetRecursive({
            'entryGroups': [
                {
                    'published': '2012-11-29T18:36:38Z',
                    'entries': [
                        {
                            'title': 'Set Type (Reversed)',
                            'href': 'http://www.flickr.com/photos/pdc/8229589533/',
                            'square': {'href': 'http://farm9.staticflickr.com/8483/8229589533_681832d5ef_s.jpg'},
                            'thumbnail': {'href': 'http://farm9.staticflickr.com/8483/8229589533_681832d5ef_t.jpg'},
                            'enclosure': {
                                'href': 'http://farm9.staticflickr.com/8483/8229589533_681832d5ef_b.jpg',
                            }
                        },
                        {'title': 'Set Type'},
                        {'title': 'Font Menu'}
                    ]
                },
                {
                    'published': '2012-11-22T19:40:17Z',
                    'entries': [
                        {'title': 'Baroness Orczy, By the Gods Beloved'},
                        {'title': 'Is the Any Better Recommendation than the name of Orczy'},
                    ]
                }
            ]
        }, ndix)

    def test_from_livejournal(self):
        data = fixture_data('from_livejournal.atom')
        ndix = nested_dicts_from_atom(data)
        self.assertDictContainsSubsetRecursive({
            'entries': [
                {
                    'id': 'urn:lj:livejournal.com:atom1:damiancugley:105302',
                    'published': '2010-11-21T18:08:48Z',
                    'href': 'http://damiancugley.livejournal.com/105302.html',
                    'title': 'Sister in Storage',
                    'content': 'Mum was visiting from Malta\u2014her current home, '
                            'since that is where her yacht is\u2014and so naturally Saturday found her '
                            'and my brother and me down at Big Yellow Self-Storage to collect my sister '
                            'Rachel’s gear from there for transfer to the Big Yellow in Guildford, where '
                            'she lives. The store is all bare metal and bright yellow paint, so I took the '
                            'opportunity to take some photos of Mike and Rachel in this odd environment.',
                },
                {
                    'title': 'Family time'
                },
                {
                    'title': 'Ian Cugley, 1945–2010'
                }
            ]
        }, ndix)

    def test_from_youtube(self):
        data = fixture_data('from_youtube.atom')
        ndix = nested_dicts_from_atom(data)
        self.assertDictContainsSubsetRecursive({
            'entries': [
                {
                    'id': 'tag:youtube.com,2008:video:49cy7-hTAb4',
                    'published': '2010-10-31T11:45:25.000Z',
                    'href': 'http://www.youtube.com/watch?v=49cy7-hTAb4&feature=youtube_gdata',
                    'title': 'Minehouse 8: Before-Hallowe\'en Tour',
                    'content': 'Recorded the day before the much-anticipated Hallowe&#39;en update. '
                            'As I contemplate the possibility of exploring my world a little more now biomes are to be '
                            'added to the mix, I thought this was as good a time as any to review my existing home '
                            'base(s). Warning: I don&#39;t have any startling megastructures, so people who '
                            'don&#39;t know me may not find much to hold their interest.',
                    'poster': {
                        'href': 'http://i.ytimg.com/vi/49cy7-hTAb4/default.jpg',
                    }
                },
            ]
        }, ndix)

    def assertDictContainsSubsetRecursive(self, expected, actual):
        complaints = list(self.check_subset(expected, actual, ''))
        if complaints:
            self.fail(';\n    '.join(complaints))

    def check_subset(self, expected, actual, key_prefix):
        for key, expected_val in expected.items():
            key_path = '{prefix}[{key}]'.format(prefix=key_prefix, key=key)
            if key not in actual:
                yield 'Expected dict to contain key {key_path}'.format(key_path=key_path)
                break
            actual_val = actual[key]
            if hasattr(expected_val, 'items'):
                for msg in self.check_subset(expected_val, actual_val, key_path):
                    yield msg
            elif isinstance(expected_val, list):
                if not isinstance(actual_val, list):
                    yield 'expected a list at {key_path}'
                    break
                for i, (xv, av) in enumerate(zip(expected_val, actual_val)):
                    for msg in self.check_subset(xv, av, '{key_path}[{i}]'.format(key_path=key_path, i=i)):
                        yield msg
            else:
                if expected_val != actual_val:
                    yield 'At key {key_path}, expected {expected!r} but got {actual!r}'.format(
                        key_path=key_path,
                        expected=expected_val,
                        actual=actual_val)


class TestGithubJsonFromAtom(TestCase):
    def setUp(self):
        data = fixture_data('from_github.atom')
        self.result = nested_dicts_from_atom(data)

    def test_id(self):
        self.assertEqual('tag:github.com,2008:PushEvent/2173402038', self.result['entries'][0]['id'])

    def test_published(self):
        self.assertEqual('2014-07-06T10:54:30Z', self.result['entries'][0]['published'])

    def test_href(self):
        self.assertEqual(
            'https://github.com/pdc/allegedsite/compare/55a1fe817e...e5c5b96ce1',
            self.result['entries'][0]['href'])

    def test_title(self):
        self.assertEqual('pdc pushed to master at pdc/allegedsite', self.result['entries'][0]['title'])

    def test_content(self):
        expected = """<div class="details">
              <a href="https://github.com/pdc"><img alt="Damian Cugley" class="gravatar js-avatar" data-user="90414"
                    height="30" src="https://avatars1.githubusercontent.com/u/90414?s=140" width="30" /></a>

                <div class="commits pusher-is-only-committer">
                  <ul>
                    <li>
                      <span title="pdc">
                        <img alt="Damian Cugley" class=" js-avatar" data-user="90414" height="16"
                                src="https://avatars1.githubusercontent.com/u/90414?s=140" width="16" />
                      </span>
                      <code><a
                            href="https://github.com/pdc/allegedsite/commit/e5c5b96ce19c09760ef2358c3828723ccec897a8">e5c5b96</a></code>
                      <div class="message">
                        <blockquote>
                          Add article about cycle lanes
                        </blockquote>
                      </div>
                    </li>
                  </ul>
                </div>
            </div>"""
        self.assert_text_containing_equivalent_xml(expected, self.result['entries'][0]['html'])

    def assert_text_containing_equivalent_xml(self, text1, text2):
        elt1 = ET.XML(text1)
        elt2 = ET.XML(text2)
        self.assert_equivalent_elt(elt1, elt2)

    def assert_equivalent_elt(self, elt1, elt2):
        self.assertEqual(elt1.tag, elt2.tag)
        for k, v in elt1.attrib.items():
            self.assertEqual(elt2.attrib[k], v)
        for ee1, ee2 in zip(elt1, elt2):
            self.assert_equivalent_elt(ee1, ee2)


class TestSummaryFromContent(TestCase):
    def test_summary_from_content_html(self):
        html = '<p>HEllo, world</p>'
        self.assertEqual('HEllo, world', summary_from_content(html))

    def test_summary_from_content_no_tags(self):
        html = '<a href="foo">LiveJournal</a> does <i>not</i> do paragraph tags!'
        self.assertEqual('LiveJournal does not do paragraph tags!', summary_from_content(html))

    def test_summary_from_content_brbr(self):
        html = 'LiveJournal does not do paragraph tags!<br /><br />Instead they use BR tags.'
        self.assertEqual('LiveJournal does not do paragraph tags! …', summary_from_content(html))
