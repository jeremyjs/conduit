@charts = {}

@chartAjax = (id) ->
  data = null
  $.ajax
    url: "/graphs/#{id}.json"
    async: false
    success: (response) ->
      data = response
  data

getTitles = (data_array) ->
  titles = {}
  for graph in data_array
    titles[graph.name] = graph.name
  titles

getTypes = (data_array) ->
  types = {}
  for graph in data_array
    types[graph.name] = graph.type
  types

# return [["column1", 1, 6... ], ["column2", 2, 5... ]]
getDataColumns = (data_array) ->
  columns = []
  for graph in data_array
    value_hashes = graph.values
    data_column = [ graph.name ]
    for value_hash in value_hashes
      data_column.push(value_hash.value)
    columns.push(data_column)
  columns

@getChart = (id) ->
  data_array = chartAjax(id)
  titles = getTitles(data_array)
  types = getTypes(data_array)
  data = getDataColumns(data_array)
  chart =
    bindto: "#chart-#{id}"
    data:
      columns: data
      axes:
        DescriptiveQueryName: 'y'
        DescriptiveQueryName2: 'y2'
      types: types
    axis:
      y2:
        show: true

@siblingHeight = ($panel, $chart) ->
  $panel.children().not($chart).get().reduce (sum, self) ->
    sum + $(self).outerHeight(true)
  , 0

@drawChart = (name, chart) ->
  chart = @charts[name] unless chart
  $chart_elem = $(name)
  new_height = calculateHeight($chart_elem)
  chart.resize({ height: new_height })

@generateCharts = ->
  $(".chart").each ->
    name = '#' + this.id
    id = this.id.substring(6)
    chart = getChart(id)
    charts[name] = c3.generate(chart)
