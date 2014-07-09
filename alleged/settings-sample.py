# Django settings for alleged project.

import os

def expand_path(partial_path):
    return os.path.join(os.path.dirname(__file__), partial_path)

DEBUG = True
TEMPLATE_DEBUG = DEBUG

ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)

MANAGERS = ADMINS

DATABASES = {
    'default': {
        'NAME': 'a.db',
        'ENGINE': 'django.db.backends.sqlite3',
    }
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

# URL prefix for admin media -- CSS, JavaScript and images. Make sure to use a
# trailing slash.
# Examples: "http://foo.com/media/", "/media/".
ADMIN_MEDIA_PREFIX = '/media/'

SNAPTIONER_LIBRARY_DIR = expand_path('albums')
SNAPTIONER_LIBRARY_URL = 'http://localhost:8080/snaptioner/albums/'

BLOG_DIR = expand_path('content/pdc')
BLOG_CACHE_ENTRIES = False

HTTPLIB2_CACHE_DIR = '/Users/pdc/Library/Caches/httplib2'
FLICKR_ATOM_URL = 'http://api.flickr.com/services/feeds/photos_public.gne?id=14145351@N00&lang=en-us&format=atom'
LIVEJOURNAL_ATOM_URL = 'http://damiancugley.livejournal.com/data/atom'
YOUTUBE_ATOM_URL = 'http://gdata.youtube.com/feeds/base/users/damiancugley/uploads?alt=atom&v=2&orderby=published'

STATICFILES_DIRS = (
    expand_path('static'),
)
STATIC_URL = 'http://localhost:8080/alleged/'
STATIC_ROOT = '/Users/pdc/Sites/alleged'

CACHE_MIDDLEWARE_SECONDS = 30
CACHE_MIDDLEWARE_KEY_PREFIX = 'alleged'

# Make this unique, and don't share it with anybody.
SECRET_KEY = 'XXXXX'

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
)
