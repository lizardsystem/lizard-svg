from djangorestframework.views import View
from random import uniform, choice
import time
from lizard_fewsnorm.models import TimeSeriesCache
from lizard_fewsnorm.models import Event
from lizard_fewsnorm.models import Series
from lizard_fewsnorm.models import Location
from lizard_fewsnorm.models import Parameter
from lizard_fewsnorm.models import ParameterCache
from lizard_fewsnorm.models import GeoLocationCache
from timeseries import timeseries


class Bootstrap(View):
    """
    REST view for timeseries.
    """

    status_colors = ['Black', 'Green']
    overstort_colors = ['Black', 'Red']

    def get(self, request):
        try:
            l_id, p_id = request.GET['item'].split(':')
            ## we need first find out the containing database
            location_pointer = GeoLocationCache.objects.get(ident=l_id)
            db_name = location_pointer.fews_norm_source.database_name
            ## now we can access the series
            filtered_series = Series.objects.using(db_name).filter(location__id=l_id, 
                                                                   parameter__id=p_id)
            tsd = timeseries.TimeSeries.as_dict(filtered_series)
            return tsd[l_id, p_id].events.items()
        except:
            pass

        result = []
        level = 0

        while level < 256:
            value = ''

            if request.GET['group'] in ['style:marker-end', 'style:marker-start']:
                value = choice(self.status_colors)
            elif request.GET['item'].endswith(":overstort.indicator"):
                value = choice(self.overstort_colors)
            elif request.GET['item'].endswith(".indicator"):
                value = choice(self.status_colors)
            elif request.GET['group'] in ['style:stroke', 'style:fill']:
                value = choice(self.status_colors)
            elif request.GET['group'] in ['height']:
                value = str(12.5 * int(uniform(0, 8)))
            result.append({'item': request.GET['item'],
                           'timestamp': level,
                           'value': value,
                           })
            level += int(uniform(0, 64))
        time.sleep(uniform(0.01, 0.05))  # faking database latency
        return result


class Update(View):
    """
    REST view for timeseries.
    """

    colors = ['#000000', '#00e600']

    def post(self, request):
        ## retrieve keys
        keys = [v for (k, v) in request.POST.items() if k.startswith('keys')]
        ## retrieve timestamp
        now = request.POST['timestamp']

        ## SELECT key, value FROM rioolgemalen
        ##   JOIN (SELECT key, max(timestamp) AS timestamp
        ##           FROM rioolgemalen
        ##          WHERE key in (%keys%)
        ##            AND timestamp < %now%
        ##       GROUP BY key) latest ON rioolgemalen.key = latest.key
        ##                           AND rioolgemalen.timestamp = latest.timestamp
        ##
        time.sleep(0.5)  # faking database latency
        return dict((k, int(uniform(0, 64))) for k in keys)

    def get(self, request):
        keys = request.GET['keys'].split(',')
        return keys
