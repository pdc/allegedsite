from django.http import Http404
from django.shortcuts import render

from .albums import get_albums, get_library


def album_list(request, library_dir, library_url):
    albums = get_albums(library_dir, library_url)
    return render(
        request,
        "snaptioner/album_list.html",
        {
            "albums": sorted(albums.values(), key=lambda album: album.name),
        },
    )


def album_detail(request, library_dir, library_url, album_name):
    albums = get_albums(library_dir, library_url)
    album = albums[album_name]
    album.absolute_href = request.build_absolute_uri(album.href)
    return render(
        request,
        "snaptioner/album_detail.html",
        {
            "albums": sorted(albums.values(), key=lambda album: album.name),
            "album": album,
        },
    )


def image_detail(request, library_dir, library_url, album_name, image_name):
    albums = get_albums(library_dir, library_url)
    album = albums[album_name]
    try:
        image = album.images_by_name[image_name]
    except KeyError:
        raise Http404()
    image.absolute_href = request.build_absolute_uri(image.href)

    return render(
        request,
        "snaptioner/image_detail.html",
        {
            "albums": sorted(albums.values(), key=lambda album: album.name),
            "album": album,
            "image": image,
        },
    )


def person_detail(request, library_dir, library_url, person_code):
    library = get_library(library_dir, library_url)
    person = library.people.get(person_code)
    if not person:
        raise Http404()
    return render(
        request,
        "snaptioner/person_detail.html",
        {
            "albums": sorted(library.albums.values(), key=lambda album: album.name),
            "person": person,
        },
    )
