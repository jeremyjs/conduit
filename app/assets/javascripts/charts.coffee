@charts = {}

@getChartData = (id) ->
  data = null
  $.ajax
    url: "/graphs/#{id}.json"
    async: false
    success: (response) ->
      data = response
  console.log data
  data

@getValsByAttr = (data_array, attr) ->
  ret = {}
  for graph in data_array
    ret[graph.provider] = graph[attr]
  ret

# return [["column1", 1, 6... ], ["column2", 2, 5... ]]
@getColumns = (data_array) ->
  columns = []
  for graph in data_array
    value_hashes = graph.values
    data_column = [ graph.name ]
    for value_hash in value_hashes
      data_column.push(value_hash.value)
    columns.push(data_column)
  columns

@getId = (name) ->
  name.slice(-1)

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

