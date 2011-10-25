import datetime
from djangorestframework.views import View


class TimeseriesView(View):
    """
    REST view for timeseries.
    """
    def get(self, request):
        return [
            {'datetime': datetime.datetime.now(), 'value': 3.14159265},
            {'datetime': datetime.datetime.now(), 'value': 2.71828183},
            {'datetime': datetime.datetime.now(), 'value': 1.61803666},]
