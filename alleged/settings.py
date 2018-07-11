# Django settings for alleged project.

import os

import environ
env = environ.Env(
    DEBUG=(bool, False),
    STATIC_ROOT=(str, None),
    STATIC_URL=(str, None),
)
expand_path = environ.Path(__file__) - 2
environ.Env.read_env(expand_path('.env'))

DEBUG = env('DEBUG')
TEMPLATE_DEBUG = DEBUG

ALLOWED_HOSTS = [
    'localhost:8000',
    'alleged.org.uk',
]

TEST_RUNNER = 'django.test.runner.DiscoverRunner'

ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)

MANAGERS = ADMINS

DATABASES = {
    'default': env.db(default='sqlite:///%s' % expand_path('a.db')),
}

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'Europe/London'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en-GB'

SITE_ID = 1

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = False

# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"
MEDIA_ROOT = ''

# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash if there is a path component (optional in other cases).
# Examples: "http://media.lawrence.com", "http://example.com/media/"
MEDIA_URL = ''

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            # ... some options here ...
        },
    },
]


SNAPTIONER_LIBRARY_DIR = expand_path('albums')
SNAPTIONER_LIBRARY_URL = 'http://static.alleged.org.uk/albums/'

BLOG_DIR = expand_path('content/pdc')
BLOG_CACHE_ENTRIES = False

HTTPLIB2_CACHE_DIR = '/Users/pdc/Library/Caches/allegedsite-http'
FLICKR_ATOM_URL = 'http://api.flickr.com/services/feeds/photos_public.gne?id=14145351@N00&lang=en-us&format=atom'
LIVEJOURNAL_ATOM_URL = 'http://damiancugley.livejournal.com/data/atom'
YOUTUBE_ATOM_URL = 'http://gdata.youtube.com/feeds/base/users/damiancugley/uploads?alt=atom&v=2&orderby=published'
GITHUB_ATOM_URL = 'https://github.com/pdc.atom'

STATICFILES_DIRS = (
    expand_path('static'),
)

if env('STATIC_ROOT'):
    STATIC_URL = env('STATIC_URL', default='http://static.alleged.org.uk/')
    STATIC_ROOT = env('STATIC_ROOT')  # e.g., '/home/alleged/static')
else:
    STATIC_URL = '/s/'

CACHE_MIDDLEWARE_SECONDS = 30
CACHE_MIDDLEWARE_KEY_PREFIX = 'alleged'

# Make this unique, and don't share it with anybody.
SECRET_KEY = env('SECRET_KEY')

MIDDLEWARE_CLASSES = (
    'django.middleware.cache.UpdateCacheMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django.middleware.cache.FetchFromCacheMiddleware',
)

ROOT_URLCONF = 'alleged.urls'

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.staticfiles',

    'alleged.snaptioner',
    'alleged.blog',
    'alleged.frontpage',
    'alleged.whyhello',
)
