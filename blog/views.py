# Create your views here.

from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response 
from django.core.urlresolvers import reverse

from alleged.blog.entries import get_entries as get_entries_1

def get_entries(blog_dir, blog_url, image_url):
    entries = get_entries_1(blog_dir, blog_url, image_url)
    for entry in entries:
        entry.href = reverse('blog_entry', kwargs={
            #'blog_dir': blog_dir,
            'year': str(entry.published.year),
            'month': '%02d' % entry.published.month,
            'day': '%02d' % entry.published.day,
        })
    return entries

def entry(request, blog_dir, blog_url, image_url, year=None, month=None, day=None):
    entries = get_entries(blog_dir, blog_url, image_url)
    y = year and int(year)
    m = month and int(month, 10)
    d = day and int(day, 10)
    this_year = [e for e in entries if e.published.year == y] if y else []
    this_month = [e for e in (this_year or entries) if e.published.month == y] if m else []
    this_day = [e for e in (this_month or this_year or entries) if e.published.day == d] if d else []
    entry = (this_day or this_month or this_year or entries)[-1]
    return render_to_response('blog/entry.html', {
        'entry': entry,
        'entries': entries,    
    }, RequestContext(request))
