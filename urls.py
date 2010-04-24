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
snaptioner_args = {
    'library_dir': settings.SNAPTIONER_LIBRARY_DIR,
    'library_url': settings.SNAPTIONER_LIBRARY_URL,
}
urlpatterns = patterns('',
    (r'^$', 'alleged.blog.views.entry', blog_args, 'blog_entry'),
    (r'^albums/', include('alleged.snaptioner.urls')),
    (r'^pdc/(?P<year>[12][09][0-9][0-9])/(?P<month>[012][0-9])/(?P<day>[0-3][0-9])\.html$', 
        'alleged.blog.views.entry', blog_args, 'blog_entry')
    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # (r'^admin/', include(admin.site.urls)),
)
