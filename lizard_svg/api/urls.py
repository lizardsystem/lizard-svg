# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.txt.
from django.conf.urls.defaults import patterns
from django.conf.urls.defaults import url
from django.contrib import admin

from lizard_svg.api.views import Bootstrap
from lizard_svg.api.views import Update

admin.autodiscover()

urlpatterns = patterns(
    '',
    url(r'^bootstrap/$',
        Bootstrap.as_view(),
        name='lizard_svg_api_bootstrap'),
    url(r'^update/$',
        Update.as_view(),
        name='lizard_svg_api_update'),
    )
