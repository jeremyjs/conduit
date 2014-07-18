@charts = {}

@getChartData = (id) ->
  data = null
  $.ajax
    url: "/graphs/#{id}.json"
    async: false
    success: (response) ->
      data = response
  data

@getValsByAttr = (data_array, attr) ->
  ret = {}
  for graph in data_array
    ret[graph.provider] = graph[attr]
  ret

@getId = (name) ->
  name.slice(-1)

@barChartOptions = (chart, options = {}) ->
  $.extend true, options,
    data:
      type: 'bar'
    bar:
      width:
        ratio: chart['bar']['ratio']
        width: chart['bar']['width']
  options

@renderBarLineChart = (chart, options = {}) ->
  $.extend true, options,
    data:
      groups: chart["groups"]
  renderChart(chart, options)

@renderTimeseriesChart = (chart, options = {}) ->
  $.extend true, options,
    data:
      x: 'x'
    axis:
      x:
        type: 'timeseries'
        tick:
          format: '%Y-%m-%d'
  renderChart(chart, options)

@renderChart = (chart, options = {}) ->
  id = chart["id"]
  chart_data = chart["data"]
  c3_chart =
    bindto: "#chart-#{id}"
    data:
      # titles: getValsByAttr(chart_data, "name")
      columns: chart_data
      # types: getValsByAttr(chart_data, "type")
    axis:
      y2:
        show: if chart["y2"] then true else false
    zoom:
      enabled: true
    color:
      pattern: ['#1f77b4', '#aec7e8', '#ff7f0e', '#ffbb78', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
  $.extend(true, c3_chart, options)
  c3.generate(c3_chart)

