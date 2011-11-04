from djangorestframework.views import View
from random import uniform
import time


class Bootstrap(View):
    """
    REST view for timeseries.
    """

    colors = ['#000000', '#00e600']
    statusindicator = ['url(#pomp.uit)', 'url(#pomp.aan)']
    overstortindicator = ['url(#ArrowBlack)', 'url(#ArrowRed)']

    def get(self, request):
        result = []
        level = 0
        while level < 256:
            value = ''
            if request.GET['item'].endswith(":Status.indicator"):
                value = self.statusindicator[int(uniform(0, len(self.statusindicator)))]
            elif request.GET['item'].endswith(":overstort.indicator"):
                value = self.overstortindicator[int(uniform(0, len(self.overstortindicator)))]
            elif request.GET['group'] in ['style:stroke', 'style:fill']:
                value = self.colors[int(uniform(0, len(self.colors)))]
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
