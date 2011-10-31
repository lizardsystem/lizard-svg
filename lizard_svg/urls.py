# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.txt.
from django.conf.urls.defaults import include
from django.conf.urls.defaults import patterns
from django.conf.urls.defaults import url
from django.contrib import admin


from lizard_ui.urls import debugmode_urlpatterns
from lizard_svg.views import stroomschema_rwzi
from lizard_svg.views import stroomschema
from lizard_svg.views import overview


admin.autodiscover()

urlpatterns = patterns(
    '',
    (r'^admin/', include(admin.site.urls)),
    (r'^ui/', include('lizard_ui.urls')),
    
    (r'^api/', include('lizard_svg.api.urls')),
    (r'^stroomschema_rwzi/(?P<svg_name>\w+)/$', stroomschema_rwzi),
    (r'^stroomschema/(?P<svg_name>\w+)/$', stroomschema),
    (r'^((?P<svg_name>\w+)/)?$', overview),
    # url(r'^something/',
    #     direct.import.views.some_method,
    #     name="name_it"),
    )
urlpatterns += debugmode_urlpatterns()
