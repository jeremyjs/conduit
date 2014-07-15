@renderChart = (id) ->
  id = id[1] if id[0] == '#'
  chart_data = getChartData(id)
  titles = getTitles(chart_data)
  types = getTypes(chart_data)
  columns = getColumns(chart_data)
  colors = getColors(chart_data)
  chart =
    bindto: "#chart-#{id}"
    data:
      titles: titles
      columns: columns
      types: types
      colors: colors
    axis:
      y2:
        show: if chart_data[0]["y2"] then true else false
    zoom:
      enabled: true
  c3.generate(chart)
