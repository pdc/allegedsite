from django import template
from blog.entries import unentity

register = template.Library()

@register.filter
def rfc3339(value):
    """Format the value as an RFC 3339 date-time value.

    ASSUMES UTC TIME ZONE.
    """
    x = value.strftime('%Y-%m-%dT%H:%M:%S+00:00')
    return x

register.filter('unentity', unentity)