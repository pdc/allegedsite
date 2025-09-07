from django.conf import settings
from django.urls import include, path, re_path

import alleged.blog.views
import alleged.frontpage.views
import alleged.whyhello.views

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

blog_args = {
    "blog_dir": settings.BLOG_DIR,
    "blog_url": "/pdc/",
    "image_url": settings.STATIC_URL + "pdc/",
}

snaptioner_args = {
    "library_dir": settings.SNAPTIONER_LIBRARY_DIR,
    "library_url": settings.SNAPTIONER_LIBRARY_URL,
}

urlpatterns = [
    path(
        "",
        alleged.frontpage.views.front_page,
        {**blog_args, "is_svg_wanted": True},
        name="front_page",
    ),
    path(
        "ancient-browser-support",
        alleged.frontpage.views.front_page,
        {**blog_args, "is_svg_wanted": False},
        name="front_page_sans_svg",
    ),
    path("pdc/", alleged.whyhello.views.why_hello_im, blog_args, name="why_hello_im"),
    path(
        "pdc/<int:year>/",
        include(
            [
                path(
                    "",
                    alleged.blog.views.year_nav_view,
                    blog_args,
                    name="blog_year",
                ),
                path(
                    "nav",
                    alleged.blog.views.entries_year_nav,
                    blog_args,
                    name="blog_year_nav",
                ),
                path(
                    "<int:month>/<int:day>.html",
                    alleged.blog.views.entry_view,
                    blog_args,
                    name="blog_entry",
                ),
                path(
                    "<int:month>.html",
                    alleged.blog.views.month_entries,
                    blog_args,
                    "blog_month",
                ),
                path(
                    "<int:month>/",
                    alleged.blog.views.month_entries,
                    blog_args,
                    "blog_month",
                ),
                path(
                    "<slug:name>.html",
                    alleged.blog.views.named_article,
                    blog_args,
                    name="blog_named_article",
                ),
            ]
        ),
    ),
    path("pdc/feeds/articles", alleged.blog.views.atom, blog_args, name="blog_atom"),
    path(
        "pdc/feeds/articles-archive-<int:page_no>",
        alleged.blog.views.atom,
        blog_args,
        name="blog_atom_archive",
    ),
    path(
        "pdc/feeds/articles-paged<int:page_no>",
        alleged.blog.views.atom,
        blog_args,
        name="blog_atom_archive",
    ),
    re_path(
        r"^pdc/tags/(?P<plus_separated_tags>[a-z0-9+-]+)$",
        alleged.blog.views.filtered_by_tag,
        blog_args,
        name="blog_tag",
    ),
    path("pdc/from/flickr", alleged.blog.views.from_flickr, {}, "from_flickr"),
    path(
        "pdc/from/livejournal",
        alleged.blog.views.from_livejournal,
        name="from_livejournal",
    ),
    path("pdc/from/youtube", alleged.blog.views.from_youtube, {}, name="from_youtube"),
    path("pdc/from/github", alleged.blog.views.from_github, {}, name="from_github"),
    path("albums/", include("alleged.snaptioner.urls")),
    # Uncomment the admin/doc line below and add 'django.contrib.admindocs'
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),
    # Uncomment the next line to enable the admin:
    # (r'^admin/', include(admin.site.urls)),
]
