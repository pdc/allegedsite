# Encoding: UTF-8

from django.http import HttpResponse, HttpResponseRedirect, HttpResponseServerError
from django.template import RequestContext
from django.views.decorators.cache import cache_page
from django.shortcuts import render_to_response 
from django.core.urlresolvers import reverse
from django.core.cache import cache
from django.conf import settings

from datetime import date
import json

from alleged.blog.entries import get_entries as get_entries_uncached, get_entry, get_toc as get_toc_uncached, get_named_article as get_named_article_uncached
from alleged.blog.fromatom import get_flickr

def add_hrefs(entries):
    for entry in entries:
        if not hasattr(entry, 'href'):
            entry.href = reverse('blog_entry', kwargs={
                'year': str(entry.published.year),
                'month': '%02d' % entry.published.month,
                'day': '%02d' % entry.published.day,
            })

def get_entries(blog_dir, blog_url, image_url):
    """Get the lust of blog entries."""
    if settings.BLOG_CACHE_ENTRIES:
        blog_key = 'blog:%s' % blog_dir
        entries = cache.get(blog_key)
        if not entries:
            entries = get_entries_uncached(blog_dir, blog_url, image_url)
            add_hrefs(entries)
            for entry in entries:
                if not entry.is_loaded:
                    entry.load()
            cache.set(blog_key, entries)
        return entries
    
    entries = get_entries_uncached(blog_dir, blog_url, image_url)
    add_hrefs(entries)
    return entries
    
def get_toc(blog_dir, blog_url, image_url):
    entries = get_entries(blog_dir, blog_url, image_url)
    toc = get_toc_uncached(entries)
    return toc
    
def get_named_article(blog_dir, blog_url, image_url, year, name):
    article_key = 'blog:%s,%d,%s' % (blog_dir, year, name)
    entries = cache.get(article_key)
    if not entries:
        article = get_named_article_uncached(blog_dir, blog_url, image_url, year, name)
        #cache.set(blog_key, article)
    return article
    
def render_with(default_template_name, mimetype='text/html'):
    """Decorator for request handlers. the decorated function returns a dict of template args."""
    def decorator(func):
        def decorated_func(request, *args, **kwargs):
            result = func(request, *args, **kwargs)
            if isinstance(result, HttpResponse):
                return result
            template_name = result.pop('template_name') if 'template_name' in result else default_template_name
            template_args = result
            return render_to_response(template_name, template_args, RequestContext(request), mimetype=mimetype) 
        return decorated_func
    return decorator
    
    
def get_year_months(entries, y):
    # Find the last aeticle in each month in this year,
    this_year_months = {}
    by_year = entries.get_by_year()
    this_year = by_year[y or date.today().year]
    for e in this_year:
        this_year_months[e.published.month] = e
    return sorted(this_year_months.items())

@render_with('blog/index.html')
def index_view(request, blog_dir, blog_url, image_url):
    entries = get_entries(blog_dir, blog_url, image_url)
    entry, this_month, years = get_entry(entries, None, None, None)
    return {
        'entries': entries,   
        'entry': entry,
        'this_month': this_month, 
        'years': years,
        'this_year_months': get_year_months(entries, entry.published.year),
        'is_index': True,
    }
    
@render_with('blog/entry.html')
def entry_view(request, blog_dir, blog_url, image_url, year, month, day):
    entries = get_entries(blog_dir, blog_url, image_url)
    y = year and int(year)
    m = month and int(month, 10)
    d = day and int(day, 10)
    entry, this_month, years = get_entry(entries, y, m, d)
    
    return {
        'entries': entries,   
        'entry': entry,
        'this_month': this_month, 
        'years': years,
        'this_year_months': get_year_months(entries, y),
        'is_index': False,
    }
    
@render_with('blog/month_entries.html')
def month_entries(request, blog_dir, blog_url, image_url, year=None, month=None):
    entries = get_entries(blog_dir, blog_url, image_url)
    y = year and int(year)
    m = month and int(month, 10)
    d = None
    entry, this_month, years = get_entry(entries, y, m, d)
    
    return {
        'entry': entry,
        'entries': entries,  
        'this_month': this_month,  
        'prev': this_month[0].prev,
        'next': this_month[-1].next,
        'years': years,
        'this_year_months': get_year_months(entries, y),
    }
    
