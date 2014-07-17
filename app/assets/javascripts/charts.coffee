@charts = {}

@getChartData = (id) ->
  data = null
  $.ajax
    url: "/graphs/#{id}.json"
    async: false
    success: (response) ->
      data = response
  data

@getTitles = (data_array) ->
  titles = {}
  for graph in data_array
    titles[graph.name] = graph.name
  titles

@getTypes = (data_array) ->
  types = {}
  for graph in data_array
    types[graph.name] = graph.type
  types

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

@getColors = (data_array) ->
  colors = {}
  for graph in data_array
    colors[graph.name] = graph.color
  colors

@getId = (name) ->
  name.slice(-1)

