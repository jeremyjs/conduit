@renderBarLineChart = (chart, options = {}) ->
  $.extend true, options,
    data:
      groups: chart["groups"]
  renderChart(chart, options)

