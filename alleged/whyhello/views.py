from datetime import datetime
import re

from django.conf import settings

from alleged.blog.entries import get_entry
from alleged.blog.views import get_entries_cached
from alleged.decorators import render_with
from alleged.fromatom import get_livejournal


@render_with("whyhello/im.html")
def why_hello_im(request, blog_dir, blog_url, image_url):
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    entry, this_month, years = get_entry(entries, None, None, None)
    return {
        "entries": entries,
        "entry": entry,
        "this_month": this_month,
        "years": years,
        "is_index": True,
    }


@render_with("whyhello/livejournal_snippet.html")
def livejournal_snippet(request):
    lj_json = get_livejournal(settings.LIVEJOURNAL_ATOM_URL)
    context = {
        "entries": [
            {
                "id": entry["id"],
                "href": entry["href"],
                "title": entry["title"],
                "published": datetime.fromisoformat(entry["published"]),
                "content": tag_re.sub("", entry["content"]),
            }
            for entry in lj_json["entries"][:3]
        ]
    }
    return context


tag_re = re.compile(r"<.*?>")
