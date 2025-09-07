from django.conf import settings
from django.urls import path, register_converter

from . import views

essential_args = {
    "library_dir": settings.SNAPTIONER_LIBRARY_DIR,
    "library_url": settings.SNAPTIONER_LIBRARY_URL,
}


class CodeConverter:
    regex = r"[a-z0-9.-]+"

    def to_python(self, value):
        return value

    def to_url(self, value):
        return value


register_converter(CodeConverter, "code")


urlpatterns = [
    path("", views.album_list, essential_args, name="album_list"),
    path(
        "people/<code:person_code>",
        views.person_detail,
        essential_args,
        name="person_detail",
    ),
    path(
        "<code:album_name>/",
        views.album_detail,
        essential_args,
        name="album_detail",
    ),
    path(
        r"<code:album_name>/<code:image_name>",
        views.image_detail,
        essential_args,
        name="image_detail",
    ),
]
