# Create your views here.

from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response 
from django.core.urlresolvers import reverse

from alleged.blog.entries import get_entries as get_entries_1, get_entry

def get_entries(blog_dir, blog_url, image_url):
    """Get the lust of blog entries."""
    entries = get_entries_1(blog_dir, blog_url, image_url)
    for entry in entries:
        entry.href = reverse('blog_entry', kwargs={
            #'blog_dir': blog_dir,
            'year': str(entry.published.year),
            'month': '%02d' % entry.published.month,
            'day': '%02d' % entry.published.day,
        })
    return entries
    
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

@render_with('front_page.html')
def front_page(request, blog_dir, blog_url, image_url):
    return {}