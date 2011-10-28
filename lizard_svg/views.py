# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.txt.
from django.http import HttpResponse
from django.template import loader, RequestContext

# Create your views here.

def the_main_form(request, svg_name):
    t = loader.get_template('lizard_svg/index.html')
    c = RequestContext(request, {
        'svg_dot_svg': svg_name + ".svg",
    })
    return HttpResponse(t.render(c))
