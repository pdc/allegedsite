"""
This file demonstrates writing tests using the unittest module. These will pass
when you run "manage.py test".

Replace this with more appropriate tests for your application.
"""

from datetime import datetime, timezone
from unittest.mock import patch
from django.test import TestCase
from django.urls import reverse

from . import views


class SimpleTest(TestCase):
    def test_basic_addition(self):
        """
        Tests that 1 + 1 always equals 2.
        """
        self.assertEqual(1 + 1, 2)


class TestLivejournalSnippet(TestCase):

    def test_renders_livejournal_atom(self):
        # Given LiveJournal returns atom with story fragments …
        livejournal_json = {
            "entries": [
                {
                    "id": "urn:lj:livejournal.com:atom1:damiancugley:117010",
                    "href": "https://damiancugley.livejournal.com/117010.html",
                    "type": "text/html",
                    "self": {
                        "href": "https://damiancugley.livejournal.com/data/atom/?itemid=117010",
                        "type": "text/xml",
                    },
                    "title": "Picnic = Rain",
                    "published": "2016-08-30T07:34:02Z",
                    "content": "Friday! Watched Star Wars 7 again and it is still fabulous. Funny how the diecovery of the idea of women as background characters still seems exciting. \u2026",
                },
                {
                    "id": "urn:lj:livejournal.com:atom1:damiancugley:116857",
                    "href": "https://damiancugley.livejournal.com/116857.html",
                    "type": "text/html",
                    "self": {
                        "href": "https://damiancugley.livejournal.com/data/atom/?itemid=116857",
                        "type": "text/xml",
                    },
                    "title": "Holiday fun",
                    "published": "2016-08-13T08:08:20Z",
                    "content": 'Some time ago I ordered a Cliff TV Bench by TemaHOME from flash-sale site MONOQI. It arrived this week and Thursday <span  class="ljuser  i-ljuser  i-ljuser-type-P     "  data-ljuser="olwy" lj:user="olwy" >olwy assembled it and he inserted it under the TV while I was at the Oxfam Bookshop that evening. My sitting room now looks super contemporary and cool.  \u2026',
                },
            ]
        }

        # When we reqwuest the LiveJournal snippet …
        with (
            self.settings(LIVEJOURNAL_ATOM_URL="https://livejournal.example/atom.xml"),
            patch.object(
                views, "get_livejournal", return_value=livejournal_json
            ) as get_livejournal,
        ):
            result = self.client.get(reverse("livejournal_snippet"))

        # Then it renders it using the LiveJournal JSON.
        get_livejournal.assert_called_with("https://livejournal.example/atom.xml")
        self.assertEqual(result.status_code, 200)
        self.assertEqual(
            result.context["entries"],
            [
                {
                    "id": "urn:lj:livejournal.com:atom1:damiancugley:117010",
                    "href": "https://damiancugley.livejournal.com/117010.html",
                    "title": "Picnic = Rain",
                    "published": datetime(2016, 8, 30, 7, 34, 2, tzinfo=timezone.utc),
                    "content": "Friday! Watched Star Wars 7 again and it is still fabulous. Funny how the diecovery of the idea of women as background characters still seems exciting. \u2026",
                },
                {
                    "id": "urn:lj:livejournal.com:atom1:damiancugley:116857",
                    "href": "https://damiancugley.livejournal.com/116857.html",
                    "title": "Holiday fun",
                    "published": datetime(2016, 8, 13, 8, 8, 20, tzinfo=timezone.utc),
                    "content": "Some time ago I ordered a Cliff TV Bench by TemaHOME from flash-sale site MONOQI. It arrived this week and Thursday olwy assembled it and he inserted it under the TV while I was at the Oxfam Bookshop that evening. My sitting room now looks super contemporary and cool.  \u2026",
                },
            ],
        )
        self.assertEqual(result.templates[0].name, "whyhello/livejournal_snippet.html")
