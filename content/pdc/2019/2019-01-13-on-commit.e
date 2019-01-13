Title: Testing Celeryfied Signalized Django Models
Date: 2019-01-13
Topics: django celery python
Link: <https://octodon.social/@pdc/101410662261562458>; rel=syndication
Link: <https://twitter.com/damiancugley/status/1084516463912861697>; rel=syndication

Here’s a quick note about how to write tests for [Django][] models that need to
queue [Celery][] tasks when they are created.


# The Obvious Way

I have model `Locator`. When it is created I want it to queue a Celery task to
asynchronously fetch and process a web page. [First write a test][] that looks something like this:

    class TestLocator(TestCase):
        …

        def test_queues_fetch_when_locator_created(self):
            with self.settings(NOTES_FETCH_LOCATORS=True), \
                    patch.object(tasks, 'fetch_locator_page') as fetch_locator_page:
                locator = Locator.objects.create(url='https://example.com/1')

            fetch_locator_page.delay.assert_called_once_with(
                locator.pk,
                if_not_fetched_since=None)

The `NOTES_FETCH_LOCATORS` setting will normally be false when running tests: it
avoids having to clutter all other tests with patches to prevent irrelevant
tasks from being queued.

The implementation is a handler for the `post_save` signal:

    def on_locator_post_save(sender, instance, created, **kwargs):
        if created and settings.NOTES_FETCH_LOCATORS:
            instance.queue_fetch_page()

where the `queue_fatch_page` method is just a wrapper around invoking the
`delay` method of the task, something like this:

    class Locator(models.Model):
        …

        def queue_fetch_page(self):
            """Arrange for page to be fetched."""
            from . import tasks

            t = self.fetched.timestamp() if self.fetched else None
            tasks.fetch_locator_page.delay(self.pk, if_not_fetched_since=t)

(The `import` is inside the function because it cannot go at the top of the
module without creating circular imports.) I also needed to write some code in
the `apps.py` to add `ready` method that wires the signal handler to the
signal.

There is a problem with this, however.


# The Problem

All the automated tests worked fine but when I tried creating `Locator`
instances on a running server I got `Locator.DoesNotExist` exceptions raised
in the Celery worker processor. Naturally I could check and see that the
locator in question *did* exist. Mysterious!

The cause was (of course) a race condition, in this case a race between

1. Celery
queuing the task and it in turn attempting to retrieve the Locator entity from the
database, and
2. the transaction that creates the entity completing so that the
entity is there to be retrieved.


# The Fix: transaction.on_commit

If I were the perfectly logical TDD programmer I would at this point have
rewritten the test to ensure the task is queued outside the transaction. As it
was I didn’t think of this until later but let’s pretend I did:

    class TestLocator(TestCase):
        …

        def test_queues_fetch_when_locator_created(self):
            with self.settings(NOTES_FETCH_LOCATORS=True), \
                    patch.object(tasks, 'fetch_locator_page') as fetch_locator_page:
                with transaction.atomic():
                    locator = Locator.objects.create(url='https://example.com/1')

                    self.assertFalse(fetch_locator_page.delay.called)

            fetch_locator_page.delay.assert_called_once_with(
                locator.pk,
                if_not_fetched_since=None)

As of Django 1.9 there is a mechanism for achieving this:
<code>[transaction.on_commit][]</code> queues a hook function to be called
when the current transaction commits. So all we need is a minor change to the
queue method:

    class Locator(models.Model):
        …

        def queue_fetch_page(self):
            """Arrange for page to be fetched."""
            from . import tasks

            t = self.fetched.timestamp() if self.fetched else None
            transaction.on_commit(
                lambda: tasks.fetch_locator_page.delay(self.pk, if_not_fetched_since=t))

If the creation of the Locator instance is inside a transaction then this
ensures we wait until it is known to exist before we queue the task that
requires it. If there is no wrapping transaction then `on_commit` calls the
hook immediately, so it works either way.


# The Problem with the Fix, and a Fix for That

The trouble is I could not get the unit tests to pass: the mock function
`delay`  was not being called. The cause of this is that the tests are
themselves all run within `transaction.atomic()`, so the `on_commit` hook is
not called until after the outer transaction, thus after the test has completed.

I tried various things before doing what in retrospect is the obvious fix: use
a different `TestCase` subclass that does not wrap tests in a transaction. This
is in fact its superclass <code>[TransactionTestCase][]</code>, which instead
of using transactions to reset the database after each test, truncates the
database tables explicitly.


# Lessons

Everything I needed to fix this problem was nicely documented in Django’s
excellent website as footnotes to the respective features of the framework.
This entry just draws together the scattered threads so I will do it right
first time next time.

Moral: There is never a good time to not be worrying about concurrency in
today’s crazy, messed-up world.


  [First write a test]:http://wiki.c2.com/?CodeUnitTestFirst
  [Celery]: http://www.celeryproject.org
  [Django]: https://www.djangoproject.com
  [transaction.on_commit]: https://docs.djangoproject.com/en/2.1/topics/db/transactions/#performing-actions-after-commit
  [TransactionTestCase]: https://docs.djangoproject.com/en/2.1/topics/testing/tools/#transactiontestcase
