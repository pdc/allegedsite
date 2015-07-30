from django.http import HttpResponse, Http404
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.core.urlresolvers import reverse
from alleged.snaptioner.albums import get_albums


def render_with(template_name):
    def decorator(func):
        def decorated_func(request, *args, **kwargs):
            result = func(request, *args, **kwargs)
            if isinstance(result, HttpResponse):
                return result
            return render_to_response(template_name, result, context_instance=RequestContext(request))
        return decorated_func
    return decorator


def get_albums_with_hrefs(library_dir, library_url):
    albums = get_albums(library_dir)
    for album in albums.values():
        album.href = reverse('album_detail', kwargs={'album_name': album.name})
    return albums


def get_album_with_srcs(library_url, albums, album_name):
    album = albums[album_name]
    for image in album:
        image.href = reverse('image_detail', kwargs={'album_name': album.name, 'image_name': image.name})
        if hasattr(image, 'file_name'):
            image.src = '%s%s/%s' % (library_url, album.name, image.file_name)
            image.src_sans_http = image.src[7:]
            p = image.src.rindex('.')
            q = image.src.rindex('/')
            image.thumbnail_src = '%s/thumbs/%s-200w.jpeg' % (image.src[:q], image.src[q + 1:p])
            image.small_thumbnail_src = '%s/thumbs/%s-s110x140.jpeg' % (image.src[:q], image.src[q + 1:p])
    return album


@render_with('snaptioner/album_list.html')
def album_list(request, library_dir, library_url):
    albums = get_albums_with_hrefs(library_dir, library_url)
    for album_name in albums:
        get_album_with_srcs(library_url, albums, album_name)
    return {
        'albums': sorted(albums.values(), key=lambda album: album.name),
    }


@render_with('snaptioner/album_detail.html')
def album_detail(request, library_dir, library_url, album_name):
    albums = get_albums_with_hrefs(library_dir, library_url)
    album = get_album_with_srcs(library_url, albums, album_name)
    return {
        'albums': sorted(albums.values(), key=lambda album: album.name),
        'album': album,
    }


@render_with('snaptioner/image_detail.html')
def image_detail(request, library_dir, library_url, album_name, image_name):
    albums = get_albums_with_hrefs(library_dir, library_url)
    album = get_album_with_srcs(library_url, albums, album_name)
    for image in album:
        if image.name == image_name:
            break
    else:
        raise Http404()

    return {
        'albums': sorted(albums.values(), key=lambda album: album.name),
        'album': album,
        'image': image,
    }
