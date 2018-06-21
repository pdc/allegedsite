# -*-coding: UTF-8-*-

from django.http import HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
import json


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
            context = result
            return render_to_response(template_name, context, content_type=mimetype)
        return decorated_func
    return decorator


def render_json(view):
    """Decorator for view function returning a dictionary to be rendered as JSON.

    Write the view function as usual, except it returns a dict
    not a response object.
    If the function being decorated returns an HttpResponse subclass
    instead, that is returned unchanged.
    """
    def decorated_view(request, *args, **kwargs):
        resp = view(request, *args, **kwargs)
        if isinstance(resp, HttpResponse):
            return resp
        data = json.dumps(resp)
        return HttpResponse(data, content_type='application/json; charset=UTF-8')
    return decorated_view
