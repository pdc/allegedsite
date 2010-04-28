# Create your views here.

from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response 
from django.core.urlresolvers import reverse
from django.core.cache import cache

from alleged.blog.entries import get_entries as get_entries_1, get_entry, get_toc as get_toc_1

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
    blog_key = 'blog:%s' % blog_dir
    entries = cache.get(blog_key)
    if not entries:
        entries = get_entries_1(blog_dir, blog_url, image_url)
        add_hrefs(entries)
        for entry in entries:
            if not entry.is_loaded:
                entry.load()
        cache.set(blog_key, entries)
    return entries
    
def get_toc(blog_dir, blog_url, image_url):
    entries = get_entries(blog_dir, blog_url, image_url)
    toc = get_toc_1(entries)
    return toc
    
def render_with(template_name):
    """Decorator for request handlers. the decorated function returns a dict of template args."""
    def decorator(func):
        def decorated_func(request, *args, **kwargs):
            result = func(request, *args, **kwargs)
            if isinstance(result, HttpResponse):
                return result
            template_args = result
            return render_to_response(template_name, template_args, RequestContext(request)) 
        return decorated_func
    return decorator

@render_with('blog/entry.html')
def entry(request, blog_dir, blog_url, image_url, year=None, month=None, day=None):
    entries = get_entries(blog_dir, blog_url, image_url)
    y = year and int(year)
    m = month and int(month, 10)
    d = day and int(day, 10)
    entry, this_month, years = get_entry(entries, y, m, d)
    return {
        'entry': entry,
        'entries': entries,   
        'this_month': this_month, 
        'years': reversed(years),
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
def front_page(request, blog_dir, blog_url, image_url):
    return {}