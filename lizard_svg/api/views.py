from djangorestframework.views import View
from random import uniform


class Bootstrap(View):
    """
    REST view for timeseries.
    """

    colors = ['#000000', '#00e600']

    def get(self, request):
        result = []
        level = 0
        while level < 256:
            result.append({'item': request.GET['item'],
                           'timestamp': level,
                           'color': self.colors[int(uniform(0, len(self.colors)))],
                           })
            level += int(uniform(0, 64))
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
        return dict((k, int(uniform(0, 64))) for k in keys)

    def get(self, request):
        keys = request.GET['keys'].split(',')
        return keys
