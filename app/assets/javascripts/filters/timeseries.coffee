@renderTimeseriesChart = (chart, options = {}) ->
  bar_options =
    data:
      type: 'bar'
    bar:
      width:
        ratio: chart['bar']['ratio']
        width: chart['bar']['width']
  $.extend(true, chart, options)
  c3.generate(chart)

