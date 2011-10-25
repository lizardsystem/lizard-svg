from djangorestframework.views import View
from random import uniform


class TimeseriesView(View):
    """
    REST view for timeseries.
    """

    colors = ['#000000', '#00e600']

    def get(self, request):
        result = []
        level = 0
        while level < 256:
            result.append({'item': request.REQUEST['item'],
                           'timestamp': level,
                           'color': self.colors[int(uniform(0, len(self.colors)))],
                           })
            level += int(uniform(0, 64))
        return result