@render_with('blog/filtered_by_tag.html')
def filtered_by_tag(request, blog_dir, blog_url, image_url, plus_separated_tags):
    tags = sorted(plus_separated_tags.split('+'))
    matching_entries = get_toc(blog_dir, blog_url, image_url)
    for tag in tags:
        matching_entries = matching_entries.filter(tag=tag)
    if len(matching_entries.selected_tag_infos) > 1:
        for info in matching_entries.selected_tag_infos:
            info_tags = list(tags)
            info_tags.remove(info.tag)
            info.href = reverse('blog_tag', kwargs={'plus_separated_tags': '+'.join(sorted(info_tags))})
        
    for info in matching_entries.available_tag_infos:
        info_tags = list(tags)
        info_tags.append(info.tag)
        info.href = reverse('blog_tag', kwargs={'plus_separated_tags': '+'.join(sorted(info_tags))})
        
    return {
        'tags': tags,
        'plus_separated_tags': plus_separated_tags,
        'matching_entries': matching_entries,
    }

@render_with('front_page.html')
def front_page(request, blog_dir, blog_url, image_url, is_svg_wanted):
    return {
        'is_svg_wanted': is_svg_wanted,
    }

@render_with('blog/named_article.html')
def named_article(request, blog_dir, blog_url, image_url, year, name):
    y = year and int(year)
    article = get_named_article(blog_dir, blog_url, image_url, y, name)
    entries = get_entries(blog_dir, blog_url, image_url) # Needed for archive navigation
    entry, this_month, years = get_entry(entries, y, None, None)
    return {
        'article': article,
        'years': years,
        'this_year_months': get_year_months(entries, y),
    }
    
ATOM_PAGE_SIZE = 15
@render_with('blog/atom.xml', mimetype='application/atom+xml')
def atom(request, blog_dir, blog_url, image_url, page_no=None):
    entries = get_entries(blog_dir, blog_url, image_url)
    
    # Just to be tricky:
    # • Positive pages are archive pages, counting up from earliest page.
    # • Negative pages are paged-feed pages, counting down from -1 being the second-most-recent.
    # • There is no page 0. Instead we have page None for the subscription page
    #   (which is the most-recent page in the paged-feed pages).
    if page_no is not None:
        page_no = int(page_no)
    subset = (entries[(page_no - 1) * ATOM_PAGE_SIZE : page_no * ATOM_PAGE_SIZE] 
        if page_no 
        else entries[-ATOM_PAGE_SIZE:])
    subset.reverse()
    
    vars = {
        'page_no': page_no,
        'absolute_page_no': -page_no if page_no and page_no < 0 else page_no,
        'entries': entries,
        'subset': subset,
        'updated': subset[-1].published,
        'is_index': not page_no,
        'is_archive': page_no and page_no > 0,
        'is_paged': page_no and page_no < 0,
    }
    
    prev_page_no = ((1 + (len(entries) - 1) // ATOM_PAGE_SIZE)
        if page_no is None
        else (page_no - 1) if page_no > 1
        else (page_no + 1) if page_no < 1
        else None)
    next_page_no = (-1
        if page_no is None
        else (page_no + 1) 
        if page_no > 0 and page_no * ATOM_PAGE_SIZE < len(entries) 
        else (page_no - 1)
        if page_no < 0 and (page_no - 1) * ATOM_PAGE_SIZE + len(entries) > 0
        else None)
    
    links = [
        ('self',
            reverse('blog_atom_archive', kwargs={'page_no': page_no}) 
            if page_no else reverse('blog_atom')),
    ]
    if page_no:
        links.append(('current', reverse('blog_atom')))
    else:
        links.insert(0, (None, blog_url))
    for name, p_no in [('prev', prev_page_no), ('next', next_page_no)]:
        if p_no:
            rel = ('previous' 
                if name == 'prev' and p_no < 0
                else '{name}{archived}'.format(name=name, archived='-archive' if p_no > 0 else ''))
            href = request.build_absolute_uri(
                reverse('blog_atom_archive', kwargs={'page_no': str(p_no)}))
            links.append((rel, href))
    if not page_no or page_no < 0:
        links.append(('first', reverse('blog_atom')))
        
        p = -((len(entries) - 1) // ATOM_PAGE_SIZE)
        links.append(('last', reverse('blog_atom_archive', kwargs={'page_no': p})))
            
    vars['links'] = [(rel, request.build_absolute_uri(href)) for (rel, href) in links]
    return vars
    
    
def render_json(view):
    """Decorator for view function returning a dictionary to be rendered as JSON.
    
    Write the view function as usual, except it returns a dict
    not a response object.
    If the function being decorated returns an HttpResponse subclass 
    instead, that is returned unchanged.
    """
    def decorated_view(request, *args, **kwargs):
        resp = view(request, *args, **kwargs)
        if isinstance(resp, HttpResponse):
            return resp
        data = json.dumps(resp)
        return HttpResponse(data, mimetype='application/json')
    return decorated_view
    
# @cache_page(1)
@render_json
def from_flickr(request):
    ndix = get_flickr(settings.FLICKR_ATOM_URL)
    if not ndix:
        HttpResponseServerError('Could not get Atom data from Flickr')
    ndix['success'] = True
    return ndix