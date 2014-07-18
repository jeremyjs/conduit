@renderSingleProviderChart = (chart, options = {}) ->
  $.extend true, options,
    data:
      x: 'x'
    axis:
      x:
        type: 'timeseries'
        tick:
          format: '%Y-%m-%d'
  renderChart(chart, options)

