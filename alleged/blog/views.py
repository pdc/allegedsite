from dataclasses import asdict
from datetime import date

from django.conf import settings
from django.core.cache import cache
from django.http import HttpResponseServerError
from django.urls import reverse
from django.views.decorators.cache import cache_page

from alleged.blog.entries import get_entries as get_entries_uncached
from alleged.blog.entries import get_entry
from alleged.blog.entries import get_named_article as get_named_article_uncached
from alleged.blog.entries import get_toc as get_toc_uncached
from alleged.decorators import render_json, render_with
from alleged.fromatom import get_flickr, get_github, get_livejournal, get_youtube


def add_hrefs(entries):
    """Ensure that the entries in this list have hrefs."""
    for entry in entries:
        if not hasattr(entry, "href"):
            entry.href = reverse(
                "blog_entry",
                kwargs={
                    "year": str(entry.published.year),
                    "month": "%02d" % entry.published.month,
                    "day": "%02d" % entry.published.day,
                },
            )


def get_entries_cached(blog_dir, blog_url, image_url):
    """Get the list of blog entries.

    Arguments --
        blog_dir -- contains subdirectories named after years.
        blog_url -- the common prefix to blog entries; ends with a slash.
        image_url -- the common prefix for images referred to by blog entries;
            ends with a slash.
    """
    if settings.BLOG_CACHE_ENTRIES:
        blog_key = "blog:%s" % blog_dir
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
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    toc = get_toc_uncached(entries)
    return toc


def get_named_article(blog_dir, blog_url, image_url, year, name):
    article_key = "blog:%s,%d,%s" % (blog_dir, year, name)
    article = cache.get(article_key)
    if not article:
        article = get_named_article_uncached(blog_dir, blog_url, image_url, year, name)
        cache.set(article_key, article)
    return article


def get_year_months(entries, y):
    """Find the last article in each month in this year.

    These are used as the per-month article index.
    """
    this_year_months = {}
    by_year = entries.get_by_year()
    this_year = by_year[y or date.today().year]
    for e in this_year:
        this_year_months[e.published.month] = e
    return sorted(this_year_months.items())


@render_with("blog/year_nav.html")
def year_nav_view(request, blog_dir, blog_url, image_url, year):
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    year_nav = entries.get_year_nav(year)
    year_nav.open = True
    for month_nav in year_nav.months:
        month_nav.open = True
    years = sorted(set(x.published.year for x in entries), reverse=True)
    return {
        "year_nav": year_nav,
        "years": years,
    }


@render_with("blog/entry.html")
def entry_view(request, blog_dir, blog_url, image_url, year, month, day):
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    entry, this_month, years = get_entry(entries, year, month, day)

    return {
        "entries": entries,
        "entry": entry,
        "this_month": this_month,
        "years": years,  # Can we deprecate this?
        "nav": asdict(entries.get_nav_for_entry(entry)),
        "this_year_months": get_year_months(entries, year),
        "is_index": False,
        "syndication_links": [k for k in entry.links if k.rel == "syndication"],
    }


@cache_page(1800)
@render_with("blog/parts/entry-nav-year.part.html")
def entries_year_nav(request, blog_dir, blog_url, image_url, year):
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    data = entries.get_year_nav(year)
    data.open = data.months[0].open = True
    return {"year_nav": (data)}


@render_with("blog/month_entries.html")
def month_entries(request, blog_dir, blog_url, image_url, year, month):
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    entry, this_month, years = get_entry(entries, year, month, None)
    nav = entries.get_nav_for_month(year, month)

    return {
        "entry": entry,
        "entries": entries,
        "this_month": this_month,
        "prev": this_month[0].prev,
        "next": this_month[-1].next,
        "years": years,
        "nav": nav,
        "this_year_months": get_year_months(entries, year),
    }


@render_with("blog/filtered_by_tag.html")
def filtered_by_tag(request, blog_dir, blog_url, image_url, plus_separated_tags):
    tags = sorted(plus_separated_tags.split("+"))
    matching_entries = get_toc(blog_dir, blog_url, image_url)
    for tag in tags:
        matching_entries = matching_entries.filter(tag=tag)
    if len(matching_entries.selected_tag_infos) > 1:
        for info in matching_entries.selected_tag_infos:
            info_tags = list(tags)
            info_tags.remove(info.tag)
            info.href = reverse(
                "blog_tag", kwargs={"plus_separated_tags": "+".join(sorted(info_tags))}
            )

    for info in matching_entries.available_tag_infos:
        info_tags = list(tags)
        info_tags.append(info.tag)
        info.href = reverse(
            "blog_tag", kwargs={"plus_separated_tags": "+".join(sorted(info_tags))}
        )

    return {
        "tags": tags,
        "plus_separated_tags": plus_separated_tags,
        "matching_entries": matching_entries,
    }


