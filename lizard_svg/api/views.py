from djangorestframework.views import View
from random import uniform, choice
import time
from lizard_fewsnorm.models import Event
from lizard_fewsnorm.models import Series
from lizard_fewsnorm.models import GeoLocationCache
from timeseries import timeseries
from datetime import datetime


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
        first, last = 1234567890000, 1243567890000
        level = first

        while level < last:
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
            level += int(uniform(0, (last - first)/4))
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
        deadline = request.POST['timestamp']

        time.sleep(0.5)  # faking database latency
        return dict((k, int(uniform(0, 64))) for k in keys)

    def get(self, request):
        deadline = datetime.strptime(request.GET['timestamp'], "%Y-%m-%dT%H:%M:%S")
        lppairs = [tuple(k.split(':')) for k in request.GET['keys'].split(',')]
        filtered_series = Series.from_lppairs(lppairs)
        if filtered_series:
            e = Event.filter_latest_before_deadline(filtered_series, deadline)
            return list(e)
        else:
            return None
