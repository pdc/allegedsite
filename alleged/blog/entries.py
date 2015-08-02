#!/usr/bin/env python
# encoding: utf-8
"""
entries.py

Created by Damian Cugley on 2010-04-17.
© 2010–2012 Damian Cugley.
"""

import os
import re
from datetime import datetime
from markdown import Markdown, Extension
from markdown.treeprocessors import Treeprocessor
from markdown.postprocessors import Postprocessor
from lxml.etree import fromstring, tostring
import htmlentitydefs

XMLNS_DC = 'http://purl.org/dc/elements/1.1/'
XMLNS_HTML = 'http://www.w3.org/1999/xhtml'
XMLNS_UM = 'http://www.alleged.org.uk/2003/um'
TAG_DC_SUBJECT = '{%s}subject' % XMLNS_DC

date_re = re.compile('^(199[0-9]|20[0-9][0-9])-?([0-1][0-9])-?([0-3][0-9])')


MUNGE_TRANSITION_DATE = datetime(2003, 6, 1, 12, 0)

entity_re = re.compile(r'\&[0-9a-zA-Z]+;')


def _unentity_sub(m):
    name = m.group(0)[1:-1]
    code = htmlentitydefs.name2codepoint.get(name)
    if not code:
        return '&%s;' % name
    return '&#x%X;' % code


def unentity(s):
    return entity_re.sub(_unentity_sub, s)


numeric_char_ref_re = re.compile(r'\&#([0-9]+);')


def _numeric_char_ref_sub(m):
    n = int(m.group(1), 10)
    return unichr(n)


def expand_numeric_character_references(s):
    return numeric_char_ref_re.sub(_numeric_char_ref_sub, s)


class HrefsTreeprocessor(Treeprocessor):
    """Machinery for modifying the behaviour of Markdown-formatted text."""
    def __init__(self, blog_url, image_url, *args, **kwargs):
        Treeprocessor.__init__(self, *args, **kwargs)
        self.blog_url = blog_url
        self.image_url = image_url

    def run(self, root):
        for e in root:
            if e.tag == 'a':
                e.set('href', munge_url(self.blog_url, e.get('href')))
            elif e.tag == 'img' or e.tag == 'script' and e.get('src'):
                e.set('src', munge_url(self.image_url, e.get('src')))
            else:
                self.run(e)


absolute_url_re = re.compile('^[a-z+-.]+:|^/')
a_re = re.compile(r'(<a[^<>]*\shref=)("[^"]*"|\'[^\']*\')([^<>]*>)')
img_or_embed_re = re.compile(r'(<(?:img|embed|script)[^<>]*\ssrc=)("[^"]*"|\'[^\']*\')([^<>]*>)')
image_file_name_re = re.compile(r'.*\.(?:jpg|jpeg|gif|png)$')


def munge_url(url, more_url):
    """Generate a URL that will work in the published page.

    Arguments --
        url -- the base URL of the blog
        more_url -- a URL from an HREF or SRC element in the blog entry.
            May be absolute or relative to the entry file.
    """
    if more_url.endswith('.svgz'):
        more_url = more_url[:-1]
    if absolute_url_re.match(more_url):
        return more_url
    while more_url.startswith('../'):
        p = url.rindex('/', 0, len(url) - 1)
        url = url[:p + 1]
        more_url = more_url[3:]
    return url + more_url


def make_link_sub(usual_url, image_url):
    def sub(m):
        original_url = m.group(2)[1:-1]
        new_url = munge_url(image_url if image_file_name_re.match(original_url) else usual_url, original_url)
        return '%s"%s"%s' % (m.group(1), new_url, m.group(3))
    return sub


def munge_html(html, blog_url, image_url):
    html = a_re.sub(make_link_sub(blog_url, image_url), html)
    html = img_or_embed_re.sub(make_link_sub(image_url, image_url), html)
    return html


class HrefsPostprocessor(Postprocessor):
    def __init__(self, markdown, blog_url, image_url, *args, **kwargs):
        Postprocessor.__init__(self, *args, **kwargs)
        self.markdown = markdown
        self.blog_url = blog_url
        self.image_url = image_url

    def run(self, text):
        for i in range(self.markdown.htmlStash.html_counter):
            html, safe = self.markdown.htmlStash.rawHtmlBlocks[i]
            html = munge_html(html, self.blog_url, self.image_url)
            self.markdown.htmlStash.rawHtmlBlocks[i] = (html, safe)
        return text