@render_with("blog/named_article.html")
def named_article(request, blog_dir, blog_url, image_url, year, name):
    article = get_named_article(blog_dir, blog_url, image_url, year, name)
    # Needed for archive navigation:
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    entry, this_month, years = get_entry(entries, year, None, None)
    return {
        "article": article,
        "years": years,
        "this_year_months": get_year_months(entries, year),
    }


ATOM_PAGE_SIZE = 15


@render_with("blog/atom.xml", mimetype="application/atom+xml")
def atom(request, blog_dir, blog_url, image_url, page_no=None):
    """Generate one of the ATOM feed pages.

    The page number contrls which entries are included in the page.
    Just to be tricky, I am attempting to include archive-style
    feed and latest-changes-type feed in one system:

    • Positive pages are archive pages, counting up from earliest page.

    • Negative pages are paged-feed pages, counting down from -1 being the second-most-recent.

    • There is no page 0. Instead we have page None for the subscription page
      (which is the most-recent page in the paged-feed pages).
    """
    entries = get_entries_cached(blog_dir, blog_url, image_url)
    # Just to be tricky:
    # • Positive pages are archive pages, counting up from earliest page.
    # • Negative pages are paged-feed pages, counting down from -1 being the second-most-recent.
    # • There is no page 0. Instead we have page None for the subscription page
    #   (which is the most-recent page in the paged-feed pages).
    if page_no is not None:
        page_no = int(page_no)
    if page_no:
        start = (page_no - 1) * ATOM_PAGE_SIZE
        end = page_no * ATOM_PAGE_SIZE
        subset = entries[start:end]
    else:
        subset = entries[-ATOM_PAGE_SIZE:]
    subset.reverse()

    context_data = {
        "page_no": page_no,
        "absolute_page_no": -page_no if page_no and page_no < 0 else page_no,
        "entries": entries,
        "subset": subset,
        "updated": subset[-1].published,
        "is_index": not page_no,
        "is_archive": page_no and page_no > 0,
        "is_paged": page_no and page_no < 0,
    }

    prev_page_no = (
        (1 + (len(entries) - 1) // ATOM_PAGE_SIZE)
        if page_no is None
        else (page_no - 1) if page_no > 1 else (page_no + 1) if page_no < 1 else None
    )
    next_page_no = (
        -1
        if page_no is None
        else (
            (page_no + 1)
            if page_no > 0 and page_no * ATOM_PAGE_SIZE < len(entries)
            else (
                (page_no - 1)
                if page_no < 0 and (page_no - 1) * ATOM_PAGE_SIZE + len(entries) > 0
                else None
            )
        )
    )

    links = [
        (
            "self",
            (
                reverse("blog_atom_archive", kwargs={"page_no": page_no})
                if page_no
                else reverse("blog_atom")
            ),
        ),
    ]
    if page_no:
        links.append(("current", reverse("blog_atom")))
    else:
        links.insert(0, (None, blog_url))
    for name, p_no in [("prev", prev_page_no), ("next", next_page_no)]:
        if p_no:
            rel = (
                "previous"
                if name == "prev" and p_no < 0
                else "{name}{archived}".format(
                    name=name, archived="-archive" if p_no > 0 else ""
                )
            )
            href = request.build_absolute_uri(
                reverse("blog_atom_archive", kwargs={"page_no": str(p_no)})
            )
            links.append((rel, href))
    if not page_no or page_no < 0:
        links.append(("first", reverse("blog_atom")))

        p = -((len(entries) - 1) // ATOM_PAGE_SIZE)
        links.append(("last", reverse("blog_atom_archive", kwargs={"page_no": p})))

    context_data["links"] = [(r, request.build_absolute_uri(h)) for (r, h) in links]
    return context_data


def from_atom(func, url, label):
    ndix = func(url)
    if not ndix:
        HttpResponseServerError(
            "Could not get Atom data from {label}".format(label=label)
        )
    ndix["success"] = True
    return ndix


@cache_page(1800)
@render_json
def from_flickr(request):
    return from_atom(get_flickr, settings.FLICKR_ATOM_URL, "Flickr")


@cache_page(1800)
@render_json
def from_livejournal(request):
    return from_atom(get_livejournal, settings.LIVEJOURNAL_ATOM_URL, "LiveJournal")


# @cache_page(1800)
@render_json
def from_github(request):
    return from_atom(get_github, settings.GITHUB_ATOM_URL, "GitHub")


@cache_page(1800)
@render_json
def from_youtube(request):
    return from_atom(get_youtube, settings.YOUTUBE_ATOM_URL, "YouTube")
