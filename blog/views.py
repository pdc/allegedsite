# Create your views here.

from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response 
from django.core.urlresolvers import reverse
from django.core.cache import cache

from datetime import date

from alleged.blog.entries import get_entries as get_entries_uncached, get_entry, get_toc as get_toc_uncached, get_named_article as get_named_article_uncached

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
        entries = get_entries_uncached(blog_dir, blog_url, image_url)
        add_hrefs(entries)
        for entry in entries:
            if not entry.is_loaded:
                entry.load()
        cache.set(blog_key, entries)
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
    
    
def get_year_months(entries, y):
    # Find the last aeticle in each month in this year,
    this_year_months = {}
    by_year = entries.get_by_year()
    this_year = by_year[y or date.today().year]
    for e in this_year:
        this_year_months[e.published.month] = e
    return sorted(this_year_months.items())

@render_with('blog/entry.html')
def entry(request, blog_dir, blog_url, image_url, year=None, month=None, day=None):
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
def front_page(request, blog_dir, blog_url, image_url):
    return {}
    

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
    