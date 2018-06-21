# -*- coding: utf-8 -*-


from django.conf.urls import url
from django.conf import settings
import alleged.snaptioner.views


essential_args = {
    'library_dir': settings.SNAPTIONER_LIBRARY_DIR,
    'library_url': settings.SNAPTIONER_LIBRARY_URL,
}


urlpatterns = [
    url(r'^$',
        alleged.snaptioner.views.album_list, essential_args, 'album_list'),
    url(r'^(?P<album_name>[a-z0-9-]+)/$',
        alleged.snaptioner.views.album_detail, essential_args, 'album_detail'),
    url(r'^(?P<album_name>[a-z0-9-]+)/(?P<image_name>[a-z0-9.-]+)$',
        alleged.snaptioner.views.image_detail, essential_args, 'image_detail'),
]
