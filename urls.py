from django.conf.urls.defaults import *
from django.conf import settings

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
urlpatterns = (
    patterns('alleged.blog.views',
        (r'^$', 'front_page', updated_dict(blog_args, is_svg_wanted=True), 'front_page'),
        (r'^ancient-browser-support$', 'front_page', updated_dict(blog_args, is_svg_wanted=False), 'front_page_sans_svg'),
        (r'^pdc/$', 'entry', blog_args, 'blog_entry'),
        (r'^pdc/(?P<year>[12][09][0-9][0-9])/(?P<month>[012][0-9])/(?P<day>[0-3][0-9])\.html$', 
            'entry', blog_args, 'blog_entry'),
        (r'^pdc/(?P<year>[12][09][0-9][0-9])/(?P<month>[012][0-9])\.html$', 
            'month_entries', blog_args, 'blog_month'),
        (r'^pdc/(?P<year>[12][09][0-9][0-9])/(?P<name>[a-z0-9_-]+)\.html$', 
            'named_article', blog_args, 'blog_named_article'),
        (r'^pdc/atom/current$', 'atom', blog_args, 'blog_atom'),
        (r'^pdc/atom/archive(?P<page_no>[1-9][0-9]*)$', 'atom', blog_args, 'blog_atom_archive'),
        (r'^pdc/atom/page(?P<page_no>-[1-9][0-9]*)$', 'atom', blog_args, 'blog_atom_archive'),
        (r'^pdc/tags/(?P<plus_separated_tags>[a-z0-9+-]+)$', 'filtered_by_tag', blog_args, 'blog_tag'))
    + patterns('',
        (r'^albums/', include('alleged.snaptioner.urls'))
        # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
        # to INSTALLED_APPS to enable admin documentation:
        # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

        # Uncomment the next line to enable the admin:
        # (r'^admin/', include(admin.site.urls)),
    )
)