class HrefsExtension(Extension):
    config = {
        'blog_url': ['.', 'base URL of blog'],
        'image_url': ['.', 'Base URL for images'],
    }

    def extendMarkdown(self, md, md_globals):
        md.treeprocessors.add('hrefs', HrefsTreeprocessor(
            self.getConfig('blog_url'),
            self.getConfig('image_url')), '_end')
        md.postprocessors.add('hrefs', HrefsPostprocessor(
            md,
            self.getConfig('blog_url'),
            self.getConfig('image_url')), '<raw_html')


class Image(object):
    def __init__(self, src):
        self.src = src


body_re = re.compile(r'<body[^>]*>(.*)</body>', re.DOTALL)


class Entry(object):
    def __init__(self, root_dir_path, dir_path, file_name, blog_url, image_url):
        """Create an entry by examining the proffered file."""
        m = date_re.search(file_name)
        if m:
            y, mon, d = int(m.group(1), 10), int(m.group(2), 10), int(m.group(3), 10)
            self.published = datetime(y, mon, d, 12, 0, 0)
            self.href = (
                '%s%d/%02d/%02d.html' % (blog_url, y, mon, d)
                if self.published >= MUNGE_TRANSITION_DATE
                else '%s%d/%02d.html#e%d%02d%02d' % (blog_url, y, mon, y, mon, d))
            self.slug = file_name[11:-2]
        else:
            print 'Could not parse', file_name
        self.is_loaded = False

        self.file_path = os.path.join(dir_path, file_name)
        self.blog_url = blog_url
        self.image_url = blog_url

        self.munged_blog_url = blog_url + dir_path[len(root_dir_path) + 1:] + '/'
        self.munged_image_url = image_url + dir_path[len(root_dir_path) + 1:] + '/'

    def load(self):
        with open(self.file_path, 'rb') as input:
            text = input.read()
        if text.startswith('<'):
            self.load_xml(text)
        else:
            self.load_markdown(text)
        self.is_loaded = True

    def load_xml(self, text):
        """Load an entry in the old-style XML-based (or UM) format."""
        p = text.index('<entry', 0, 200) + 6
        if text.find('xmlns:dc', 0, 200) < 0:
            text = '%s xmlns:dc="%s"%s' % (text[:p], XMLNS_DC, text[p:])
        else:
            # Allow for misspelled DC namespace.
            text = text.replace('xmlns:dc="http://purl.org/dc/elements/1.1"', 'xmlns:dc="%s"' % XMLNS_DC)
        text = text.replace('xmlns="%s"' % XMLNS_UM, '', 1)

        self._tags = set()

        root = fromstring(unentity(text))
        img_raw = root.get('icon')
        self._image = Image(munge_url(self.munged_image_url, img_raw))
        for e in root:
            if e.tag == 'h1' or e.tag == 'h':
                self._title = e.text
            elif e.tag == 'body':
                body = tostring(e)
                if body.startswith('<?xml '):
                    body = body[39:]  # Remove unwanted XML prolog.
                body = body_re.sub('\\1', body)
                body = body.strip()
                body = expand_numeric_character_references(body)
                self._body = munge_html(body, self.munged_blog_url, self.munged_image_url)
            elif e.tag == TAG_DC_SUBJECT:
                self._tags.add(e.text)
            else:
                print e.tag, 'unknown'

    def load_markdown(self, text):
        """Load entry in the new Markdown-based format

        This has RFC-style headers preceding the body.
        """
        href_extension = HrefsExtension(
            blog_url=self.munged_blog_url,
            image_url=self.munged_image_url)
        converter = Markdown(extensions=['markdown.extensions.meta', href_extension])
        self._body = converter.convert(text.decode('UTF-8').replace(u'≈', u'\u00A0'))
        self._title = ', '.join(converter.Meta['title'])
        self._tags = ' '.join(converter.Meta.get('topics', [])).split()
        self._image = Image(munge_url(self.munged_image_url, converter.Meta.get('image', ['../icon-64x64.png'])[0]))

    @property
    def title(self):
        """The title of this entry, as PCDATA."""
        if not self.is_loaded:
            self.load()
        return self._title

    @property
    def body(self):
        """The body of this entry, as HTML."""
        if not self.is_loaded:
            self.load()
        return self._body

    @property
    def summary(self):
        summary = self.body
        if self.published > MUNGE_TRANSITION_DATE:
            pos = summary.find('</p>')
            if pos >= 0:
                summary = summary[:pos] + '\n<a class="more" href="%s">Read more</a></p>' % self.href
        return summary

    @property
    def tags(self):
        """The set of tags representing topics this entry is an ocurrence of."""
        if not self.is_loaded:
            self.load()
        return self._tags

    @property
    def image(self):
        """The  image that we use in place of a userpic."""
        if not self.is_loaded:
            self.load()
        return self._image


