"""Django settings for alleged project."""

from pathlib import Path
import environ


# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


env = environ.Env(
    DEBUG=(bool, False),
    STATIC_ROOT=(str, None),
    STATIC_URL=(str, None),
    SECRET_KEY=str,
    ALLOWED_HOSTS=(list, ["localhost", "127.0.0.1", "::1"]),
)
environ.Env.read_env(BASE_DIR / ".env")

DEBUG = env("DEBUG")

ALLOWED_HOSTS = env("ALLOWED_HOSTS")

TEST_RUNNER = "django.test.runner.DiscoverRunner"

ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)

MANAGERS = ADMINS

DATABASES = {
    "default": env.db(default=f"sqlite:///{(BASE_DIR / "db.sqlite3")}"),
}

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = "Europe/London"

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = "en-GB"

SITE_ID = 1

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = False

USE_TZ = True

# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"
MEDIA_ROOT = ""

# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash if there is a path component (optional in other cases).
# Examples: "http://media.lawrence.com", "http://example.com/media/"
MEDIA_URL = ""

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "debug": DEBUG,
        },
    },
]


SNAPTIONER_LIBRARY_DIR = BASE_DIR / "albums"
SNAPTIONER_LIBRARY_URL = "https://static.alleged.org.uk/albums/"

BLOG_DIR = BASE_DIR / "content/pdc"
BLOG_CACHE_ENTRIES = False

HTTPLIB2_CACHE_DIR = env("HTTPLIB2_CACHE_DIR")
FLICKR_ATOM_URL = "http://api.flickr.com/services/feeds/photos_public.gne?id=14145351@N00&lang=en-us&format=atom"
LIVEJOURNAL_ATOM_URL = "http://damiancugley.livejournal.com/data/atom"
YOUTUBE_ATOM_URL = "http://gdata.youtube.com/feeds/base/users/damiancugley/uploads?alt=atom&v=2&orderby=published"
GITHUB_ATOM_URL = "https://github.com/pdc.atom"

STATICFILES_DIRS = [
    BASE_DIR / "static",
]

if env("STATIC_ROOT"):
    STATIC_URL = env("STATIC_URL", default="http://static.alleged.org.uk/")
    STATIC_ROOT = env("STATIC_ROOT")  # e.g., '/home/alleged/static')
    if not DEBUG:
        STATICFILES_STORAGE = (
            "django.contrib.staticfiles.storage.ManifestStaticFilesStorage"
        )
else:
    STATIC_URL = "/s/"

CACHE_MIDDLEWARE_SECONDS = 30
CACHE_MIDDLEWARE_KEY_PREFIX = "alleged"
CACHES = {"default": env.cache(default="locmemcache:")}

# Make this unique, and don't share it with anybody.
SECRET_KEY = "secret-key-value" if DEBUG else env("SECRET_KEY")

MIDDLEWARE = [
    "django.middleware.cache.UpdateCacheMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "allegedsite.urls"

INSTALLED_APPS = (
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.sites",
    "django.contrib.staticfiles",
    "alleged.snaptioner",
    "alleged.blog",
    "alleged.frontpage",
    "alleged.whyhello",
)
