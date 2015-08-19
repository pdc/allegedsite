# -*- coding: utf-8 -*-

from __future__ import unicode_literals

from django.conf.urls import url, include
from django.conf import settings
import alleged.frontpage.views
import alleged.whyhello.views
import alleged.blog.views

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

blog_args = {
    'blog_dir': settings.BLOG_DIR,
    'blog_url': '/pdc/',
    'image_url': settings.STATIC_URL + 'pdc/',
}


def updated_dict(d, *args, **kwargs):
    result = dict(d)
    result.update(*args, **kwargs)
    return result


snaptioner_args = {
    'library_dir': settings.SNAPTIONER_LIBRARY_DIR,
    'library_url': settings.SNAPTIONER_LIBRARY_URL,
}
urlpatterns = [
    url(r'^$', alleged.frontpage.views.front_page, updated_dict(blog_args, is_svg_wanted=True), 'front_page'),
    url(r'^ancient-browser-support$', alleged.frontpage.views.front_page, updated_dict(blog_args, is_svg_wanted=False),
        'front_page_sans_svg'),

    url(r'^pdc/$', alleged.whyhello.views.why_hello_im, blog_args, 'why_hello_im'),

    url(r'^pdc/(?P<year>[12][09][0-9][0-9])/', include([
        url(r'^(?P<month>[012][0-9])/(?P<day>[0-3][0-9])\.html$',
            alleged.blog.views.entry_view, blog_args, 'blog_entry'),
        url(r'^(?P<month>[012][0-9])\.html$',
            alleged.blog.views.month_entries, blog_args, 'blog_month'),
        url(r'^(?P<name>[a-z0-9_-]+)\.html$',
            alleged.blog.views.named_article, blog_args, 'blog_named_article'),
    ])),
    url(r'^pdc/react\.json$', alleged.blog.views.react_api, blog_args, 'blog-react-api'),
    url(r'^pdc/feeds/articles$',
        alleged.blog.views.atom, blog_args, 'blog_atom'),
    url(r'^pdc/feeds/articles-archive-(?P<page_no>[1-9][0-9]*)$',
        alleged.blog.views.atom, blog_args, 'blog_atom_archive'),
    url(r'^pdc/feeds/articles-paged(?P<page_no>-[1-9][0-9]*)$',
        alleged.blog.views.atom, blog_args, 'blog_atom_archive'),
    url(r'^pdc/tags/(?P<plus_separated_tags>[a-z0-9+-]+)$',
        alleged.blog.views.filtered_by_tag, blog_args, 'blog_tag'),
    url(r'^pdc/from/flickr$', alleged.blog.views.from_flickr, {}, 'from_flickr'),
    url(r'^pdc/from/livejournal$', alleged.blog.views.from_livejournal, {}, 'from_livejournal'),
    url(r'^pdc/from/youtube$', alleged.blog.views.from_youtube, {}, 'from_youtube'),
    url(r'^pdc/from/github$', alleged.blog.views.from_github, {}, 'from_github'),

    url(r'^albums/', include('alleged.snaptioner.urls'))
    # Uncomment the admin/doc line below and add 'django.contrib.admindocs'
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # (r'^admin/', include(admin.site.urls)),
]
