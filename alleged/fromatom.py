# -*-coding: UTF-8-*-

from xml.etree import ElementTree as et  # noqa
from html.entities import name2codepoint
import httplib2
import re

from django.conf import settings


ATOM = 'http://www.w3.org/2005/Atom'
ATOM_FEED = '{http://www.w3.org/2005/Atom}feed'
ATOM_ENTRY = '{http://www.w3.org/2005/Atom}entry'
ATOM_ID = '{http://www.w3.org/2005/Atom}id'
ATOM_TITLE = '{http://www.w3.org/2005/Atom}title'
ATOM_LINK = '{http://www.w3.org/2005/Atom}link'
ATOM_PUBLISHED = '{http://www.w3.org/2005/Atom}published'
ATOM_CONTENT = '{http://www.w3.org/2005/Atom}content'

# http://farm9.staticflickr.com/8483/8229589533_681832d5ef_b.jpg
FLICKR_IMAGE_RE = re.compile(r"""
    <img \s
    src="http://farm
    (?P<farmID> [0-9]+ )
    \.static\.?flickr\.com/
    (?P<serverID> [0-9]+ )
    /
    (?P<id> [0-9]+ )
    _
    (?P<secret> [a-z0-9]+ )
    (?:
        _
        (?P<size> [mstzb] )
    )?
    \.jpg"
    """, re.VERBOSE)

YOUTUBE_POSTER_RE = re.compile(r"""
    <img \s
    alt="" \s
    src="(?P<url> http://i.ytimg.com/vi/.*/default.jpg )"
    ></a>
""", re.VERBOSE)

GITHUB_SNIFF_RE = re.compile(r"""
    <span \s class="mega-octicon
    """, re.VERBOSE)

SPAN_RE = re.compile(r"""
    <span>
    (?P<content> .* )
    </span>
""", re.VERBOSE)


def nested_dicts_from_atom(xml_data, group_by=None):
    """Convert from Atom to a similified format amenable to JSON."""
    feed_elt = et.XML(xml_data)
    assert feed_elt.tag == ATOM_FEED
    entries = None if group_by else []
    result = {'entryGroups': []} if group_by else {'entries': entries}
    last_date = None
    for entry_elt in feed_elt:
        if entry_elt.tag == ATOM_ENTRY:
            entry = entry_from_element(entry_elt)
            if group_by == 'published':
                published = entry.pop('published')
                if not last_date or published[:10] != last_date[:10]:
                    result['entryGroups'].append({
                        'published': published,
                    })
                    entries = []
                    result['entryGroups'][-1]['entries'] = entries
                    last_date = published
            entries.append(entry)
    return result


def entry_from_element(entry_elt):
    entry = {}
    for prop_elt in entry_elt:
        if prop_elt.tag == ATOM_TITLE:
            entry['title'] = prop_elt.text
        elif prop_elt.tag == ATOM_LINK:
            type = prop_elt.get('type')
            link = {
                'href': prop_elt.get('href'),
                'type': type,
            }
            rel = prop_elt.get('rel')
            if (not rel or rel == 'alternate') and (not type or type == 'text/html'):
                entry.update(link)
            else:
                entry[rel] = link
        elif prop_elt.tag == ATOM_PUBLISHED:
            entry['published'] = prop_elt.text
        elif prop_elt.tag == ATOM_ID:
            entry['id'] = prop_elt.text
        elif prop_elt.tag == ATOM_CONTENT:
            text = prop_elt.text
            m = FLICKR_IMAGE_RE.search(text)
            if m:
                flickr_ids = m.groupdict()
                for (rel, letter) in (('square', 's'), ('thumbnail', 't')):
                    flickr_ids['letter'] = letter
                    entry[rel] = {
                        'href': 'http://farm{farmID}.staticflickr.com/{serverID}/{id}_{secret}_{letter}.jpg'.format(
                            **flickr_ids)
                    }
            m = YOUTUBE_POSTER_RE.search(text)
            if m:
                entry['poster'] = {
                    'href': m.group('url')
                }
                m = SPAN_RE.search(text)
                if m:
                    text = m.group('content')
            if GITHUB_SNIFF_RE.search(text):
                entry['html'] = html_from_github_content(text)
            if prop_elt.get('type') == 'html':
                entry['content'] = summary_from_content(text)
    return entry


named_entity_re = re.compile(r'\&(\w+);')


def named_entity_sub(m):
    n = name2codepoint[m.group(1)]
    return chr(n)


break_re = re.compile(r'(?:<br ?/?>){2}|</p>')
tag_re = re.compile(r'</?\w+(\s+[\w-]+=("[^"]*"|\'[^\']*\'))*\s*/?>')


def summary_from_content(text, type='html'):
    """Given Atom’s escaped HTML, return text.

    Atom’s HTML has been escaped and looks like &lt;img src="..."&gt;.
    When we parse the XML we get something like <img src="....">
    We want to strip out the tags and leave plain text.
    """
    text = text.strip()
    if type == 'html':
        m = break_re.search(text)
        if m and m.end(0) < len(text):
            text = '{text} …'.format(text=text[:m.start(0)])
        text = tag_re.sub('', text)
        text = named_entity_re.sub(named_entity_sub, text)
    return text


def html_from_github_content(text):
    text = text.replace('&raquo;', '\u2019')  # Argh
    text = text.replace(r'href="/', 'href="https://github.com/')
    xml = '<x>{0}</x>'.format(text)
    content_elt = et.XML(xml)
    for elt in content_elt:
        if elt.get('class') == 'details':
            return et.tostring(elt, 'utf-8', 'xml').decode('UTF-8')


def get_flickr(flickr_url):
    return get_atom(flickr_url, group_by='published')


def get_livejournal(livejournal_url):
    return get_atom(livejournal_url)


def get_youtube(youtube_url):
    return get_atom(youtube_url)


def get_github(github_url):
    return get_atom(github_url)


def get_atom(atom_url, **kwargs):
    http = httplib2.Http(
        settings.HTTPLIB2_CACHE_DIR,
        disable_ssl_certificate_validation=('github' in atom_url))
    resp, body = http.request(atom_url, 'GET')
    if resp.status == 200:
        return nested_dicts_from_atom(body, **kwargs)
