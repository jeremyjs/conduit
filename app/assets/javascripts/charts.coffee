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

@filter_hash = (chart, filter) ->
  switch filter
    when "bar"
      data:
        type: "bar"
        groups: [] # chart["groups"]
      bar:
        width:
          ratio: chart['bar_ratio'] || 0.5
    when "bar_line"
      data:
        groups: chart["groups"]
    when "timeseries"
      data:
        x: 'x'
      axis:
        x:
          type: 'timeseries'
          tick:
            format: '%Y-%m-%d'
    else {}

@renderChart = (chart, options = {}) ->
  filters = chart.filters.concat ['timeseries']
  $.each filters, ->
    filter = "" + this
    $.extend true, options, filter_hash(chart, filter)
  c3_chart =
    bindto: "#chart-#{chart["id"]}"
    data:
      columns: chart["data"]
    axis:
      y2:
        show: if chart["y2"] then true else false
    zoom:
      enabled: true
    color:
      pattern: ['#1f77b4', '#aec7e8', '#ff7f0e', '#ffbb78', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
    tooltip:
      grouped: false
  $.extend(true, c3_chart, options)
  c3.generate(c3_chart)

