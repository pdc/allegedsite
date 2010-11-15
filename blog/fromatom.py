# -*-coding: UTF-8-*-

from xml.etree import ElementTree as et
from datetime import datetime, date
import httplib2
import re

from django.conf import settings


ATOM = 'http://www.w3.org/2005/Atom'
for name in ['feed', 'entry', 'title', 'link', 'published', 'content']:
    globals()['ATOM_{NAME}'.format(NAME=name.upper())] = '{' + ATOM + '}' + name
    
FLICKR_IMAGE_RE = re.compile(r"""
    <img \s
    src="http://farm
    (?P<farmID> [0-9]+ )
    \.static\.flickr\.com/
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

def nested_dicts_from_atom(xml_data):
    """Convert from Atom to a similified format amenable to JSON."""
    feed_elt = et.XML(xml_data)
    assert feed_elt.tag == ATOM_FEED
    entriess = []
    entries = None
    last_date = None
    for entry_elt in feed_elt:
        if entry_elt.tag == ATOM_ENTRY:
            entry = {}
            published = None
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
                    published = prop_elt.text
                elif prop_elt.tag == ATOM_CONTENT:
                    m = FLICKR_IMAGE_RE.search(prop_elt.text)
                    if m:
                        flickrIDs = m.groupdict()
                        for (rel, letter) in (('square', 's'), ('thumbnail', 't')):
                            flickrIDs['letter'] = letter
                            entry[rel] = {
                                'href': 'http://farm{farmID}.static.flickr.com/{serverID}/{id}_{secret}_{letter}.jpg'.format(**flickrIDs)
                            }
            if not last_date or published[:10] != last_date[:10]:
                entriess.append({
                    'date': published,
                })
                entries = []
                entriess[-1]['entries'] = entries
                last_date = published
            entries.append(entry)
    return {'entriesByDay': entriess}
                
def get_flickr(flickr_url):
    http = httplib2.Http(settings.HTTPLIB2_CACHE_DIR)
    resp, body = http.request(flickr_url, 'GET')
    if resp.status == 200:
        return nested_dicts_from_atom(body)

    
    