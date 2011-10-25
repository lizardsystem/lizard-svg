# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.txt.
from django.conf.urls.defaults import patterns
from django.conf.urls.defaults import url
from django.contrib import admin

from lizard_svg.api.views import TimeseriesView

admin.autodiscover()

urlpatterns = patterns(
    '',
    url(r'^$',
        TimeseriesView.as_view(),
        name='lizard_svg_api_timeseries'),
    )
