# Encoding: UTF-8

from django.test import TestCase

from alleged.blog.entries import Link


class TestLink(TestCase):
    """Tests for Link."""

    def test_gets_url_and_rel(self):
        result = Link.parse("<https://example.com/foo>; rel=bar")

        self.assertEqual(result.url, "https://example.com/foo")
        self.assertEqual(result.rel, "bar")

    def test_gets_quoted_rel(self):
        result = Link.parse('<https://example.com/baz>; rel="quux"')

        self.assertEqual(result.url, "https://example.com/baz")
        self.assertEqual(result.rel, "quux")

    def test_handles_title_hreflang_etc(self):
        result = Link.parse(
            '<https://example.com/baz>; rel=quux; title="wibble"; type=application/json; hreflang=en; media=screen'
        )

        self.assertEqual(result.title, "wibble")
        self.assertEqual(result.type, "application/json")
        self.assertEqual(result.media, "screen")
        self.assertEqual(result.hreflang, "en")

    def test_acquires_silo_from_url(self):
        result = Link.parse("<https://twitter.com/pdc/123>; rel=syndication")

        self.assertEqual(result.silo.tag, "twitter")
        self.assertEqual(result.silo.label, "Twitter")

    def test_acquires_mestodon_from_octodon(self):
        # You just have to know!
        result = Link.parse(
            "<https://octodon.social/@pdc/100601703924310915>; rel=syndication"
        )

        self.assertEqual(result.silo.tag, "mastodon")
        self.assertEqual(result.silo.label, "Mastodon")
