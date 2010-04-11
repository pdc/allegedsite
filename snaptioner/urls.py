from django.conf.urls.defaults import *
from django.conf import settings

essential_args = {
    'library_dir': settings.SNAPTIONER_LIBRARY_DIR,
    'library_url': settings.SNAPTIONER_LIBRARY_URL,
}

urlpatterns = patterns('alleged.snaptioner.views',
    (r'^$', 'album_list', essential_args, 'album_list'),
    (r'^(?P<album_name>[a-z0-9-]+)/$', 'album_detail', essential_args, 'album_detail'),
    (r'^(?P<album_name>[a-z0-9-]+)/(?P<image_name>[a-z0-9.-]+)$', 'image_detail', essential_args, 'image_detail')
    ##,
##    (r'^albums/(?P<album_name>[a-z0-9-]+)/(?P<image_name>[a-z0-9]+).(?P<max_width>[0-9]+)x(?P<max_height>[0-9]+)$', 'image_thumbnail', essential_args, 'image_thumbnail')
)
