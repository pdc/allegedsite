Title: Behold! As I Mock Time!
Date: 2011-09-03
Topics: programming  testing python pun
Image: ../icon-64x64.png

I believe in [Test-Driven Development][] but had somehow hand never
gotten around to using [mock object][]s until a few months ago. They’re
super-useful when testing classes that write to files or query remote
databases or what-have-you, or when the rest of your system is big and
hairy and setting up tests takes ridiculously more work than the test
itself.

Python has a nifty third-party package called [Mock][] that supplies a
mock-object class and a method decorator `patch` that can be used to patch existing
objects with mocks. Here’s an example from the tests for [Texturepacker][]

    import unittest
    from mock import Mock, patch
    …

    class ExternalResourceTests(TestCase):
        …
        @patch('__builtin__.open')
        def test_internal_url(self, mock_open):
            mock_open.return_value = StringIO('fish')
            url = 'minecraft:texturepacks/foo.tprx'
            spec = self.loader.maybe_get_spec({'href': url}, base=None)
            self.assertEqual('fish', spec)
            self.assertTrue(mock_open.called)

            expected_path = os.path.join(minecraft_texture_pack_dir_path(), 'foo.tprx')
            self.assertEqual(expected_path, mock_open.call_args[0][0])
            self.assertTrue(mock_open.call_args[0][1].startswith('r'))

Here I wanted to see whether the `Loader` object opens the correct
file—even though the file and directory in question might not exist on
some systems. By replacing the built-in `open` function with a fake
(`mock_open`) I can make it return a known value and also check that the
function was called and with the args as expected.

To understand the pun in the headline, you merely need to know that we
often use ‘mock’ as a verb meaning replacing a real object with a mock
one.

Yesterday I was working on code that fetches billing information for
users, adding checks that the bills are current (rather than being three
randomly selected bills, or old bills because the account has been
closed).

One way to test this would be to create my test data using
`datetime.now() + timedelta(days=-30)` and suchlike so that the dates
are all relative to today’s date. This makes the tests very cluttered
and hard to read. (Remember one of the purposes of unit tests is
documenting the interface to the code.) So instead with a little digging
I managed to patch the `time.time` library function with a stub:

    import unittest
    from mock import *
    from datetime import datetime, timedelta
    import time

    mock_time = Mock()
    mock_time.return_value = time.mktime(datetime(2011, 6, 21).timetuple())

    class TestCrawlerChecksDates(unittest.TestCase):
        @patch('time.time', mock_time)
        def test_mock_datetime_now(self):
            self.assertEqual(datetime(2011, 6, 21), datetime.now())

Voilà! I mock time!





  [Test-Driven Development]: http://c2.com/cgi/wiki?TestDrivenDevelopment
  [mock object]: http://www.martinfowler.com/articles/mocksArentStubs.html
  [Mock]: http://www.voidspace.org.uk/python/mock/
  [Texturepacker]: http://pdc.github.com/texturepacker/