def get_entries(dir_path, blog_url, image_url, reverse=False):
    entries = EntryList(entries_iter(dir_path, blog_url, image_url))
    entries.sort(key=lambda entry: entry.published, reverse=reverse)

    prev = None
    for entry in entries:
        entry.prev = prev
        if prev:
            prev.next = entry
        prev = entry
    if prev:
        prev.next = None
    return entries


def entries_iter(dir_path, blog_url, image_url):
    for subdir_path, subdirs, files in os.walk(dir_path):
        for file_name in files:
            if file_name.endswith('.e'):
                yield Entry(dir_path, subdir_path, file_name, blog_url, image_url)


def get_entry(entries, year, month, day):
    entries_by_year = entries.get_by_year()

    this_year = entries_by_year[year] if year else []
    this_month = [e for e in (this_year or entries) if e.published.month == month] if month else []
    this_day = [e for e in (this_month or this_year or entries) if e.published.day == day] if day else []
    entry = (this_day or this_month or this_year or entries)[-1]
    if entry and not this_month:
        this_year = entries_by_year[entry.published.year]
        this_month = [e for e in this_year if e.published.month == entry.published.month]
    years = [es[-1] for (y, es) in sorted(entries_by_year.items())]
    return entry, this_month, years


class TagInfo(object):
    def __init__(self, tag, count=None):
        self.tag = tag
        self.count = count

    def __lt__(self, other):
        return self.tag < other.tag

    def __gt__(self, other):
        return self.tag > other.tag

    def __le__(self, other):
        return self.tag <= other.tag

    def __ge__(self, other):
        return self.tag >= other.tag

    def __eq__(self, other):
        return self.tag == other.tag

    def __ne__(self, other):
        return self.tag != other.tag


class EntryList(list):
    selected_tag_infos = []

    def get_by_year(self):
        if hasattr(self, '_by_year'):
            return self._by_year

        self._by_year = {}
        beg = 0
        prev = None
        for i, e in enumerate(self):
            if e.published.year != prev:
                if prev:
                    self._by_year[prev] = self[beg:i]
                beg = i
                prev = e.published.year
        if prev:
            self._by_year[prev] = self[beg:]
        return self._by_year

    def filter(self, tag):
        new_list = EntryList(e for e in self if tag in e.tags)
        new_list.selected_tag_infos = self.selected_tag_infos + [TagInfo(tag)]
        new_list.selected_tag_infos.sort()

        available_tag_counts = {}
        for e in new_list:
            for tag in e.tags:
                for info in new_list.selected_tag_infos:
                    if info.tag == tag:
                        break
                    else:
                        pass
                else:
                    available_tag_counts[tag] = available_tag_counts.get(tag, 0) + 1
        new_list.available_tag_infos = [
            TagInfo(tag, count)
            for (tag, count) in sorted(available_tag_counts.items())]
        return new_list


def get_toc(entries):
    return EntryList(entries)


yet_another_re = re.compile(r'<([^<>]+\S)\s*/>')


class Article(object):
    """In older entries, the entry is a summary and links to a named article.

    Articles were formatted using TclHTML. For the moment I am using
    the HTML output as input for the new site—this class strips off all the
    navigation clutter and returns the HTML of the artile as a lump of HTML elements.
    """
    class DoesNotExist(Exception):
        def __init__(self, file_path):
            Exception.__init__(self, '%s: file not found' % file_path)

    def __init__(self, dir_path, blog_url, image_url, year, name):
        file_path = os.path.join(dir_path, '%d/%s.html' % (year, name))
        with open(file_path, 'rb') as in_stream:
            text = unentity(in_stream.read())
            tree = fromstring(text)
        body_elements = tree.xpath('//html:div[@id="body"]/*', namespaces={'html': XMLNS_HTML})
        self.title = body_elements[0].text

        # The body is just a clot of HTML. It is not necessarily even a single element.
        self.body = ''.join(tostring(x, method='xml') for x in body_elements[1:]).strip()

        # The lxml library (and I assume libxml) has two output flavours.
        # One generates <img.../> and the other <img...></img>.
        # But I want <img... /> for Appendix-C compatibility.
        self.body = yet_another_re.sub(r'<\1 />', self.body)

        # libxml numeric-encodes every character. My server correctly labels the
        # content as UTF-8 so that is not necessary. (Also, I hate decimal numeric characeter references.)
        self.body = expand_numeric_character_references(self.body.replace(' xmlns="%s"' % XMLNS_HTML, ''))

        # We also need to change internal URLs so they work when on the published site.
        self.body = munge_html(self.body, '%s%d/' % (blog_url, year), '%s%d/' % (image_url, year))

        self.href = '%s%d/%s.html' % (blog_url, year, name)


def get_named_article(dir_path, blog_url, image_url, year, name):
    return Article(dir_path, blog_url, image_url, year, name)
