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

@calculateHeight = ($chart) ->
  $parent = $chart.parents('.grid-item').first()
  $panel = $parent.find('.panel-body')
  $panel_header = $parent.find('.panel-heading')
  parent_height = $parent.height()
  header_height = $panel_header.outerHeight()
  panel_padding_height = $panel.outerHeight() - $panel.height()
  panel_height = parent_height - header_height - panel_padding_height
  sibling_height = siblingHeight($panel, $chart)

  panel_height - sibling_height


@drawWidgets = () ->
  for name, chart of @charts
    drawChart(name, chart)

$ ->
  chart1 = c3.generate(getChart(1))
  chart2 = c3.generate(getChart(2))
  chart3 = c3.generate(getChart(3))
  @charts =
    "#chart-1": chart1
    "#chart-2": chart2
    "#chart-3": chart3
  drawWidgets()

