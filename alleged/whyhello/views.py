# -*-coding: UTF-8-*-

from django.conf import settings

from alleged.decorators import render_with
from alleged.blog.entries import get_entry
from alleged.blog.views import get_entries_cached

@render_with('whyhello/im.html')
def why_hello_im(request, blog_dir, blog_url, image_url):
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    entry, this_month, years = get_entry(entries, None, None, None)
    return {
        'entries': entries,
        'entry': entry,
        'this_month': this_month,
        'years': years,
        'is_index': True,
    }
