"""
albums.py -- routines for reading lists of photos in a legacy format

Created by Damian Cugley on 2010-03-31.
© 2010, 2014 Damian Cugley. All rights reserved.
"""

import csv
import os
import re
from collections.abc import Sequence

from django.urls import reverse
from django.utils import safestring
from django.utils.functional import cached_property
from markdown import Markdown

formatter = Markdown()


class Image:
    # __slots__ = 'file_name', 'name', 'score', 'people', 'description', 'prev', 'next'
    def __init__(self, album, name, score):
        self.name = name
        self.score = score
        self.people = []

        self.href = reverse(
            "image_detail",
            kwargs={
                "album_name": album.name,
                "image_name": self.name,
            },
        )

    def set_src(self, library_url, album, file_name):
        self.file_name = file_name

        self.src = "%s%s/%s" % (library_url, album.name, file_name)
        self.src_sans_http = self.src.split(":", 1)[1]
        p = self.src.rindex(".")
        q = self.src.rindex("/")
        self.thumbnail_src = "%s/thumbs/%s-200w.jpeg" % (
            self.src[:q],
            self.src[q + 1 : p],
        )
        self.small_thumbnail_src = "%s/thumbs/%s-s110x140.jpeg" % (
            self.src[:q],
            self.src[q + 1 : p],
        )

    @cached_property
    def description_formatted(self):
        """An HTMLified version of the description field."""
        return safestring.mark_safe(formatter.convert(self.description))


class Album(Sequence):
    def __init__(self, library_dir, library_url, album_name, metadata):
        self.dir_name = os.path.join(library_dir, album_name)
        self.name = album_name

        self.title = metadata["Title"]
        self.photographer = metadata["Photographer"]
        self.description = metadata["Description"]
        self.old_href = metadata["URL"]
        self.href = reverse("album_detail", kwargs={"album_name": self.name})

        self.images = []
        self.images_by_name = {}
        prev = None
        with open(os.path.join(self.dir_name, "scores.dat"), "rt") as input:
            for line in input:
                image_name, score, _ = line.split(":")
                if score == "Discard":
                    continue
                image = Image(self, image_name, score)
                self.images.append(image)
                self.images_by_name[image.name] = image
                p = image_name.find("-")
                if p:
                    n = image_name[:p]
                    self.images_by_name[n] = image
                image.prev = prev
                if prev:
                    prev.next = image
                prev = image
        if prev:
            prev.next = None

        # Attemp to match file names to image names.
        for file_name in os.listdir(self.dir_name):
            p = file_name.rfind(".")
            if p > 0:
                image_name = file_name[:p]
                image = self.images_by_name.get(image_name)
                if image:
                    image.set_src(library_url, self, file_name)

        with open(os.path.join(self.dir_name, "descs.dat"), "rt") as input:
            for line in input:
                if line:
                    parts = line.split(":")
                    image_name = parts.pop(0)
                    description = ":".join(parts[:-1])
                    image = self.images_by_name.get(image_name)
                    if image:
                        image.description = description

        with open(os.path.join(self.dir_name, "people.dat"), "rt") as input:
            for line in input:
                if line:
                    parts = line.split(":")
                    image_name = parts.pop(0)
                    person = " ".join(parts[:-1])
                    image = self.images_by_name.get(image_name)
                    if image:
                        image.people.append(person)

    def __len__(self):
        return len(self.images)

    def __getitem__(self, key):
        return self.images[key]

    def __iter__(self):
        return self.images.__iter__()

    def __contains__(self, desired_image):
        for image in self.images:
            if image.name == desired_image.name:
                return True
        return False

    def __repr__(self):
        return "Album(%s, %s)" % (repr(os.path.dirname(self.dir_name)), repr(self.name))

    def __str__(self):
        return self.name

    @cached_property
    def description_formatted(self):
        """An HTMLified version of the description field."""
        return safestring.mark_safe(formatter.convert(self.description))


def _albums_iter(library_dir, library_url, album_metadata):
    for dir_name, subdirs, files in os.walk(library_dir):
        if "scores.dat" in files:
            _, album_name = os.path.split(dir_name)
            yield Album(
                library_dir, library_url, album_name, album_metadata.get(album_name)
            )
        try:
            subdirs.remove(".xvpics")
        except ValueError:
            pass


PUNCT_PAT = re.compile(r"[^\w+]")


class Person:
    """Information about a person in one or more photos."""

    def __init__(self, code, name):
        """Create an instance with this name."""
        self.code = code
        self.name = name
        self.occurrences = []

    @staticmethod
    def make_code(name):
        return ".".join(PUNCT_PAT.sub("", x) for x in name.split()).lower()

    def __str__(self):
        return self.name


class Library:
    """A collection of albums.

    Each album is a directory within this directory.
    There may be a file albums.csv that gives extra metadata.
    """

    def __init__(self, library_dir, library_url):
        self.dir_name = library_dir

        album_metadata = {}
        with open(os.path.join(library_dir, "albums.csv"), "r") as input:
            reader = csv.DictReader(input)
            for meta in reader:
                album_metadata[meta["Album"]] = meta

        self.albums = dict(
            (album.name, album)
            for album in _albums_iter(library_dir, library_url, album_metadata)
        )

        # Build map from person code to person with occurrences.
        self.people = {}
        for album in self.albums.values():
            for image in album.images:
                image_people = []
                for name in image.people:
                    code = Person.make_code(name)
                    person = self.people.get(code)
                    if person is None:
                        person = self.people[code] = Person(code, name)
                    image_people.append(person)
                    person.occurrences.append((album, image))
                # Replace list of names with list of Person instances.
                image.people = image_people


_libraries = {}


def get_library(library_dir, library_url):
    """Load a collection of albums from directories on disk."""
    library = _libraries.get(library_dir)
    if library is None:
        library = Library(library_dir, library_url)
        _libraries[library_dir] = library
    return library


def get_albums(library_dir, library_url):
    """Load the albums that are themselves directories in this directory.

    Returns -- map from album name to Album instance.
    """
    return get_library(library_dir, library_url).albums


def get_album(library_dir, library_url, name):
    return get_albums(library_dir, library_url)[name]
