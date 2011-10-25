from djangorestframework.views import View
from random import uniform


class TimeseriesView(View):
    """
    REST view for timeseries.
    """

    colors = ['#ff7f00', '#7f00ff', '#000000', '#00ff7f']
    def get(self, request):
        result = []
        level = 0
        while level < 256:
            result.append({'item': request.REQUEST['item'],
                           'timestamp': level,
                           'color': self.colors[int(uniform(0, 4))],
                           })
            level += int(uniform(0, 64))
        return result
