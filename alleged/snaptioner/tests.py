"""
This file demonstrates two different styles of tests (one doctest and one
unittest). These will both pass when you run "manage.py test".

Replace these with more appropriate tests for your application.
"""

from django.test import TestCase
from alleged.snaptioner.albums import get_albums, get_album

ALBUM_DIR = 'albums'

class LibraryTestCase(TestCase):
    def setUp(self):
        self.albums = get_albums(ALBUM_DIR)

    def test_count(self):
        """
        Should find 15 albums.
        """
        self.assertEqual(15, len(self.albums))

    def test_albums_in_list_same_as_albums_got_with_get_album(self):
        for album_name, album in self.albums.items():
            self.assertEqual(get_album(ALBUM_DIR, album_name), album)
            self.assertEqual(album_name, album.name)

class AlbumTestCase(TestCase):
    def setUp(self):
        self.album = get_album(ALBUM_DIR, 'ukwebcomix2004')

    def test_metadata(self):
        self.assertEqual('UK Web and Minicomix Thing 2004', self.album.title)
        self.assertEqual('Jeremy Day', self.album.photographer)

    def test_len(self):
        self.assertEqual(14, len(self.album))

    def test_file(self):
        self.assertEqual('01hairshop.jpg', self.album[0].file_name)

    def test_desc(self):
        self.assertEqual('Mardou with diminutive Antionette, the ice-hearted heroine of her comic Spiro.', self.album[1].description)

    def test_people(self):
        self.assertEqual(['Craig Conlan', 'Jenni Scott'], self.album[3].people)

class AviemoreTestCase(TestCase):
    def setUp(self):
        self.album = get_album(ALBUM_DIR, 'aviemore')

    def test_len(self):
        """"We expect pictures with score=Discard to be discarded."""
        self.assertEqual(30, len(self.album))

    def test_file(self):
        """"We expect pictures 992saj to be discarded."""
        self.assertEqual('992saa.jpg', self.album[0].file_name)
        self.assertEqual('992sai.jpg', self.album[8].file_name)
        self.assertEqual('992sak.jpg', self.album[9].file_name)

    def test_prev(self):
        self.assertEqual(None, self.album[0].prev)
        self.assertEqual(self.album[0], self.album[1].prev)
        self.assertEqual(self.album[1], self.album[2].prev)

    def test_next(self):
        self.assertEqual(self.album[1], self.album[0].next)
        self.assertEqual(self.album[2], self.album[1].next)
        self.assertEqual(None, self.album[-1].next)

class C98TestCase(TestCase):
    def setUp(self):
        self.album = get_album(ALBUM_DIR, 'c98-matt')

    def test_len(self):
        """"We expect pictures with score=Discard to be discarded."""
        self.assertEqual(19, len(self.album))
