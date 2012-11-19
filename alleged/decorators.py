# -*-coding: UTF-8-*-

from django.http import HttpResponse, HttpResponseRedirect, HttpResponseServerError
from django.template import RequestContext
from django.shortcuts import render_to_response

def render_with(default_template_name, mimetype='text/html'):
    """Decorator for request handlers.

    The decorated function returns a dict of template args.
    These are rendered with the named template.

    Arguments --
        default_template_name -- names the template, if the
            dictionary does not include an entry ‘template_name’.
        mimetype -- the MIME content-type for the
            response; default is 'text/html'.

    Returns --
        Either a dictionary of template args,
        or an HttpResponse obejct to return verbatim.
    """
    def decorator(func):
        def decorated_func(request, *args, **kwargs):
            result = func(request, *args, **kwargs)
            if isinstance(result, HttpResponse):
                return result
            template_name = result.pop('template_name') if 'template_name' in result else default_template_name
            template_args = result
            return render_to_response(template_name, template_args, RequestContext(request), mimetype=mimetype)
        return decorated_func
    return decorator
