# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.txt.
from django.conf.urls.defaults import include
from django.conf.urls.defaults import patterns
from django.conf.urls.defaults import url
from django.contrib import admin

from lizard_ui.urls import debugmode_urlpatterns
from django.views.generic.simple import direct_to_template

admin.autodiscover()

urlpatterns = patterns(
    '',
    (r'^admin/', include(admin.site.urls)),
    (r'^ui/', include('lizard_ui.urls')),
    
    (r'^foo/$',             direct_to_template, {'template': 'lizard_svg/index.html'}),
    (r'^foo/(?P<id>\d+)/$', direct_to_template, {'template': 'lizard_svg/detail.html'}),
    (r'^api/', include('lizard_svg.api.urls')),
    # url(r'^something/',
    #     direct.import.views.some_method,
    #     name="name_it"),
    )
urlpatterns += debugmode_urlpatterns()
