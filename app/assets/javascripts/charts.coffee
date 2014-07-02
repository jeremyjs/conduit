@charts = {}

@chartAjax = (id) ->
  data = null
  $.ajax
    url: "/graphs/#{id}.json"
    async: false
    success: (response) ->
      data = response
  return data

getTitles = (data_array) ->
  titles = {}
  for graph in data_array
    titles[graph.name] = graph.name
  return titles

getTypes = (data_array) ->
  types = {}
  for graph in data_array
    types[graph.name] = graph.type
  return types

# return [["column1", 1, 6... ], ["column2", 2, 5... ]]
getDataColumns = (data_array) ->
  columns = []
  for graph in data_array
    value_hashes = graph.values
    data_column = []
    data_column.push(graph.name)
    for value_hash in value_hashes
      data_column.push(value_hash.value)
    columns.push(data_column)
  return columns

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
  return chart

@siblingHeight = ($panel, $chart) ->
  sum = 0
  $panel.children().not($chart).each( ->
    sum += $(this).outerHeight(true)
  )
  return sum

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
