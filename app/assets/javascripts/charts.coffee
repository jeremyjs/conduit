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
    ret[graph.name] = graph[attr]
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

